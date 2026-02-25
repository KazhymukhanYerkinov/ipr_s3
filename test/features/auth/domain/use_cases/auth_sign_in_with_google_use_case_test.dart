import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/features/auth/domain/behaviors/sign_in_with_google_behavior.dart';
import 'package:ipr_s3/features/auth/domain/models/user.dart';
import 'package:ipr_s3/features/auth/domain/use_cases/auth_sign_in_with_google_use_case.dart';

class MockSignInWithGoogleBehavior extends Mock
    implements SignInWithGoogleBehavior {}

void main() {
  late AuthSignInWithGoogleUseCase useCase;
  late MockSignInWithGoogleBehavior mockSignInWithGoogleBehavior;

  setUp(() {
    mockSignInWithGoogleBehavior = MockSignInWithGoogleBehavior();
    useCase = AuthSignInWithGoogleUseCase(mockSignInWithGoogleBehavior);
  });

  const testUser = UserEntity(
    uid: '123',
    email: 'test@example.com',
    displayName: 'Test User',
    photoUrl: 'https://example.com/photo.jpg',
  );

  group('AuthSignInWithGoogleUseCase', () {
    test('should return UserEntity on successful sign-in', () async {
      when(
        () => mockSignInWithGoogleBehavior.signInWithGoogle(),
      ).thenAnswer((_) async => const Right(testUser));

      final result = await useCase();

      expect(result, const Right(testUser));
      verify(() => mockSignInWithGoogleBehavior.signInWithGoogle()).called(1);
    });

    test('should return AuthFailure when sign-in fails', () async {
      const failure = AuthFailure(message: 'Failed to sign in');
      when(
        () => mockSignInWithGoogleBehavior.signInWithGoogle(),
      ).thenAnswer((_) async => const Left(failure));

      final result = await useCase();

      expect(result, const Left(failure));
      verify(() => mockSignInWithGoogleBehavior.signInWithGoogle()).called(1);
    });

    test(
      'should delegate call to SignInWithGoogleBehavior.signInWithGoogle',
      () async {
        when(
          () => mockSignInWithGoogleBehavior.signInWithGoogle(),
        ).thenAnswer((_) async => const Right(testUser));

        await useCase();

        verify(() => mockSignInWithGoogleBehavior.signInWithGoogle()).called(1);
        verifyNoMoreInteractions(mockSignInWithGoogleBehavior);
      },
    );
  });
}
