import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/features/auth/domain/behaviors/has_pin_behavior.dart';

@lazySingleton
class HasPinUseCase {
  final HasPinBehavior _behavior;

  HasPinUseCase(this._behavior);

  Future<Either<Failure, bool>> call() async {
    return _behavior.hasPin();
  }
}
