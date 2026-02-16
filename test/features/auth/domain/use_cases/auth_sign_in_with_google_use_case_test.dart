import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/features/auth/domain/behaviors/auth_behavior.dart';
import 'package:ipr_s3/features/auth/domain/entities/user.dart';
import 'package:ipr_s3/features/auth/domain/use_cases/auth_sign_in_with_google_use_case.dart';

class MockAuthBehavior extends Mock implements AuthBehavior {}

void main() {
  late AuthSignInWithGoogleUseCase useCase;
  late MockAuthBehavior mockAuthBehavior;

  setUp(() {
    mockAuthBehavior = MockAuthBehavior();
    useCase = AuthSignInWithGoogleUseCase(mockAuthBehavior);
  });

  const testUser = UserEntity(
    uid: '123',
    email: 'test@example.com',
    displayName: 'Test User',
    photoUrl: 'https://example.com/photo.jpg',
  );

  group('AuthSignInWithGoogleUseCase', () {
    test('should return UserEntity on successful sign-in', () async {
      when(() => mockAuthBehavior.signInWithGoogle())
          .thenAnswer((_) async => const Right(testUser));

      final result = await useCase();

      expect(result, const Right(testUser));
      verify(() => mockAuthBehavior.signInWithGoogle()).called(1);
    });

    test('should return AuthFailure when sign-in fails', () async {
      const failure = AuthFailure(message: 'Failed to sign in');
      when(() => mockAuthBehavior.signInWithGoogle())
          .thenAnswer((_) async => const Left(failure));

      final result = await useCase();

      expect(result, const Left(failure));
      verify(() => mockAuthBehavior.signInWithGoogle()).called(1);
    });

    test('should delegate call to AuthBehavior.signInWithGoogle', () async {
      when(() => mockAuthBehavior.signInWithGoogle())
          .thenAnswer((_) async => const Right(testUser));

      await useCase();

      verify(() => mockAuthBehavior.signInWithGoogle()).called(1);
      verifyNoMoreInteractions(mockAuthBehavior);
    });
  });
}
