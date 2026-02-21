import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

/// Управление PIN-кодом пользователя.
///
/// PIN хранится как SHA-256 hash в flutter_secure_storage (Keychain/Keystore),
/// что обеспечивает двойную защиту:
/// 1. Secure Storage шифрует данные на уровне ОС
/// 2. Даже при компрометации хранилища — утечёт только hash, не сам PIN
@lazySingleton
class PinManager {
  static const _pinKey = 'user_pin_hash';
  final FlutterSecureStorage _secureStorage;

  PinManager(this._secureStorage);

  Future<void> setPin(String pin) async {
    final hash = sha256.convert(utf8.encode(pin)).toString();
    await _secureStorage.write(key: _pinKey, value: hash);
  }

  Future<bool> verifyPin(String pin) async {
    final storedHash = await _secureStorage.read(key: _pinKey);
    if (storedHash == null) return false;
    final inputHash = sha256.convert(utf8.encode(pin)).toString();
    return storedHash == inputHash;
  }

  Future<bool> hasPin() async {
    final pin = await _secureStorage.read(key: _pinKey);
    return pin != null;
  }

  Future<void> deletePin() async {
    await _secureStorage.delete(key: _pinKey);
  }
}
