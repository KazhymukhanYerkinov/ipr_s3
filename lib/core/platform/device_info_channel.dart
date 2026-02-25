import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/security/secure_logger.dart';

/// Dart-обёртка над нативным MethodChannel "com.filesecure/device_info".
///
/// Вызывает методы из MainActivity.kt (Android) / AppDelegate.swift (iOS)
/// для получения информации об устройстве: батарея, хранилище.
///
/// Graceful degradation: при ошибке или недоступности платформы
/// (симулятор, web, тесты) возвращает null вместо исключения.
/// Это позволяет UI показать "N/A" без краша.
@lazySingleton
class DeviceInfoChannel {
  static const _channel = MethodChannel('com.filesecure/device_info');
  final _logger = SecureLogger();

  /// Уровень заряда батареи (0-100), null если недоступно.
  Future<int?> getBatteryLevel() async {
    try {
      final level = await _channel.invokeMethod<int>('getBatteryLevel');
      return level;
    } on PlatformException catch (e) {
      _logger.warning('Battery level unavailable: ${e.code}');
      return null;
    } on MissingPluginException {
      _logger.warning('MethodChannel not available (platform unsupported)');
      return null;
    }
  }

  /// Свободное место на устройстве в байтах, null если недоступно.
  Future<int?> getFreeStorage() async {
    try {
      final bytes = await _channel.invokeMethod<int>('getFreeStorage');
      return bytes;
    } on PlatformException catch (e) {
      _logger.warning('Free storage unavailable: ${e.code}');
      return null;
    } on MissingPluginException {
      _logger.warning('MethodChannel not available (platform unsupported)');
      return null;
    }
  }

  /// Общий объём хранилища в байтах, null если недоступно.
  Future<int?> getTotalStorage() async {
    try {
      final bytes = await _channel.invokeMethod<int>('getTotalStorage');
      return bytes;
    } on PlatformException catch (e) {
      _logger.warning('Total storage unavailable: ${e.code}');
      return null;
    } on MissingPluginException {
      _logger.warning('MethodChannel not available (platform unsupported)');
      return null;
    }
  }
}
