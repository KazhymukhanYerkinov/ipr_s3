import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
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
