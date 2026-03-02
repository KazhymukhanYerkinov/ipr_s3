# Цель 7: Интеграция с нативными модулями — Method Channels и FFI

## Теория

### Архитектура Flutter Engine

```
┌──────────────────────────────────────────────────────┐
│                    Flutter App (Dart)                  │
│   Widgets → Elements → RenderObjects → Layer Tree     │
├──────────────────────────────────────────────────────┤
│                   Flutter Engine (C++)                 │
│   Skia (рисование) │ Dart VM │ Platform Channels      │
├──────────────────────────────────────────────────────┤
│                Platform Embedder                      │
│   Android (Java/Kotlin) │ iOS (ObjC/Swift) │ etc.    │
└──────────────────────────────────────────────────────┘
```

### Три типа каналов

| Канал | Назначение | Паттерн |
|-------|-----------|---------|
| `MethodChannel` | Request-Response (вызвал → получил ответ) | RPC |
| `EventChannel` | Stream (подписка на поток событий) | Pub/Sub |
| `BasicMessageChannel` | Простой обмен сообщениями | Message passing |

Мы используем **MethodChannel** — самый распространённый. Паттерн RPC:
Dart вызывает метод → нативный код выполняет → возвращает результат.

### MethodCodec

Данные между Dart и нативным кодом кодируются через **codec**:

| Codec | Формат | Поддерживаемые типы |
|-------|--------|---------------------|
| `StandardMethodCodec` (default) | Бинарный | null, bool, int, double, String, Uint8List, List, Map |
| `JSONMethodCodec` | JSON string | То же + Date, но медленнее |

Мы используем default `StandardMethodCodec` — быстрее JSON, поддерживает typed data.

### FFI (Foreign Function Interface)

```
┌─────────────────┐        ┌─────────────────┐
│   Dart код       │        │   C-библиотека  │
│                  │  FFI   │                  │
│   dart:ffi       │───────>│   .so / .dylib   │
│   Pointer<T>     │        │                  │
│   DynamicLibrary │        │   native_crc32() │
└─────────────────┘        └─────────────────┘
```

FFI — **прямой вызов** C-функций из Dart. Без сериализации, без каналов.
Быстрее MethodChannel, но только для C/C++ (нет Java/Swift).

---

## Практика — MethodChannel

### Dart-сторона

**Файл:** `lib/core/platform/device_info_channel.dart`

```dart
@lazySingleton
class DeviceInfoChannel {
  static const _channel = MethodChannel('com.filesecure/device_info');
  final _logger = SecureLogger();

  Future<int?> getBatteryLevel() =>
      _invokeInt('getBatteryLevel', 'Battery level');

  Future<int?> getFreeStorage() =>
      _invokeInt('getFreeStorage', 'Free storage');

  Future<int?> getTotalStorage() =>
      _invokeInt('getTotalStorage', 'Total storage');

  Future<int?> _invokeInt(String method, String label) async {
    try {
      return await _channel.invokeMethod<int>(method);
    } on PlatformException catch (e) {
      _logger.warning('$label unavailable: ${e.code}');
      return null;  // graceful degradation
    } on MissingPluginException {
      _logger.warning('MethodChannel not available (platform unsupported)');
      return null;
    }
  }
}
```

#### Имя канала: `com.filesecure/device_info`

Формат: `com.company/feature` (reverse domain). Должно совпадать на Dart, Android и iOS.
Если не совпадает — `MissingPluginException`.

#### Graceful degradation

Два типа ошибок:
- `PlatformException` — нативный код вернул `result.error()` (батарея недоступна на эмуляторе)
- `MissingPluginException` — канал не зарегистрирован (desktop, web)

В обоих случаях возвращаем `null`, UI показывает "N/A". Приложение не падает.

---

### Android-сторона (Kotlin)

**Файл:** `android/app/src/main/kotlin/com/example/ipr_s3/MainActivity.kt`

