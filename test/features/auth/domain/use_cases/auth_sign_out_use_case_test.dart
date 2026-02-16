import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/features/auth/domain/behaviors/auth_behavior.dart';
import 'package:ipr_s3/features/auth/domain/use_cases/auth_sign_out_use_case.dart';

class MockAuthBehavior extends Mock implements AuthBehavior {}

void main() {
  late AuthSignOutUseCase useCase;
  late MockAuthBehavior mockAuthBehavior;

  setUp(() {
    mockAuthBehavior = MockAuthBehavior();
    useCase = AuthSignOutUseCase(mockAuthBehavior);
  });

  group('AuthSignOutUseCase', () {
    test('should return Right(void) on successful sign-out', () async {
      when(() => mockAuthBehavior.signOut())
          .thenAnswer((_) async => const Right(null));

      final result = await useCase();

      expect(result, const Right(null));
      verify(() => mockAuthBehavior.signOut()).called(1);
    });

    test('should return AuthFailure when sign-out fails', () async {
      const failure = AuthFailure(message: 'Failed to sign out');
      when(() => mockAuthBehavior.signOut())
          .thenAnswer((_) async => const Left(failure));

      final result = await useCase();

      expect(result, const Left(failure));
      verify(() => mockAuthBehavior.signOut()).called(1);
    });

    test('should delegate call to AuthBehavior.signOut', () async {
      when(() => mockAuthBehavior.signOut())
          .thenAnswer((_) async => const Right(null));

      await useCase();

      verify(() => mockAuthBehavior.signOut()).called(1);
      verifyNoMoreInteractions(mockAuthBehavior);
    });
  });
}
