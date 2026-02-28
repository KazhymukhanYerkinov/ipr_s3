# Цель 7: MethodChannel и FFI

## Теория (что спросят)

### Flutter Engine и платформенные каналы

```
┌─────────────────────────────────────┐
│           Flutter (Dart)             │
│  ┌───────────────────────────────┐  │
│  │       MethodChannel           │  │
│  │  (async, name-based, codec)   │  │
│  └────────────┬──────────────────┘  │
│               │                      │
├───────────────┼──────────────────────┤
│  Flutter Engine (C++)               │
│               │                      │
├───────────────┼──────────────────────┤
│               │                      │
│  ┌────────────▼──────────────────┐  │
│  │  Platform Code                │  │
│  │  Android (Kotlin) / iOS (Swift)│  │
│  └───────────────────────────────┘  │
└─────────────────────────────────────┘
```

### Типы каналов

| Канал | Использование | Коммуникация |
|-------|---------------|-------------|
| **MethodChannel** | Вызов методов: запрос → ответ | Dart ↔ Native (request/response) |
| **BasicMessageChannel** | Обмен сообщениями (строки, JSON) | Dart ↔ Native (любое направление) |
| **EventChannel** | Поток данных (sensor, location) | Native → Dart (stream) |

### MethodCodec

| Кодек | Типы данных | Когда |
|-------|-------------|-------|
| **StandardMethodCodec** | null, bool, int, double, String, List, Map, Uint8List | По умолчанию |
| **JSONMethodCodec** | JSON-совместимые | Для JSON API |

### FFI (Foreign Function Interface)

```
┌─────────────────────────────────────┐
│           Flutter (Dart)             │
│  ┌───────────────────────────────┐  │
│  │       dart:ffi                 │  │
│  │  DynamicLibrary, Pointer,     │  │
│  │  NativeFunction, lookupFunction│  │
│  └────────────┬──────────────────┘  │
│               │ (прямой вызов)       │
│  ┌────────────▼──────────────────┐  │
│  │       C/C++ Library           │  │
│  │  (.so / .dylib / .framework)  │  │
│  └───────────────────────────────┘  │
└─────────────────────────────────────┘
```

**Разница MethodChannel vs FFI:**

| | MethodChannel | FFI |
|---|---|---|
| Язык | Kotlin/Swift | C/C++ |
| Скорость | Медленнее (async, сериализация) | Быстрее (прямой вызов, синхронный) |
| Сложность | Проще | Сложнее (указатели, память) |
| Когда | Platform API (батарея, камера) | CPU-intensive (хеширование, крипто) |

---

## MethodChannel — реализация

### Dart сторона

**Файл**: `lib/core/platform/device_info_channel.dart`
```dart
class DeviceInfoChannel {
  // Имя канала — одинаковое на всех платформах
  static const _channel = MethodChannel('com.filesecure/device_info');

  Future<int?> getBatteryLevel() async {
    try {
      // invokeMethod — отправляет запрос на нативную сторону
      final level = await _channel.invokeMethod<int>('getBatteryLevel');
      return level;
    } on PlatformException catch (e) {
      // Нативный код вернул result.error()
      _logger.warning('Battery level unavailable: ${e.code}');
      return null;  // Graceful degradation
    } on MissingPluginException {
      // Канал не зарегистрирован (например, на desktop)
      _logger.warning('MethodChannel not available');
      return null;
    }
  }
}
```

**Graceful degradation** — если нативный метод недоступен, возвращаем null, а не крашим приложение. UI показывает "N/A" вместо ошибки.

### Android (Kotlin)