```kotlin
class MainActivity : FlutterActivity() {
    companion object {
        private const val CHANNEL = "com.filesecure/device_info"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getBatteryLevel" -> handleGetBatteryLevel(result)
                "getFreeStorage" -> handleGetFreeStorage(result)
                "getTotalStorage" -> handleGetTotalStorage(result)
                else -> result.notImplemented()
            }
        }
    }
}
```

#### Получение батареи (BatteryManager)

```kotlin
private fun handleGetBatteryLevel(result: MethodChannel.Result) {
    try {
        val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        val level = batteryManager.getIntProperty(
            BatteryManager.BATTERY_PROPERTY_CAPACITY
        )
        if (level != -1) {
            result.success(level)  // → Dart получает int
        } else {
            result.error("UNAVAILABLE", "Battery level not available", null)
            // → Dart получает PlatformException(code: "UNAVAILABLE")
        }
    } catch (e: Exception) {
        result.error("ERROR", "Failed: ${e.message}", null)
    }
}
```

#### Получение storage (StatFs)

```kotlin
private fun handleGetFreeStorage(result: MethodChannel.Result) {
    try {
        val stat = StatFs(Environment.getDataDirectory().path)
        val freeBytes = stat.availableBlocksLong * stat.blockSizeLong
        result.success(freeBytes)  // Long → Dart int
    } catch (e: Exception) {
        result.error("ERROR", "Failed: ${e.message}", null)
    }
}
```

**StatFs** — Android API для информации о файловой системе:
- `availableBlocksLong` — количество свободных блоков
- `blockSizeLong` — размер одного блока (обычно 4096 bytes)
- Произведение = свободные байты

---

### iOS-сторона (Swift)

**Файл:** `ios/Runner/AppDelegate.swift`

```swift
@main
@objc class AppDelegate: FlutterAppDelegate {
    private let channelName = "com.filesecure/device_info"

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller = window?.rootViewController as! FlutterViewController

        let channel = FlutterMethodChannel(
            name: channelName,
            binaryMessenger: controller.binaryMessenger
        )

        channel.setMethodCallHandler { [weak self] (call, result) in
            switch call.method {
            case "getBatteryLevel":
                self?.handleGetBatteryLevel(result: result)
            case "getFreeStorage":
                self?.handleGetFreeStorage(result: result)
            case "getTotalStorage":
                self?.handleGetTotalStorage(result: result)
            default:
                result(FlutterMethodNotImplemented)
            }
        }

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
```

#### Батарея (UIDevice)

```swift
private func handleGetBatteryLevel(result: @escaping FlutterResult) {
    UIDevice.current.isBatteryMonitoringEnabled = true  // ← обязательно включить!
    let level = UIDevice.current.batteryLevel

    if level >= 0 {
        result(Int(level * 100))  // 0.85 → 85
    } else {
        result(FlutterError(
            code: "UNAVAILABLE",
            message: "Battery level not available (simulator or unsupported)",
            details: nil
        ))
    }
}
```

**Важно:** `isBatteryMonitoringEnabled = true` нужно вызвать **перед** чтением.
Без этого `batteryLevel` всегда вернёт `-1.0`.

`batteryLevel` возвращает `Float` 0.0–1.0, умножаем на 100 для процентов.

#### Storage (FileManager)

```swift
private func handleGetFreeStorage(result: @escaping FlutterResult) {
    do {
        let attrs = try FileManager.default.attributesOfFileSystem(
            forPath: NSHomeDirectory()
        )
        if let freeSize = attrs[.systemFreeSize] as? Int64 {
            result(freeSize)
        } else {
            result(FlutterError(code: "UNAVAILABLE", message: "...", details: nil))
        }
    } catch {
        result(FlutterError(
            code: "ERROR",
            message: "Failed: \(error.localizedDescription)",
            details: nil
        ))
    }
}
```

---

### Под капотом MethodChannel

