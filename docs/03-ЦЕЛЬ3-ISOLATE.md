# Цель 3: Многопоточность через Isolate и compute

## Теория

### Dart — однопоточный язык?

Dart **не многопоточный** в традиционном смысле. Один Isolate = один поток =
один event loop. Но можно создать **несколько Isolate** — каждый со своим heap.

```
┌─────────────────┐      ┌─────────────────┐
│  Main Isolate    │      │  Worker Isolate  │
│                  │      │                  │
│  ┌─── Heap ───┐ │      │  ┌─── Heap ───┐ │
│  │ Widget tree │ │      │  │ свои данные │ │
│  │ BLoC states │ │ ←──→ │  │ нет UI     │ │
│  │ controllers │ │ Send/ │  │ нет plugins│ │
│  └────────────┘ │ Recv  │  └────────────┘ │
│                  │ Port  │                  │
│  Event Loop      │      │  Event Loop      │
└─────────────────┘      └─────────────────┘
```

### Ключевые ограничения Isolate

1. **Отдельный heap** — нет shared memory (нет data races, нет mutex!)
2. **Общение через сообщения** — `SendPort` / `ReceivePort`
3. **Только примитивы и transferable** — нельзя передавать closures, sockets, plugins
4. **Нет доступа к UI** — нельзя обращаться к `BuildContext`, `Widget`, `RenderObject`
5. **Нет доступа к platform plugins** — plugin bindings привязаны к main isolate

### Event Loop

```
       ┌───────────────────────────────┐
       │        Event Loop             │
       │                               │
       │  1. Microtask Queue (first)   │ ← Future.then(), scheduleMicrotask
       │     [micro1] [micro2] ...     │
       │                               │
       │  2. Event Queue (second)      │ ← Timer, I/O, UI events, SendPort
       │     [event1] [event2] ...     │
       │                               │
       │  Каждый event = run-to-       │
       │  completion (не прерывается)  │
       └───────────────────────────────┘
```

Если event занимает >16ms — frame drop (jank). Решение: вынести в другой Isolate.

### compute() vs Isolate.spawn()

| Характеристика | `compute()` | `Isolate.spawn()` |
|----------------|-------------|-------------------|
| Жизненный цикл | One-shot: создан → выполнил → уничтожен | Persistent: живёт пока не закроешь |
| Связь | Один вход, один выход | Двусторонняя (SendPort/ReceivePort) |
| Простота API | Очень просто | Нужно настраивать порты |
| Overhead | ~5–10ms на spawn каждый раз | Один раз, потом переиспользуется |
| Подходит для | Шифрование, thumbnail, парсинг | Поиск, стриминг данных, worker pool |

---

## Практика — что реализовано

### 1. `compute()` — шифрование файлов

**Файл:** `lib/features/files/data/services/file_encryption_service.dart`

```dart
// Top-level функция — ОБЯЗАТЕЛЬНО вне класса
Uint8List encryptBytes(EncryptionParams params) {
  final key = enc.Key(params.key);
  final iv = enc.IV.fromSecureRandom(16);
  final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));

  final encrypted = encrypter.encryptBytes(params.data, iv: iv);

  // IV + encrypted data → один массив
  final result = Uint8List(iv.bytes.length + encrypted.bytes.length);
  result.setRange(0, iv.bytes.length, iv.bytes);
  result.setRange(iv.bytes.length, result.length, encrypted.bytes);
  return result;
}

// В классе FileEncryptionService
Future<Uint8List> encrypt(Uint8List data) async {
  final key = await _encryptionHelper.getEncryptionKey();
  return compute(encryptBytes, EncryptionParams(data: data, key: key));
}
```

#### Почему top-level функция

`compute()` = `Isolate.spawn` под капотом. Новый Isolate — новый heap.
Он **не может** получить доступ к полям экземпляра или замыканиям из main isolate.

```dart
// ❌ НЕ РАБОТАЕТ — метод экземпляра захватывает this
class Bad {
  final Key key;
  Uint8List encrypt(Uint8List data) { /* использует this.key */ }
}
await compute(bad.encrypt, data); // Error: closure cannot be sent

// ✅ РАБОТАЕТ — top-level или static, нет контекста
Uint8List encryptBytes(EncryptionParams params) { ... }
await compute(encryptBytes, params);
```

#### Почему `compute()`, а не await на main thread

AES-256 шифрование 10 МБ ≈ 200–500ms. Это блокирует event loop:

```
Без compute():
  Frame 1 (16ms) → encrypt() БЛОКИРУЕТ → Frame 2 (16ms) → ...
  [====================] 500ms jank!

С compute():
  Frame 1 → Frame 2 → Frame 3 → ... (UI отзывчив)
  Background:  [encrypt() работает в другом Isolate]
  Frame 30 → result ready → обновляем UI
```

