import 'package:ipr_s3/core/error/failures.dart';

abstract class Result<T> {
  T? get value;
  Failure? get failure;

  bool get isSuccess => failure == null;
  bool get isError => failure != null;
}

class SuccessResult<T> extends Result<T> {
  final T _value;

  SuccessResult(this._value);

  @override
  T? get value => _value;

  @override
  Failure? get failure => null;
}

class ErrorResult<T> extends Result<T> {
  final Failure _failure;

  ErrorResult(this._failure);

  @override
  T? get value => null;

  @override
  Failure? get failure => _failure;
}