**Файл**: `android/app/src/main/kotlin/.../MainActivity.kt`
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

    private fun handleGetBatteryLevel(result: MethodChannel.Result) {
        try {
            val batteryManager = getSystemService(Context.BATTERY_SERVICE)
                as BatteryManager
            val level = batteryManager.getIntProperty(
                BatteryManager.BATTERY_PROPERTY_CAPACITY
            )
            if (level != -1) {
                result.success(level)        // Отправляем результат в Dart
            } else {
                result.error(                // Отправляем ошибку в Dart
                    "UNAVAILABLE",
                    "Battery level not available",
                    null
                )
            }
        } catch (e: Exception) {
            result.error("ERROR", "Failed: ${e.message}", null)
        }
    }

    private fun handleGetFreeStorage(result: MethodChannel.Result) {
        val stat = StatFs(Environment.getDataDirectory().path)
        val freeBytes = stat.availableBlocksLong * stat.blockSizeLong
        result.success(freeBytes)
    }

    private fun handleGetTotalStorage(result: MethodChannel.Result) {
        val stat = StatFs(Environment.getDataDirectory().path)
        val totalBytes = stat.blockCountLong * stat.blockSizeLong
        result.success(totalBytes)
    }
}
```

**Нативные API Android:**
- `BatteryManager` — уровень батареи
- `StatFs` — информация о файловой системе (свободное/общее место)

### iOS (Swift)

**Файл**: `ios/Runner/AppDelegate.swift`
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
        // ...
    }

    private func handleGetBatteryLevel(result: @escaping FlutterResult) {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let level = UIDevice.current.batteryLevel  // 0.0 - 1.0

        if level >= 0 {
            result(Int(level * 100))  // Конвертируем в 0-100
        } else {
            result(FlutterError(
                code: "UNAVAILABLE",
                message: "Battery level not available",
                details: nil
            ))
        }
    }

    private func handleGetFreeStorage(result: @escaping FlutterResult) {
        let attrs = try FileManager.default.attributesOfFileSystem(
            forPath: NSHomeDirectory()
        )
        if let freeSize = attrs[.systemFreeSize] as? Int64 {
            result(freeSize)
        }
    }
}
```

**Нативные API iOS:**
- `UIDevice.batteryLevel` — возвращает Float 0.0-1.0
- `FileManager.attributesOfFileSystem` — информация о файловой системе

### Флоу MethodChannel

```
Dart                    Flutter Engine          Native (Kotlin/Swift)
  │                          │                        │
  │─ invokeMethod ──────────→│                        │
  │  ('getBatteryLevel')     │──── binary message ───→│
  │                          │                        │
  │                          │                        │── BatteryManager
  │                          │                        │   .getIntProperty()
  │                          │                        │
  │                          │←── result.success(85) ─│
  │←── Future<int>(85) ──── │                        │
  │                          │                        │
```

---

## FFI — реализация

### C-библиотека

**Файл**: `native/src/hash_utils.c`
```c
// CRC32 — быстрое хеширование для проверки целостности файлов
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

// DJB2 — быстрый хеш строк (non-cryptographic)
uint32_t native_djb2_hash(const char* str) {
    uint32_t hash = 5381;
    int c;
    while ((c = *str++)) {
        hash = ((hash << 5) + hash) + c;  // hash * 33 + c
    }
    return hash;
}

// Подсчёт вхождений байта — для анализа энтропии
int32_t native_count_bytes(const uint8_t* data, int32_t length, uint8_t target) {
    int32_t count = 0;
    for (int32_t i = 0; i < length; i++) {
        if (data[i] == target) count++;
    }
    return count;
}
```

### Dart FFI обёртка

**Файл**: `lib/core/platform/native_hash_service.dart`
```dart
// Типы для FFI: нативная сигнатура → Dart сигнатура
typedef NativeCrc32 = Uint32 Function(Pointer<Uint8>, Int32);
typedef DartCrc32 = int Function(Pointer<Uint8>, int);

typedef NativeDjb2 = Uint32 Function(Pointer<Utf8>);
typedef DartDjb2 = int Function(Pointer<Utf8>);

class NativeHashService {
  late final DartCrc32 _crc32;
  late final DartDjb2 _djb2Hash;
  late final DartCountBytes _countBytes;

  NativeHashService() {
    // Загружаем библиотеку — разные пути для Android и iOS
    final DynamicLibrary lib;
    if (Platform.isAndroid) {
      lib = DynamicLibrary.open('libhash_utils.so');  // .so для Android
    } else if (Platform.isIOS) {
      lib = DynamicLibrary.process();  // Линкуется статически в iOS
    }

    // Ищем функции по имени
    _crc32 = lib.lookupFunction<NativeCrc32, DartCrc32>('native_crc32');
    _djb2Hash = lib.lookupFunction<NativeDjb2, DartDjb2>('native_djb2_hash');
  }

  int crc32(Uint8List data) {
    // 1. Выделяем память в нативном heap
    final pointer = malloc<Uint8>(data.length);
    try {
      // 2. Копируем данные из Dart в нативную память
      pointer.asTypedList(data.length).setAll(0, data);
      // 3. Вызываем C-функцию
      return _crc32(pointer, data.length);
    } finally {
      // 4. ОБЯЗАТЕЛЬНО освобождаем память!
      malloc.free(pointer);
    }
  }

  int djb2Hash(String input) {
    final pointer = input.toNativeUtf8();
    try {
      return _djb2Hash(pointer);
    } finally {
      malloc.free(pointer);
    }
  }
}
```

