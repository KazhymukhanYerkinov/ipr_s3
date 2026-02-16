import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/features/auth/domain/behaviors/auth_behavior.dart';
import 'package:ipr_s3/features/auth/domain/entities/user.dart';
import 'package:ipr_s3/features/auth/domain/use_cases/auth_get_current_user_use_case.dart';

class MockAuthBehavior extends Mock implements AuthBehavior {}

void main() {
  late AuthGetCurrentUserUseCase useCase;
  late MockAuthBehavior mockAuthBehavior;

  setUp(() {
    mockAuthBehavior = MockAuthBehavior();
    useCase = AuthGetCurrentUserUseCase(mockAuthBehavior);
  });

  const testUser = UserEntity(
    uid: '123',
    email: 'test@example.com',
    displayName: 'Test User',
  );

  group('AuthGetCurrentUserUseCase', () {
    test('should return UserEntity when user is authenticated', () async {
      when(() => mockAuthBehavior.getCurrentUser())
          .thenAnswer((_) async => const Right(testUser));

      final result = await useCase();

      expect(result, const Right(testUser));
      verify(() => mockAuthBehavior.getCurrentUser()).called(1);
    });

    test('should return null when no user is authenticated', () async {
      when(() => mockAuthBehavior.getCurrentUser())
          .thenAnswer((_) async => const Right(null));

      final result = await useCase();

      result.fold(
        (_) => fail('Should be Right'),
        (user) => expect(user, isNull),
      );
      verify(() => mockAuthBehavior.getCurrentUser()).called(1);
    });

    test('should return AuthFailure when getting user fails', () async {
      const failure = AuthFailure(message: 'Failed to get current user');
      when(() => mockAuthBehavior.getCurrentUser())
          .thenAnswer((_) async => const Left(failure));

      final result = await useCase();

      expect(result, const Left(failure));
      verify(() => mockAuthBehavior.getCurrentUser()).called(1);
    });

    test('should delegate call to AuthBehavior.getCurrentUser', () async {
      when(() => mockAuthBehavior.getCurrentUser())
          .thenAnswer((_) async => const Right(testUser));

      await useCase();

      verify(() => mockAuthBehavior.getCurrentUser()).called(1);
      verifyNoMoreInteractions(mockAuthBehavior);
    });
  });
}
