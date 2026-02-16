import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class EncryptionHelper {
  static const _encryptionKeyName = 'hive_encryption_key';
  final FlutterSecureStorage _secureStorage;

  EncryptionHelper(this._secureStorage);

  /// Получает или генерирует ключ шифрования
  Future<Uint8List> getEncryptionKey() async {
    final existingKey = await _secureStorage.read(key: _encryptionKeyName);
    if (existingKey != null) {
      return base64Url.decode(existingKey);
    }
    final newKey = Hive.generateSecureKey();
    await _secureStorage.write(
      key: _encryptionKeyName,
      value: base64Url.encode(newKey),
    );
    return Uint8List.fromList(newKey);
  }

  /// Открывает зашифрованный Hive box
  Future<Box<T>> openEncryptedBox<T>(String name) async {
    final key = await getEncryptionKey();
    return Hive.openBox<T>(name, encryptionCipher: HiveAesCipher(key));
  }
}