### Управление памятью (ВАЖНО!)

```dart
// ПРАВИЛЬНО — try/finally гарантирует free
final pointer = malloc<Uint8>(size);
try {
  // работаем с pointer
  return _crc32(pointer, size);
} finally {
  malloc.free(pointer);  // Всегда освобождаем
}

// НЕПРАВИЛЬНО — утечка памяти при ошибке
final pointer = malloc<Uint8>(size);
final result = _crc32(pointer, size);
malloc.free(pointer);  // Не вызовется если _crc32 упадёт!
return result;
```

### Компиляция

**Android**: `android/app/CMakeLists.txt`
```cmake
cmake_minimum_required(VERSION 3.10.2)
add_library(hash_utils SHARED ../../native/src/hash_utils.c)
```
Gradle собирает .c → libhash_utils.so (shared library)

**iOS**: файл `hash_utils.c` добавлен в Xcode проект + `module.modulemap`
```
// ios/Runner/module.modulemap
module hash_utils {
    header "hash_utils.h"
    export *
}
```

### Бенчмарк — Dart vs C

**Файл**: `lib/features/benchmark/presentation/bloc/benchmark_bloc.dart`

Сравниваем три варианта для CRC32 (1MB, 5MB, 10MB):

```dart
// 1. Dart на main thread
final dartMs = await _benchmarkDartCrc32(data);

// 2. C (FFI) на main thread
final nativeMs = _benchmarkNativeCrc32(data);

// 3. C (FFI) в Isolate
final isolateMs = await _benchmarkIsolateCrc32(data);
```

Ожидаемые результаты:
- C (FFI) обычно в **5-20x быстрее** Dart для CPU-bound задач
- Isolate добавляет overhead (создание + копирование данных), но не блокирует UI
- Для маленьких данных overhead Isolate может превысить выигрыш

---

## Возможные вопросы на ассесменте

**В**: Зачем MethodChannel, если есть готовые пакеты (battery_plus, device_info_plus)?
**О**: Для демонстрации понимания платформенных каналов. В реальном проекте — да, используем пакеты. Но при необходимости интеграции с кастомным SDK или нативной библиотекой без Flutter-обёртки — нужен MethodChannel.

**В**: Как данные передаются через MethodChannel?
**О**: Через StandardMethodCodec — сериализует данные в бинарный формат. Поддерживает: null, bool, int, double, String, Uint8List, List, Map. Сложные объекты нужно сериализовать вручную.

**В**: Почему на iOS DynamicLibrary.process(), а на Android DynamicLibrary.open()?
**О**: На Android C-библиотека компилируется в .so (shared library) и загружается динамически. На iOS C-файл линкуется статически в приложение — он уже в процессе, поэтому `.process()`.

**В**: Что произойдёт если забыть вызвать malloc.free()?
**О**: Memory leak. Нативная память не управляется Dart GC. Pointer будет потерян, а память останется выделенной до закрытия приложения. Поэтому обязательно try/finally.

**В**: Почему C быстрее Dart для CRC32?
**О**: C компилируется в нативный машинный код. Dart (в AOT) тоже компилируется, но имеет overhead: bounds checking, null safety checks, GC pauses. Для tight loops (CRC32 — цикл по каждому байту) C выигрывает значительно.

**В**: Когда стоит использовать FFI вместо MethodChannel?
**О**: FFI — для CPU-intensive задач: хеширование, криптография, обработка изображений. FFI вызовы синхронные и быстрые. MethodChannel — для Platform API (камера, батарея, сенсоры) — требует async и проходит через Engine.
