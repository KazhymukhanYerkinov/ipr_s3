import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/core/security/secure_logger.dart';

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

extension ResultX<T> on Result<T> {
  R when<R>({
    required R Function(T value) success,
    required R Function(Failure failure) error,
  }) {
    final f = failure;
    if (f != null) return error(f);
    return success(value as T);
  }
}

Future<Result<T>> runGuarded<T>({
  required Future<T> Function() action,
  required Failure Function() onError,
  required SecureLogger logger,
  required String errorMessage,
}) async {
  try {
    return SuccessResult(await action());
  } catch (e, stackTrace) {
    logger.error(errorMessage, e, stackTrace);
    return ErrorResult(onError());
  }
}
