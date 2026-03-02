class EncryptionKeyLostException implements Exception {
  const EncryptionKeyLostException();

  @override
  String toString() =>
      'Encryption key was lost. Existing encrypted data cannot be decrypted.';
}
