import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/core/security/pin_manager.dart';
import 'package:ipr_s3/features/auth/data/dtos/user_dto.dart';
import 'package:ipr_s3/features/auth/data/services/auth_service.dart';
import 'package:ipr_s3/features/auth/data/sources/auth_local_source.dart';
import 'package:ipr_s3/features/auth/data/sources/auth_remote_source.dart';
import 'package:ipr_s3/features/auth/domain/entities/user.dart';

class MockAuthRemoteSource extends Mock implements AuthRemoteSource {}

class MockAuthLocalSource extends Mock implements AuthLocalSource {}

class MockPinManager extends Mock implements PinManager {}

void main() {
  late AuthService authService;
  late MockAuthRemoteSource mockRemoteSource;
  late MockAuthLocalSource mockLocalSource;
  late MockPinManager mockPinManager;

  setUp(() {
    mockRemoteSource = MockAuthRemoteSource();
    mockLocalSource = MockAuthLocalSource();
    mockPinManager = MockPinManager();
    authService = AuthService(mockRemoteSource, mockLocalSource, mockPinManager);
  });

  const testUserDto = UserDto(
    uid: '123',
    email: 'test@example.com',
    displayName: 'Test User',
    photoUrl: 'https://example.com/photo.jpg',
  );

  group('signInWithGoogle', () {
    test('should return UserEntity on successful sign-in', () async {
      when(() => mockRemoteSource.signInWithGoogle())
          .thenAnswer((_) async => testUserDto);

      final result = await authService.signInWithGoogle();

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should be Right'),
        (user) {
          expect(user, isA<UserEntity>());
          expect(user.uid, '123');
          expect(user.email, 'test@example.com');
          expect(user.displayName, 'Test User');
        },
      );
      verify(() => mockRemoteSource.signInWithGoogle()).called(1);
    });

    test('should return AuthFailure when remote source throws', () async {
      when(() => mockRemoteSource.signInWithGoogle())
          .thenThrow(Exception('Google Sign-In cancelled'));

      final result = await authService.signInWithGoogle();

      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<AuthFailure>());
          expect(failure.message, 'Failed to sign in');
        },
        (_) => fail('Should be Left'),
      );
    });

    test('should not expose original error message in failure', () async {
      when(() => mockRemoteSource.signInWithGoogle())
          .thenThrow(Exception('Secret token abc123 leaked'));

      final result = await authService.signInWithGoogle();

      result.fold(
        (failure) {
          expect(failure.message, isNot(contains('Secret')));
          expect(failure.message, isNot(contains('abc123')));
          expect(failure.message, 'Failed to sign in');
        },
        (_) => fail('Should be Left'),
      );
    });
  });

  group('signOut', () {
    test('should return Right(void) on successful sign-out', () async {
      when(() => mockRemoteSource.signOut()).thenAnswer((_) async {});
      when(() => mockLocalSource.deleteToken()).thenAnswer((_) async {});

      final result = await authService.signOut();

      expect(result.isRight(), true);
      verify(() => mockRemoteSource.signOut()).called(1);
      verify(() => mockLocalSource.deleteToken()).called(1);
    });

    test('should delete local token on sign-out', () async {
      when(() => mockRemoteSource.signOut()).thenAnswer((_) async {});
      when(() => mockLocalSource.deleteToken()).thenAnswer((_) async {});

      await authService.signOut();

      verify(() => mockLocalSource.deleteToken()).called(1);
    });

    test('should return AuthFailure when remote sign-out throws', () async {
      when(() => mockRemoteSource.signOut())
          .thenThrow(Exception('Network error'));

      final result = await authService.signOut();

      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<AuthFailure>());
          expect(failure.message, 'Failed to sign out');
        },
        (_) => fail('Should be Left'),
      );
    });

    test('should return AuthFailure when local deleteToken throws', () async {
      when(() => mockRemoteSource.signOut()).thenAnswer((_) async {});
      when(() => mockLocalSource.deleteToken())
          .thenThrow(Exception('Storage error'));

      final result = await authService.signOut();

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<AuthFailure>()),
        (_) => fail('Should be Left'),
      );
    });
  });

  group('getCurrentUser', () {
    test('should return UserEntity when user is authenticated', () async {
      when(() => mockRemoteSource.getCurrentUser()).thenReturn(testUserDto);

      final result = await authService.getCurrentUser();

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should be Right'),
        (user) {
          expect(user, isNotNull);
          expect(user!.uid, '123');
        },
      );
      verify(() => mockRemoteSource.getCurrentUser()).called(1);
    });

    test('should return null when no user is authenticated', () async {
      when(() => mockRemoteSource.getCurrentUser()).thenReturn(null);

      final result = await authService.getCurrentUser();

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should be Right'),
        (user) => expect(user, isNull),
      );
    });

    test('should return AuthFailure when getCurrentUser throws', () async {
      when(() => mockRemoteSource.getCurrentUser())
          .thenThrow(Exception('Firebase error'));

      final result = await authService.getCurrentUser();

      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<AuthFailure>());
          expect(failure.message, 'Failed to get current user');
        },
        (_) => fail('Should be Left'),
      );
    });
  });

  group('hasPin', () {
    test('should return true when PIN exists', () async {
      when(() => mockPinManager.hasPin()).thenAnswer((_) async => true);

      final result = await authService.hasPin();

      expect(result, const Right(true));
      verify(() => mockPinManager.hasPin()).called(1);
    });

    test('should return false when no PIN', () async {
      when(() => mockPinManager.hasPin()).thenAnswer((_) async => false);

      final result = await authService.hasPin();

      expect(result, const Right(false));
    });

    test('should return AuthFailure when PinManager throws', () async {
      when(() => mockPinManager.hasPin()).thenThrow(Exception('Storage error'));

      final result = await authService.hasPin();

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, 'Failed to check PIN'),
        (_) => fail('Should be Left'),
      );
    });
  });

  group('setPin', () {
    test('should return Right(void) on success', () async {
      when(() => mockPinManager.setPin('1234')).thenAnswer((_) async {});

      final result = await authService.setPin('1234');

      expect(result.isRight(), true);
      verify(() => mockPinManager.setPin('1234')).called(1);
    });

    test('should return AuthFailure when PinManager throws', () async {
      when(() => mockPinManager.setPin('1234'))
          .thenThrow(Exception('Write error'));

      final result = await authService.setPin('1234');

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, 'Failed to set PIN'),
        (_) => fail('Should be Left'),
      );
    });
  });

  group('verifyPin', () {
    test('should return true when PIN is correct', () async {
      when(() => mockPinManager.verifyPin('1234'))
          .thenAnswer((_) async => true);

      final result = await authService.verifyPin('1234');

      expect(result, const Right(true));
      verify(() => mockPinManager.verifyPin('1234')).called(1);
    });

    test('should return false when PIN is wrong', () async {
      when(() => mockPinManager.verifyPin('0000'))
          .thenAnswer((_) async => false);

      final result = await authService.verifyPin('0000');

      expect(result, const Right(false));
    });

    test('should return AuthFailure when PinManager throws', () async {
      when(() => mockPinManager.verifyPin('1234'))
          .thenThrow(Exception('Read error'));

      final result = await authService.verifyPin('1234');

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, 'Failed to verify PIN'),
        (_) => fail('Should be Left'),
      );
    });
  });

  group('authenticateWithBiometrics', () {
    test('should return true when biometric succeeds', () async {
      when(() => mockLocalSource.authenticateWithBiometrics())
          .thenAnswer((_) async => true);

      final result = await authService.authenticateWithBiometrics();

      expect(result, const Right(true));
      verify(() => mockLocalSource.authenticateWithBiometrics()).called(1);
    });

    test('should return false when biometric is rejected', () async {
      when(() => mockLocalSource.authenticateWithBiometrics())
          .thenAnswer((_) async => false);

      final result = await authService.authenticateWithBiometrics();

      expect(result, const Right(false));
    });

    test('should return AuthFailure when biometric throws', () async {
      when(() => mockLocalSource.authenticateWithBiometrics())
          .thenThrow(Exception('Biometric unavailable'));

      final result = await authService.authenticateWithBiometrics();

      expect(result.isLeft(), true);
      result.fold(
        (failure) =>
            expect(failure.message, 'Biometric authentication failed'),
        (_) => fail('Should be Left'),
      );
    });
  });
}
