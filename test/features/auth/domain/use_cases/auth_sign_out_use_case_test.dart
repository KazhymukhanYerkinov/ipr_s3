import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/core/result/result.dart';
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
    test('should return success on successful sign-out', () async {
      when(
        () => mockSignOutBehavior.signOut(),
      ).thenAnswer((_) async => SuccessResult(null));

      final result = await useCase();

      expect(result.isSuccess, true);
      verify(() => mockSignOutBehavior.signOut()).called(1);
    });

    test('should return AuthFailure when sign-out fails', () async {
      const failure = AuthFailure(message: 'Failed to sign out');
      when(
        () => mockSignOutBehavior.signOut(),
      ).thenAnswer((_) async => ErrorResult(failure));

      final result = await useCase();

      expect(result.isError, true);
      expect(result.failure?.message, 'Failed to sign out');
      verify(() => mockSignOutBehavior.signOut()).called(1);
    });

    test('should delegate call to SignOutBehavior.signOut', () async {
      when(
        () => mockSignOutBehavior.signOut(),
      ).thenAnswer((_) async => SuccessResult(null));

      await useCase();

      verify(() => mockSignOutBehavior.signOut()).called(1);
      verifyNoMoreInteractions(mockSignOutBehavior);
    });
  });
}
