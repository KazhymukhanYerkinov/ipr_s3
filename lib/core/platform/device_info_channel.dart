import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/security/secure_logger.dart';

@lazySingleton
class DeviceInfoChannel {
  static const _channel = MethodChannel('com.filesecure/device_info');
  final _logger = SecureLogger();

  Future<int?> getBatteryLevel() =>
      _invokeInt('getBatteryLevel', 'Battery level');

  Future<int?> getFreeStorage() => _invokeInt('getFreeStorage', 'Free storage');

  Future<int?> getTotalStorage() =>
      _invokeInt('getTotalStorage', 'Total storage');

  Future<int?> _invokeInt(String method, String label) async {
    try {
      return await _channel.invokeMethod<int>(method);
    } on PlatformException catch (e) {
      _logger.warning('$label unavailable: ${e.code}');
      return null;
    } on MissingPluginException {
      _logger.warning('MethodChannel not available (platform unsupported)');
      return null;
    }
  }
}