#### Под капотом compute()

```dart
// Flutter foundation (упрощённо)
Future<R> compute<M, R>(FutureOr<R> Function(M) callback, M message) async {
  final receivePort = ReceivePort();
  final isolate = await Isolate.spawn(
    _computeEntryPoint<M, R>,
    _ComputeMessage(callback, message, receivePort.sendPort),
  );
  final result = await receivePort.first;
  isolate.kill();           // ← уничтожаем после получения результата
  receivePort.close();
  return result;
}
```

1. Создаёт `ReceivePort` в main isolate
2. `Isolate.spawn()` — создаёт новый isolate
3. Передаёт функцию + данные (сериализуются/копируются)
4. Worker выполняет функцию, отправляет результат через `SendPort`
5. Main получает через `ReceivePort`
6. Worker isolate уничтожается

---

### 2. `Isolate.spawn()` — поиск с двусторонней связью

**Файл:** `lib/features/files/data/services/file_search_service.dart`

```dart
// Entry point для worker isolate
void _searchIsolateEntry(SendPort mainSendPort) {
  // 1. Создаём свой ReceivePort
  final workerReceivePort = ReceivePort();

  // 2. Отправляем свой SendPort обратно в main
  mainSendPort.send(workerReceivePort.sendPort);

  // 3. Слушаем входящие сообщения от main
  workerReceivePort.listen((message) {
    if (message is SearchRequest) {
      final query = message.query.toLowerCase();

      final matched = message.filesData.where((fileData) {
        final name = (fileData['name'] as String? ?? '').toLowerCase();
        final tags = (fileData['tags'] as List<dynamic>? ?? [])
            .map((t) => t.toString().toLowerCase());
        return name.contains(query) || tags.any((tag) => tag.contains(query));
      }).toList();

      // 4. Отправляем результат обратно в main
      mainSendPort.send(SearchResult(query: message.query, matchedFiles: matched));
    }

    if (message == 'close') {
      workerReceivePort.close();
      Isolate.exit();
    }
  });
}
```

#### Протокол двусторонней связи (handshake)

```
    Main Isolate                        Worker Isolate
    ────────────                        ──────────────
1.  mainReceivePort = ReceivePort()
2.  Isolate.spawn(entry, mainSendPort)  →  получает mainSendPort
3.                                          workerReceivePort = ReceivePort()
4.  mainReceivePort.listen(msg) ←─────── mainSendPort.send(workerSendPort)
5.  workerSendPort сохранён             

    Теперь двусторонняя связь:
6.  workerSendPort.send(SearchRequest)  →  workerReceivePort получает
7.  mainReceivePort получает  ←──────────  mainSendPort.send(SearchResult)
```

#### Инициализация в FileSearchService

```dart
Future<void> initialize() async {
  if (_isolate != null) return;  // idempotent

  _mainReceivePort = ReceivePort();
  _isolate = await Isolate.spawn(
    _searchIsolateEntry,
    _mainReceivePort!.sendPort,
  );

  final completer = Completer<SendPort>();

  _subscription = _mainReceivePort!.listen((message) {
    if (message is SendPort && !completer.isCompleted) {
      completer.complete(message);    // ← первое сообщение = workerSendPort
    } else if (message is SearchResult) {
      _resultController.add(message); // ← дальше — результаты поиска
    }
  });

  _workerSendPort = await completer.future;
}
```

#### Почему persistent Isolate для поиска

Пользователь вводит текст с debounce. Каждый символ → новый поисковый запрос.

```
Ввод: "d" → "do" → "doc" → "docu" → "docum"

С compute() (one-shot):
  spawn isolate → search "d" → kill → spawn → search "do" → kill → ...
  5 spawns × ~10ms = 50ms overhead

С Isolate.spawn() (persistent):
  spawn isolate (один раз)
  send "d" → result
  send "do" → result
  send "doc" → result
  ...
  0ms overhead на повторные запросы
```

---

### 3. `compute()` — генерация thumbnail

**Файл:** `lib/features/files/data/services/thumbnail_service.dart`

```dart
Uint8List? generateThumbnail(ThumbnailParams params) {
  final image = img.decodeImage(params.imageBytes);
  if (image == null) return null;

  final thumbnail = img.copyResize(
    image,
    width: params.maxWidth,    // 200px
    height: params.maxHeight,  // 200px
    maintainAspect: true,
  );

  return Uint8List.fromList(img.encodePng(thumbnail));
}

// В ThumbnailService
Future<Uint8List?> create(Uint8List imageBytes) async {
  try {
    return await compute(
      generateThumbnail,
      ThumbnailParams(imageBytes: imageBytes),
    );
  } catch (e, stackTrace) {
    _logger.error('Thumbnail generation failed', e, stackTrace);
    return null;  // ← graceful degradation
  }
}
```

