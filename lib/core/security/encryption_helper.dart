import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/constants/storage_keys.dart';
import 'package:ipr_s3/core/error/exceptions.dart';
import 'package:ipr_s3/core/security/secure_logger.dart';
import 'package:path_provider/path_provider.dart';

@lazySingleton
class EncryptionHelper {
  final FlutterSecureStorage _secureStorage;
  final _logger = SecureLogger();

  EncryptionHelper(this._secureStorage);

  Future<Uint8List> getEncryptionKey() async {
    final existingKey = await _secureStorage.read(
      key: StorageKeys.encryptionKey,
    );
    if (existingKey != null) {
      return base64Url.decode(existingKey);
    }

    if (await _hasExistingEncryptedData()) {
      _logger.error('Encryption key lost - encrypted data exists on disk');
      throw const EncryptionKeyLostException();
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

  Future<bool> _hasExistingEncryptedData() async {
    final appDir = await getApplicationDocumentsDirectory();

    final secureDir = Directory('${appDir.path}/${StorageKeys.secureFilesDir}');
    if (await secureDir.exists()) {
      final contents = secureDir.listSync();
      if (contents.isNotEmpty) return true;
    }

    final hiveFile = File('${appDir.path}/${StorageKeys.secureFilesBox}.hive');
    if (await hiveFile.exists()) return true;

    return false;
  }
}
