abstract class Failure {
  final String message;

  const Failure({required this.message});
}

class AuthFailure extends Failure {
  const AuthFailure({required super.message});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class FileFailure extends Failure {
  const FileFailure({required super.message});
}

class EncryptionFailure extends Failure {
  const EncryptionFailure({required super.message});
}