```
Dart: _channel.invokeMethod('getBatteryLevel')
  │
  ▼
StandardMethodCodec.encodeMethodCall('getBatteryLevel', null)
  │  → binary: [7, 15, "getBatteryLevel", 0]
  ▼
Flutter Engine (C++) → BinaryMessenger
  │
  ▼
Platform Thread (НЕ UI thread!)
  │
  ▼
Android: MethodChannel.setMethodCallHandler
  │  → handleGetBatteryLevel(result)
  │  → result.success(85)
  ▼
StandardMethodCodec.encodeSuccessEnvelope(85)
  │  → binary: [0, 3, 85]
  ▼
Flutter Engine → Dart VM
  │
  ▼
Dart: Future<int> completes with 85
```

Вызов **асинхронный**: Dart не блокируется. `invokeMethod` возвращает `Future`.

---

### Почему MethodChannel, а не device_info_plus

| Подход | Плюсы | Минусы |
|--------|-------|--------|
| **MethodChannel** (наш выбор) | Полный контроль, любой нативный API, понимание как работает | Больше кода |
| **device_info_plus** пакет | Готовое решение, cross-platform | Абстракция поверх того же MethodChannel |

Цель ИПР — **понять механизм**, а не использовать готовое. Для продакшена обычно
используют пакеты. Но зная как работает MethodChannel, можно:
- Создать свой плагин для любого нативного API
- Отлаживать проблемы с существующими плагинами
- Понимать performance characteristics

---

## Практика — FFI (Foreign Function Interface)

### C-код

**Файл:** `native/src/hash_utils.c`

```c
/// CRC32 — проверка целостности файлов
uint32_t native_crc32(const uint8_t* data, int32_t length) {
    uint32_t crc = 0xFFFFFFFF;
    for (int32_t i = 0; i < length; i++) {
        crc ^= data[i];
        for (int j = 0; j < 8; j++) {
            crc = (crc >> 1) ^ (0xEDB88320 & (-(crc & 1)));
        }
    }
    return crc ^ 0xFFFFFFFF;
}

/// DJB2 — быстрый хеш для строк (дедупликация)
uint32_t native_djb2_hash(const char* str) {
    uint32_t hash = 5381;
    int c;
    while ((c = *str++)) {
        hash = ((hash << 5) + hash) + c;  // hash * 33 + c
    }
    return hash;
}

/// Подсчёт вхождений байта (анализ энтропии)
int32_t native_count_bytes(const uint8_t* data, int32_t length, uint8_t target) {
    int32_t count = 0;
    for (int32_t i = 0; i < length; i++) {
        if (data[i] == target) count++;
    }
    return count;
}
```

#### Алгоритм CRC32

CRC32 (Cyclic Redundancy Check) — не криптографический хеш, а **checksum для
обнаружения случайных повреждений данных**.

```
Полином: 0xEDB88320 (reflected IEEE 802.3)

Алгоритм (битовый):
1. crc = 0xFFFFFFFF (все единицы)
2. Для каждого байта:
   a. crc ^= byte
   b. 8 раз сдвигаем вправо:
      - Если младший бит = 1 → XOR с полиномом
      - Если младший бит = 0 → просто сдвиг
3. Финальный XOR: crc ^= 0xFFFFFFFF

Результат: 32-bit checksum
```

#### DJB2 Hash

Создан Daniel J. Bernstein. Простой и быстрый hash для строк:

```
hash = 5381 (magic seed)
для каждого символа c:
    hash = hash * 33 + c
    // оптимизация: (hash << 5) + hash = hash * 32 + hash = hash * 33
```

---

### Компиляция для Android

**Файл:** `android/app/CMakeLists.txt`

```cmake
cmake_minimum_required(VERSION 3.10)
project(hash_utils LANGUAGES C)

add_library(hash_utils SHARED
    ../../native/src/hash_utils.c
)
```

Flutter Android build system автоматически подхватывает `CMakeLists.txt` и компилирует
`.c` → `libhash_utils.so` для каждой архитектуры (arm64-v8a, armeabi-v7a, x86_64).

### Компиляция для iOS

Файл `ios/Runner/hash_utils.c` добавлен в Xcode проект. Компилируется как часть
Runner binary. Символы доступны через `DynamicLibrary.process()`.

---

