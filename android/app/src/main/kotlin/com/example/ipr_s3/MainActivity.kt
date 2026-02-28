package com.example.ipr_s3

import android.content.Context
import android.os.BatteryManager
import android.os.Environment
import android.os.StatFs
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * MethodChannel для передачи информации об устройстве в Flutter.
 *
 * Канал: "com.filesecure/device_info"
 * Методы:
 *   - getBatteryLevel  → Int (0-100) или error("UNAVAILABLE")
 *   - getFreeStorage   → Long (байты свободного места)
 *   - getTotalStorage  → Long (байты общего места)
 *
 * Почему MethodChannel, а не Dart-пакет:
 * - BatteryManager и StatFs — нативные Android API
 * - Даёт точные данные без промежуточных абстракций
 * - Демонстрация Цели 7 ИПР (платформенные каналы)
 */
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

    /** Возвращает уровень заряда батареи (0-100). Использует BatteryManager. */
    private fun handleGetBatteryLevel(result: MethodChannel.Result) {
        try {
            val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
            val level = batteryManager.getIntProperty(
                BatteryManager.BATTERY_PROPERTY_CAPACITY
            )
            if (level != -1) {
                result.success(level)
            } else {
                result.error(
                    "UNAVAILABLE",
                    "Battery level not available on this device",
                    null
                )
            }
        } catch (e: Exception) {
            result.error("ERROR", "Failed to get battery level: ${e.message}", null)
        }
    }

    /** Возвращает количество свободных байт на устройстве. */
    private fun handleGetFreeStorage(result: MethodChannel.Result) {
        try {
            val stat = StatFs(Environment.getDataDirectory().path)
            val freeBytes = stat.availableBlocksLong * stat.blockSizeLong
            result.success(freeBytes)
        } catch (e: Exception) {
            result.error("ERROR", "Failed to get free storage: ${e.message}", null)
        }
    }

    /** Возвращает общий объём хранилища в байтах. */
    private fun handleGetTotalStorage(result: MethodChannel.Result) {
        try {
            val stat = StatFs(Environment.getDataDirectory().path)
            val totalBytes = stat.blockCountLong * stat.blockSizeLong
            result.success(totalBytes)
        } catch (e: Exception) {
            result.error("ERROR", "Failed to get total storage: ${e.message}", null)
        }
    }
}
