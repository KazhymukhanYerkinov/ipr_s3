# Цель 3: Многопоточность — Isolate и compute

## Теория (что спросят)

### Модель параллелизма Dart

Dart — **однопоточный** язык. Один main isolate с одним Event Loop. Это значит:

```
async/await — это НЕ многопоточность!
```

`async/await` просто откладывает выполнение в Event Loop. Если внутри `Future` есть тяжёлые вычисления — они блокируют UI:

```dart
// ЭТО ЗАБЛОКИРУЕТ UI! Несмотря на async
Future<int> heavyWork() async {
  var sum = 0;
  for (var i = 0; i < 1000000000; i++) {
    sum += i;
  }
  return sum;
}
```

### Что такое Isolate?

**Isolate** — это отдельный поток выполнения со своей памятью (heap). Isolates **не делят память** — общаются только через сообщения (SendPort/ReceivePort).

```
Main Isolate                    Background Isolate
┌──────────┐                    ┌──────────┐
│ UI Thread │ ←─ SendPort ──→  │ Тяжёлая  │
│ Event Loop│    ReceivePort    │ работа   │
│ Rendering │                    │ Свой heap│
└──────────┘                    └──────────┘
```

**Ограничения Isolate**:
- Нельзя обращаться к UI (нет доступа к BuildContext, виджетам)
- Данные передаются **копированием** (кроме TransferableTypedData)
- Функция для Isolate должна быть **top-level** или **static** (не метод экземпляра)

### compute() vs Isolate.spawn()

| | `compute()` | `Isolate.spawn()` |
|---|---|---|
| Сложность | Простой | Сложнее |
| Коммуникация | Один вход → один выход | Двусторонняя (SendPort/ReceivePort) |
| Жизненный цикл | Создаётся → выполняет → умирает | Живёт пока не закроешь |
| Когда использовать | Разовая тяжёлая задача | Длительный фоновый процесс |

### Event Loop

```
┌─────────────────────────────────────────┐
│              Event Loop                  │
│                                          │
│  1. Проверить Microtask Queue           │
│     └── Future.then(), scheduleMicrotask │
│  2. Если пусто → Event Queue            │
│     └── Timer, I/O, UI events, Future   │
│  3. Повторить                            │
│                                          │
│  Microtask ВСЕГДА приоритетнее Event    │
└─────────────────────────────────────────┘
```

---

## Что реализовано в проекте

### 1. compute() — Шифрование файлов

**Файл**: `lib/features/files/data/services/file_encryption_service.dart`

```dart
// Top-level функция (обязательно для compute!)
Uint8List encryptBytes(EncryptionParams params) {
  final key = enc.Key(params.key);
  final iv = enc.IV.fromSecureRandom(16);
  final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
  final encrypted = encrypter.encryptBytes(params.data, iv: iv);

  // Prepend IV к зашифрованным данным (нужен для дешифровки)
  final result = Uint8List(iv.bytes.length + encrypted.bytes.length);
  result.setRange(0, iv.bytes.length, iv.bytes);
  result.setRange(iv.bytes.length, result.length, encrypted.bytes);
  return result;
}

// Вызов через compute() — в отдельном изоляте
class FileEncryptionService {
  Future<Uint8List> encrypt(Uint8List data) async {
    final key = await _encryptionHelper.getEncryptionKey();
    return compute(encryptBytes, EncryptionParams(data: data, key: key));
  }
}
```

**Почему top-level функция?**
- `compute()` передаёт функцию в другой Isolate
- Isolate не имеет доступа к объектам из main isolate
- Поэтому функция должна быть **top-level** (не метод класса) — она не зависит от `this`

**Почему именно compute() для шифрования?**
- Шифрование AES-256 файла 10MB — тяжёлая CPU-операция
- Если делать на main thread — UI зависнет на секунды
- `compute()` идеален: один вход (данные + ключ) → один выход (зашифрованные данные)

### 2. Isolate.spawn() — Поиск файлов

**Файл**: `lib/features/files/data/services/file_search_service.dart`

Это более сложный вариант — **двусторонняя связь**:

