import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/features/auth/domain/behaviors/set_pin_behavior.dart';

@lazySingleton
class SetPinUseCase {
  final SetPinBehavior _behavior;

  SetPinUseCase(this._behavior);

  Future<Either<Failure, void>> call(String pin) async {
    return _behavior.setPin(pin);
  }
}
