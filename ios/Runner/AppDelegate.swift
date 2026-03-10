import Flutter
import UIKit

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
