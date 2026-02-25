import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/features/auth/domain/behaviors/sign_out_behavior.dart';
import 'package:ipr_s3/features/auth/domain/use_cases/auth_sign_out_use_case.dart';

class MockSignOutBehavior extends Mock implements SignOutBehavior {}

void main() {
  late AuthSignOutUseCase useCase;
  late MockSignOutBehavior mockSignOutBehavior;

  setUp(() {
    mockSignOutBehavior = MockSignOutBehavior();
    useCase = AuthSignOutUseCase(mockSignOutBehavior);
  });

  group('AuthSignOutUseCase', () {
    test('should return Right(void) on successful sign-out', () async {
      when(() => mockSignOutBehavior.signOut())
          .thenAnswer((_) async => const Right(null));

      final result = await useCase();

      expect(result, const Right(null));
      verify(() => mockSignOutBehavior.signOut()).called(1);
    });

    test('should return AuthFailure when sign-out fails', () async {
      const failure = AuthFailure(message: 'Failed to sign out');
      when(() => mockSignOutBehavior.signOut())
          .thenAnswer((_) async => const Left(failure));

      final result = await useCase();

      expect(result, const Left(failure));
      verify(() => mockSignOutBehavior.signOut()).called(1);
    });

    test('should delegate call to SignOutBehavior.signOut', () async {
      when(() => mockSignOutBehavior.signOut())
          .thenAnswer((_) async => const Right(null));

      await useCase();

      verify(() => mockSignOutBehavior.signOut()).called(1);
      verifyNoMoreInteractions(mockSignOutBehavior);
    });
  });
}
