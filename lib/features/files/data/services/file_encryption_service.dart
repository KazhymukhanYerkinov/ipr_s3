import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/security/encryption_helper.dart';
import 'package:ipr_s3/core/security/secure_logger.dart';

/// Parameters passed to the top-level encrypt/decrypt functions via compute().
/// Must be a simple class — compute() requires a top-level function
/// and cannot capture closures.
class EncryptionParams {
  final Uint8List data;
  final Uint8List key;

  const EncryptionParams({required this.data, required this.key});
}

/// Top-level function for compute() — encrypts bytes with AES-256-CBC.
/// IV is prepended to the output so it can be extracted during decryption.
Uint8List encryptBytes(EncryptionParams params) {
  final key = enc.Key(params.key);
  final iv = enc.IV.fromSecureRandom(16);
  final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));

  final encrypted = encrypter.encryptBytes(params.data, iv: iv);

  final result = Uint8List(iv.bytes.length + encrypted.bytes.length);
  result.setRange(0, iv.bytes.length, iv.bytes);
  result.setRange(iv.bytes.length, result.length, encrypted.bytes);
  return result;
}

/// Top-level function for compute() — decrypts AES-256-CBC encrypted bytes.
/// Expects IV (first 16 bytes) prepended to the encrypted data.
Uint8List decryptBytes(EncryptionParams params) {
  final key = enc.Key(params.key);
  final ivBytes = params.data.sublist(0, 16);
  final encryptedData = params.data.sublist(16);

  final iv = enc.IV(ivBytes);
  final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));

  final decrypted = encrypter.decryptBytes(
    enc.Encrypted(encryptedData),
    iv: iv,
  );
  return Uint8List.fromList(decrypted);
}

/// Service that runs AES-256-CBC encryption/decryption in a background
/// isolate via compute(), keeping the UI thread free.
@lazySingleton
class FileEncryptionService {
  final EncryptionHelper _encryptionHelper;
  final _logger = SecureLogger();

  FileEncryptionService(this._encryptionHelper);

  Future<Uint8List> encrypt(Uint8List data) async {
    _logger.info('Encrypting ${data.length} bytes in background isolate');
    final key = await _encryptionHelper.getEncryptionKey();
    return compute(encryptBytes, EncryptionParams(data: data, key: key));
  }

  Future<Uint8List> decrypt(Uint8List encryptedData) async {
    _logger.info('Decrypting ${encryptedData.length} bytes in background isolate');
    final key = await _encryptionHelper.getEncryptionKey();
    return compute(decryptBytes, EncryptionParams(data: encryptedData, key: key));
  }
}
