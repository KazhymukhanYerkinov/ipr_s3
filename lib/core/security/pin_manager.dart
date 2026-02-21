import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/constants/storage_keys.dart';

@lazySingleton
class PinManager {
  final FlutterSecureStorage _secureStorage;

  PinManager(this._secureStorage);

  Future<void> setPin(String pin) async {
    final hash = sha256.convert(utf8.encode(pin)).toString();
    await _secureStorage.write(key: StorageKeys.pinHash, value: hash);
  }

  Future<bool> verifyPin(String pin) async {
    final storedHash = await _secureStorage.read(key: StorageKeys.pinHash);
    if (storedHash == null) return false;
    final inputHash = sha256.convert(utf8.encode(pin)).toString();
    return storedHash == inputHash;
  }

  Future<bool> hasPin() async {
    final pin = await _secureStorage.read(key: StorageKeys.pinHash);
    return pin != null;
  }

  Future<void> deletePin() async {
    await _secureStorage.delete(key: StorageKeys.pinHash);
  }
}
