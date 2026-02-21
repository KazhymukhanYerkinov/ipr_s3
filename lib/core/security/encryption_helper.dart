import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/constants/storage_keys.dart';

@lazySingleton
class EncryptionHelper {
  final FlutterSecureStorage _secureStorage;

  EncryptionHelper(this._secureStorage);

  Future<Uint8List> getEncryptionKey() async {
    final existingKey = await _secureStorage.read(key: StorageKeys.encryptionKey);
    if (existingKey != null) {
      return base64Url.decode(existingKey);
    }
    final newKey = Hive.generateSecureKey();
    await _secureStorage.write(
      key: StorageKeys.encryptionKey,
      value: base64Url.encode(newKey),
    );
    return Uint8List.fromList(newKey);
  }

  Future<Box<T>> openEncryptedBox<T>(String name) async {
    final key = await getEncryptionKey();
    return Hive.openBox<T>(name, encryptionCipher: HiveAesCipher(key));
  }
}