### Dart FFI bindings

**Файл:** `lib/core/platform/native_hash_service.dart`

```dart
// C-сигнатуры (NativeFunction types)
typedef NativeCrc32 = Uint32 Function(Pointer<Uint8>, Int32);
typedef NativeDjb2 = Uint32 Function(Pointer<Utf8>);
typedef NativeCountBytes = Int32 Function(Pointer<Uint8>, Int32, Uint8);

// Dart-сигнатуры (как вызываем из Dart)
typedef DartCrc32 = int Function(Pointer<Uint8>, int);
typedef DartDjb2 = int Function(Pointer<Utf8>);
typedef DartCountBytes = int Function(Pointer<Uint8>, int, int);
```

#### Почему два typedef

**NativeType** (`Uint32`, `Int32`, `Pointer<Uint8>`) — описывает C-функцию как она есть.
**DartType** (`int`, `Pointer<Uint8>`) — описывает как Dart вызывает эту функцию.

`lookupFunction` конвертирует: `NativeType → DartType`.

```dart
_crc32 = lib.lookupFunction<NativeCrc32, DartCrc32>('native_crc32');
//                          ^^^^^^^^^^^  ^^^^^^^^
//                          C-сигнатура  Dart-сигнатура
```

#### Загрузка библиотеки

```dart
NativeHashService() {
  final DynamicLibrary lib;

  if (Platform.isAndroid) {
    lib = DynamicLibrary.open('libhash_utils.so');  // ← shared library
  } else if (Platform.isIOS) {
    lib = DynamicLibrary.process();                  // ← вкомпилировано в binary
  } else {
    throw UnsupportedError('Only Android and iOS');
  }

  _crc32 = lib.lookupFunction<NativeCrc32, DartCrc32>('native_crc32');
  _djb2Hash = lib.lookupFunction<NativeDjb2, DartDjb2>('native_djb2_hash');
  _countBytes = lib.lookupFunction<NativeCountBytes, DartCountBytes>('native_count_bytes');
}
```

#### Почему разная загрузка для Android и iOS

**Android:** CMake компилирует `.c` → `libhash_utils.so` (shared library).
Лежит в `lib/<arch>/libhash_utils.so` внутри APK.
`DynamicLibrary.open('libhash_utils.so')` — загружает через dlopen.

**iOS:** `.c` файл компилируется **вместе с Runner** (static linking).
Все символы уже в main binary.
`DynamicLibrary.process()` — ищет символы в текущем процессе через dlsym.

---

### Управление памятью

```dart
int crc32(Uint8List data) {
  final pointer = malloc<Uint8>(data.length);  // 1. Выделяем нативную память
  try {
    pointer.asTypedList(data.length).setAll(0, data);  // 2. Копируем данные
    return _crc32(pointer, data.length);                // 3. Вызываем C-функцию
  } finally {
    malloc.free(pointer);  // 4. ОБЯЗАТЕЛЬНО освобождаем!
  }
}
```

#### Почему try/finally

Dart GC **не управляет** нативной памятью. `malloc` выделяет память в C heap.
Если забыть `free` — **memory leak** (память утекает навсегда).

`finally` гарантирует `free` даже если C-функция бросит исключение.

```
Dart Heap (managed by GC):      C Heap (managed manually):
┌──────────────┐                ┌──────────────┐
│ Uint8List    │ ──копия──>     │ Pointer<Uint8>│
│ (GC соберёт) │                │ (нужен free!) │
└──────────────┘                └──────────────┘
```

#### pointer.asTypedList — zero-copy view

```dart
pointer.asTypedList(data.length).setAll(0, data);
```

`asTypedList` создаёт **Dart view** поверх нативной памяти (без копирования).
`setAll` копирует bytes из Dart `Uint8List` в этот view = в нативную память.

#### Строки через toNativeUtf8

```dart
int djb2Hash(String input) {
  final pointer = input.toNativeUtf8();  // Dart String → Pointer<Utf8>
  try {
    return _djb2Hash(pointer);
  } finally {
    malloc.free(pointer);  // Освобождаем UTF-8 буфер
  }
}
```

