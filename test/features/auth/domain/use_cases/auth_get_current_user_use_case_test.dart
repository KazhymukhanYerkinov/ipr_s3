import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/core/result/result.dart';
import 'package:ipr_s3/features/auth/domain/behaviors/get_current_user_behavior.dart';
import 'package:ipr_s3/features/auth/domain/models/user.dart';
import 'package:ipr_s3/features/auth/domain/use_cases/auth_get_current_user_use_case.dart';

class MockGetCurrentUserBehavior extends Mock
    implements GetCurrentUserBehavior {}

void main() {
  late AuthGetCurrentUserUseCase useCase;
  late MockGetCurrentUserBehavior mockGetCurrentUserBehavior;

  setUp(() {
    mockGetCurrentUserBehavior = MockGetCurrentUserBehavior();
    useCase = AuthGetCurrentUserUseCase(mockGetCurrentUserBehavior);
  });

  const testUser = UserEntity(
    uid: '123',
    email: 'test@example.com',
    displayName: 'Test User',
  );

  group('AuthGetCurrentUserUseCase', () {
    test('should return UserEntity when user is authenticated', () async {
      when(
        () => mockGetCurrentUserBehavior.getCurrentUser(),
      ).thenAnswer((_) async => SuccessResult(testUser));

      final result = await useCase();

      expect(result.isSuccess, true);
      expect(result.value?.uid, '123');
      verify(() => mockGetCurrentUserBehavior.getCurrentUser()).called(1);
    });

    test('should return null when no user is authenticated', () async {
      when(
        () => mockGetCurrentUserBehavior.getCurrentUser(),
      ).thenAnswer((_) async => SuccessResult(null));

      final result = await useCase();

      expect(result.isSuccess, true);
      expect(result.value, isNull);
      verify(() => mockGetCurrentUserBehavior.getCurrentUser()).called(1);
    });

    test('should return AuthFailure when getting user fails', () async {
      const failure = AuthFailure(message: 'Failed to get current user');
      when(
        () => mockGetCurrentUserBehavior.getCurrentUser(),
      ).thenAnswer((_) async => ErrorResult(failure));

      final result = await useCase();

      expect(result.isError, true);
      expect(result.failure?.message, 'Failed to get current user');
      verify(() => mockGetCurrentUserBehavior.getCurrentUser()).called(1);
    });

    test(
      'should delegate call to GetCurrentUserBehavior.getCurrentUser',
      () async {
        when(
          () => mockGetCurrentUserBehavior.getCurrentUser(),
        ).thenAnswer((_) async => SuccessResult(testUser));

        await useCase();

        verify(() => mockGetCurrentUserBehavior.getCurrentUser()).called(1);
        verifyNoMoreInteractions(mockGetCurrentUserBehavior);
      },
    );
  });
}