#### Graceful degradation

Если thumbnail не сгенерировался (битое изображение, OOM, неподдерживаемый формат):
- Возвращаем `null`
- Файл импортируется **без превью**
- Приложение **не падает**

Вместо thumbnail показывается иконка типа файла.

---

### 4. Передача данных между Isolate

#### Что можно передавать

- Примитивы: `int`, `double`, `String`, `bool`, `null`
- `List`, `Map`, `Set` (рекурсивно примитивы)
- `Uint8List`, `Int32List` и другие typed data
- `SendPort`
- Классы с полями из вышеперечисленного (копируются по значению)

#### Что НЕЛЬЗЯ передавать

```dart
// ❌ Closures
final fn = () => print('hello');
sendPort.send(fn); // Error

// ❌ Sockets, HttpClient
sendPort.send(httpClient); // Error

// ❌ Platform channels
sendPort.send(methodChannel); // Error (привязан к main isolate)
```

#### Почему Map вместо SecureFileEntity в search

```dart
// В FileSearchService — конвертируем в Map перед отправкой
final filesData = files.map((f) => {
  'id': f.id,
  'name': f.name,
  'typeIndex': f.type.index,
  'size': f.size,
  // ...
}).toList();
```

`SecureFileEntity` — обычный Dart-класс с примитивными полями. Его можно передать.
Но `Map<String, dynamic>` — более явный контракт. Worker Isolate не зависит от
domain-модели, работает с raw data.

---

### 5. Корректное завершение Isolate

```dart
void dispose() {
  _workerSendPort?.send('close');    // 1. Просим worker завершиться
  _subscription?.cancel();            // 2. Отменяем подписку
  _mainReceivePort?.close();          // 3. Закрываем порт
  _isolate?.kill(priority: Isolate.immediate); // 4. Убиваем isolate
  _resultController.close();          // 5. Закрываем StreamController
  _isolate = null;
  _workerSendPort = null;
}
```

#### Почему и send('close'), и kill()

`send('close')` — graceful shutdown: worker закрывает свой ReceivePort и вызывает
`Isolate.exit()`. Но если worker завис — `kill()` как fallback.

`Isolate.immediate` — убить немедленно, не дожидаясь текущего event.

---

## Обработка ошибок в Isolate

### compute() — ошибки пробрасываются

```dart
Future<Uint8List?> create(Uint8List imageBytes) async {
  try {
    return await compute(generateThumbnail, ThumbnailParams(...));
  } catch (e, stackTrace) {
    _logger.error('Thumbnail generation failed', e, stackTrace);
    return null;  // fallback
  }
}
```

Если `generateThumbnail` бросает исключение внутри Isolate, `compute()` **пробрасывает**
его в main isolate. `try/catch` в main ловит его.

### Isolate.spawn() — uncaught errors

```dart
_isolate = await Isolate.spawn(
  _searchIsolateEntry,
  _mainReceivePort!.sendPort,
  onError: _mainReceivePort!.sendPort,  // ← можно добавить обработку ошибок
);
```

---

## Benchmark — сравнение производительности

**Файл:** `lib/features/benchmark/presentation/bloc/benchmark_bloc.dart`

Сравниваем 3 подхода на 1/5/10 МБ данных:

```dart
// 1. Dart CRC32 на main thread
final dartMs = await _benchmarkDartCrc32(data);

// 2. C (FFI) CRC32 на main thread
final nativeMs = _benchmarkNativeCrc32(data);

// 3. Dart CRC32 в Isolate
final isolateMs = await _benchmarkIsolateCrc32(data);
```

Типичные результаты:

| Размер | Dart (main) | C FFI (main) | Dart (Isolate) |
|--------|-------------|--------------|----------------|
| 1 MB   | ~45ms       | ~8ms         | ~50ms          |
| 5 MB   | ~220ms      | ~40ms        | ~230ms         |
| 10 MB  | ~440ms      | ~80ms        | ~450ms         |

**Выводы:**
- C FFI быстрее Dart в ~5× (нет GC overhead, нативная оптимизация)
- Isolate **не ускоряет** — та же скорость + overhead spawn
- Isolate **разгружает main thread** — UI не тормозит

---

## Критерии приёмки — чеклист

- [x] `compute()` используется для шифрования и thumbnail
- [x] `Isolate.spawn()` с двусторонней связью для поиска
- [x] Приложение остаётся отзывчивым при обработке больших файлов
- [x] Нет ошибок при передаче данных (примитивы + typed data)
- [x] Корректное завершение Isolate (dispose, close, kill)
- [x] Graceful degradation при ошибках в Isolate
- [x] Benchmark: main thread vs Isolate, Dart vs C
