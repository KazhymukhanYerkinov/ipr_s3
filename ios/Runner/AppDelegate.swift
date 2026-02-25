import Flutter
import UIKit

/// MethodChannel для передачи информации об устройстве в Flutter.
///
/// Канал: "com.filesecure/device_info"
/// Методы:
///   - getBatteryLevel  → Int (0-100) или FlutterError
///   - getFreeStorage   → Int64 (байты свободного места)
///   - getTotalStorage  → Int64 (байты общего места)
///
/// Почему MethodChannel, а не Dart-пакет:
/// - UIDevice.batteryLevel и FileManager — нативные iOS API
/// - Даёт точные данные без промежуточных абстракций
/// - Демонстрация Цели 7 ИПР (платформенные каналы)
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

    /// Возвращает уровень заряда батареи (0-100).
    /// UIDevice.batteryLevel возвращает Float 0.0-1.0, умножаем на 100.
    /// isBatteryMonitoringEnabled нужно включить перед чтением.
    private func handleGetBatteryLevel(result: @escaping FlutterResult) {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let level = UIDevice.current.batteryLevel

        if level >= 0 {
            result(Int(level * 100))
        } else {
            result(FlutterError(
                code: "UNAVAILABLE",
                message: "Battery level not available (simulator or unsupported device)",
                details: nil
            ))
        }
    }

    /// Возвращает количество свободных байт на устройстве.
    /// FileManager.attributesOfFileSystem читает метаданные FS.
    private func handleGetFreeStorage(result: @escaping FlutterResult) {
        do {
            let attrs = try FileManager.default.attributesOfFileSystem(
                forPath: NSHomeDirectory()
            )
            if let freeSize = attrs[.systemFreeSize] as? Int64 {
                result(freeSize)
            } else {
                result(FlutterError(
                    code: "UNAVAILABLE",
                    message: "Free storage size not available",
                    details: nil
                ))
            }
        } catch {
            result(FlutterError(
                code: "ERROR",
                message: "Failed to get free storage: \(error.localizedDescription)",
                details: nil
            ))
        }
    }

    /// Возвращает общий объём хранилища в байтах.
    private func handleGetTotalStorage(result: @escaping FlutterResult) {
        do {
            let attrs = try FileManager.default.attributesOfFileSystem(
                forPath: NSHomeDirectory()
            )
            if let totalSize = attrs[.systemSize] as? Int64 {
                result(totalSize)
            } else {
                result(FlutterError(
                    code: "UNAVAILABLE",
                    message: "Total storage size not available",
                    details: nil
                ))
            }
        } catch {
            result(FlutterError(
                code: "ERROR",
                message: "Failed to get total storage: \(error.localizedDescription)",
                details: nil
            ))
        }
    }
}