`toNativeUtf8()` — выделяет нативную память, копирует строку как null-terminated UTF-8.

---

### Применение в проекте

#### Проверка целостности файлов

**Файл:** `lib/features/files/data/services/files_service.dart`

```dart
// При импорте — считаем CRC32 зашифрованных данных
final checksum = _nativeHashService.crc32(encryptedBytes);
final entity = SecureFileEntity(
  // ...
  checksum: checksum,
);

// При расшифровке — проверяем
if (entity.checksum != null) {
  final currentChecksum = _nativeHashService.crc32(encryptedBytes);
  if (currentChecksum != entity.checksum) {
    return ErrorResult(const FileFailure(
      message: 'File integrity check failed — data may be corrupted',
    ));
  }
}
```

Если файл на диске повредился (bad sector, неполная запись) — CRC32 не совпадёт.

---

### Benchmark — Dart vs C (FFI)

**Файл:** `lib/features/benchmark/presentation/bloc/benchmark_bloc.dart`

```dart
// Dart CRC32 (main thread)
final dartMs = await _benchmarkDartCrc32(data);

// C FFI CRC32 (main thread)
final nativeMs = _benchmarkNativeCrc32(data);

// Dart CRC32 в Isolate
final isolateMs = await _benchmarkIsolateCrc32(data);
```

#### Типичные результаты

| Размер | Dart (main) | C FFI (main) | Dart (Isolate) | C speedup |
|--------|-------------|--------------|----------------|-----------|
| 1 MB   | ~45ms       | ~8ms         | ~50ms          | **5.6×**  |
| 5 MB   | ~220ms      | ~40ms        | ~230ms         | **5.5×**  |
| 10 MB  | ~440ms      | ~80ms        | ~450ms         | **5.5×**  |

#### Почему C быстрее

1. **Нет GC overhead** — C работает с сырой памятью, нет паузы на сборку мусора
2. **Нативная оптимизация** — компилятор (clang/gcc) оптимизирует циклы, vectorization
3. **Нет bounds checking** — Dart проверяет индексы массива, C — нет
4. **Прямой доступ к памяти** — нет прослойки VM

#### Isolate не ускоряет

Dart в Isolate — такая же скорость. Но **не блокирует UI**.
C FFI — быстрее в 5×, но тоже на main thread (блокирует если >16ms).

Идеальная комбинация: **C FFI + Isolate** (если операция >16ms).

---

## MethodChannel vs FFI — когда что

| Характеристика | MethodChannel | FFI |
|----------------|---------------|-----|
| Язык нативного кода | Kotlin/Java, Swift/ObjC | C/C++ |
| Сериализация | Да (StandardMethodCodec) | Нет (прямой вызов) |
| Асинхронность | Async (Future) | Sync (блокирующий) |
| Overhead | ~0.1–1ms | ~0.001ms |
| Доступ к platform API | Да (BatteryManager, UIDevice) | Нет (только C-функции) |
| Управление памятью | Автоматическое | Ручное (malloc/free) |

**MethodChannel:** когда нужен platform API (батарея, storage, камера, Bluetooth).
**FFI:** когда нужна максимальная скорость (хеширование, image processing, crypto).

---

## Критерии приёмки — чеклист

- [x] MethodChannel реализован для Android (Kotlin) и iOS (Swift)
- [x] 3 метода: getBatteryLevel, getFreeStorage, getTotalStorage
- [x] Обработка ошибок на нативной стороне (result.error / FlutterError)
- [x] Graceful degradation на Dart-стороне (PlatformException → null)
- [x] C-библиотека с 3 функциями: crc32, djb2_hash, count_bytes
- [x] FFI bindings: DynamicLibrary, lookupFunction, Pointer, malloc/free
- [x] Управление памятью: try/finally для malloc.free
- [x] CRC32 используется для проверки целостности файлов
- [x] Benchmark: Dart vs C FFI
- [x] Документация в коде (комментарии в Kotlin/Swift/C)
