abstract class DeviceInfoBehavior {
  Future<int?> getBatteryLevel();
  Future<int?> getFreeStorage();
  Future<int?> getTotalStorage();
}