```dart
// Entry point для background isolate
void _searchIsolateEntry(SendPort mainSendPort) {
  // Создаём свой ReceivePort для получения сообщений от main
  final workerReceivePort = ReceivePort();
  // Отправляем свой SendPort обратно в main
  mainSendPort.send(workerReceivePort.sendPort);

  // Слушаем запросы от main isolate
  workerReceivePort.listen((message) {
    if (message is SearchRequest) {
      final query = message.query.toLowerCase();

      // Поиск по имени и тегам
      final matched = message.filesData.where((fileData) {
        final name = (fileData['name'] as String).toLowerCase();
        final tags = (fileData['tags'] as List).map((t) => t.toString().toLowerCase());
        return name.contains(query) || tags.any((tag) => tag.contains(query));
      }).toList();

      // Отправляем результат обратно в main
      mainSendPort.send(SearchResult(query: message.query, matchedFiles: matched));
    }

    if (message == 'close') {
      workerReceivePort.close();
      Isolate.exit();
    }
  });
}
```

**Процесс инициализации**:
```
Main Isolate                         Search Isolate
     │                                     │
     │ ── Isolate.spawn(entry, mainSP) ──→ │  создание
     │                                     │
     │ ←── workerSendPort ────────────────  │  handshake
     │                                     │
     │ ── SearchRequest ─────────────────→  │  запрос
     │                                     │
     │ ←── SearchResult ─────────────────── │  результат
     │                                     │
     │ ── 'close' ───────────────────────→  │  завершение
```

**Почему Isolate.spawn(), а не compute()?**
- Isolate **живёт** — не создаётся заново на каждый поиск
- Поддерживает **много запросов** — пользователь вводит текст, каждый keystroke отправляет новый запрос
- **Двусторонняя связь** — можно отправлять и получать данные в любой момент

**Почему данные передаются как Map, а не как объекты?**
- Между Isolates нельзя передавать произвольные объекты (кроме примитивов и transferable)
- Поэтому SecureFileEntity → Map<String, dynamic> → передача → обратно в SecureFileEntity
- Это ограничение архитектуры Isolate

### 3. compute() — Генерация thumbnail

**Файл**: `lib/features/files/data/services/thumbnail_service.dart`

Превью изображений генерируется в фоне:
- Декодирует изображение
- Ресайзит до маленького размера
- Всё через `compute()` чтобы не блокировать UI

### 4. Безопасное завершение

```dart
void dispose() {
  _workerSendPort?.send('close');   // Говорим изоляту "заверши работу"
  _subscription?.cancel();           // Отписываемся от потока
  _mainReceivePort?.close();         // Закрываем свой порт
  _isolate?.kill(priority: Isolate.immediate); // На случай если не ответил
  _resultController.close();         // Закрываем StreamController
}
```

---

## Возможные вопросы на ассесменте

**В**: Чем Isolate отличается от Thread?
**О**: Thread делит память с другими потоками (shared memory). Isolate имеет собственный heap — изолированную память. Нет race conditions, нет mutex/lock, но данные передаются копированием через порты.

**В**: Почему функция для compute() должна быть top-level?
**О**: compute() отправляет функцию в другой Isolate. Метод экземпляра (`this.method()`) зависит от `this` — объекта из main isolate. Другой Isolate не имеет к нему доступа. Top-level функция не зависит ни от чего — можно безопасно передать.

**В**: Что произойдёт если выполнить шифрование на main thread?
**О**: UI зависнет. Flutter не сможет рендерить кадры пока CPU занят шифрованием. Пользователь увидит freeze. Для файла 10MB это может быть несколько секунд.

**В**: Как передаются данные между Isolates?
**О**: Через SendPort/ReceivePort. Данные копируются (не по ссылке). Передавать можно: примитивы (int, String, bool), List, Map, Uint8List. Нельзя: произвольные объекты, closure, функции (кроме top-level).

**В**: Разница между compute() и Isolate.spawn()?
**О**: compute() — одноразовый: создал Isolate → передал данные → получил результат → Isolate умер. Isolate.spawn() — долгоживущий: создал → отправляешь много запросов → закрываешь когда не нужен. В проекте: compute() для шифрования (разовая задача), Isolate.spawn() для поиска (много запросов подряд).

**В**: Что будет если в Isolate произойдёт ошибка?
**О**: Ошибка не поднимется в main isolate автоматически. Нужно обрабатывать: ловить try-catch внутри Isolate и отправлять ошибку через SendPort, или использовать errorsAreFatal + Isolate.addErrorListener. В compute() ошибка автоматически пробрасывается как Future.error.
