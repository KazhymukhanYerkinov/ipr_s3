import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/core/security/pin_manager.dart';
import 'package:ipr_s3/features/auth/data/dtos/user_dto.dart';
import 'package:ipr_s3/features/auth/data/services/auth_service.dart';
import 'package:ipr_s3/features/auth/data/sources/auth_local_source.dart';
import 'package:ipr_s3/features/auth/data/sources/auth_remote_source.dart';
import 'package:ipr_s3/features/auth/domain/models/user.dart';

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
    authService = AuthService(
      mockRemoteSource,
      mockLocalSource,
      mockPinManager,
    );
  });

  const testUserDto = UserDto(
    uid: '123',
    email: 'test@example.com',
    displayName: 'Test User',
    photoUrl: 'https://example.com/photo.jpg',
  );

  group('signInWithGoogle', () {
    test('should return UserEntity on successful sign-in', () async {
      when(
        () => mockRemoteSource.signInWithGoogle(),
      ).thenAnswer((_) async => testUserDto);

      final result = await authService.signInWithGoogle();

      expect(result.isSuccess, true);
      final user = result.value;
      expect(user, isA<UserEntity>());
      expect(user?.uid, '123');
      expect(user?.email, 'test@example.com');
      expect(user?.displayName, 'Test User');
      verify(() => mockRemoteSource.signInWithGoogle()).called(1);
    });

    test('should return AuthFailure when remote source throws', () async {
      when(
        () => mockRemoteSource.signInWithGoogle(),
      ).thenThrow(Exception('Google Sign-In cancelled'));

      final result = await authService.signInWithGoogle();

      expect(result.isError, true);
      expect(result.failure, isA<AuthFailure>());
      expect(result.failure?.message, 'Failed to sign in');
    });

    test('should not expose original error message in failure', () async {
      when(
        () => mockRemoteSource.signInWithGoogle(),
      ).thenThrow(Exception('Secret token abc123 leaked'));

      final result = await authService.signInWithGoogle();

      expect(result.failure?.message, isNot(contains('Secret')));
      expect(result.failure?.message, isNot(contains('abc123')));
      expect(result.failure?.message, 'Failed to sign in');
    });
  });

  group('signOut', () {
    test('should return success on successful sign-out', () async {
      when(() => mockRemoteSource.signOut()).thenAnswer((_) async {});
      when(() => mockLocalSource.deleteToken()).thenAnswer((_) async {});

      final result = await authService.signOut();

      expect(result.isSuccess, true);
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
      when(
        () => mockRemoteSource.signOut(),
      ).thenThrow(Exception('Network error'));

      final result = await authService.signOut();

      expect(result.isError, true);
      expect(result.failure, isA<AuthFailure>());
      expect(result.failure?.message, 'Failed to sign out');
    });

    test('should return AuthFailure when local deleteToken throws', () async {
      when(() => mockRemoteSource.signOut()).thenAnswer((_) async {});
      when(
        () => mockLocalSource.deleteToken(),
      ).thenThrow(Exception('Storage error'));

      final result = await authService.signOut();

      expect(result.isError, true);
      expect(result.failure, isA<AuthFailure>());
    });
  });

  group('getCurrentUser', () {
    test('should return UserEntity when user is authenticated', () async {
      when(() => mockRemoteSource.getCurrentUser()).thenReturn(testUserDto);

      final result = await authService.getCurrentUser();

      expect(result.isSuccess, true);
      expect(result.value, isNotNull);
      expect(result.value!.uid, '123');
      verify(() => mockRemoteSource.getCurrentUser()).called(1);
    });

    test('should return null when no user is authenticated', () async {
      when(() => mockRemoteSource.getCurrentUser()).thenReturn(null);

      final result = await authService.getCurrentUser();

      expect(result.isSuccess, true);
      expect(result.value, isNull);
    });

    test('should return AuthFailure when getCurrentUser throws', () async {
      when(
        () => mockRemoteSource.getCurrentUser(),
      ).thenThrow(Exception('Firebase error'));

      final result = await authService.getCurrentUser();

      expect(result.isError, true);
      expect(result.failure, isA<AuthFailure>());
      expect(result.failure?.message, 'Failed to get current user');
    });
  });

  group('hasPin', () {
    test('should return true when PIN exists', () async {
      when(() => mockPinManager.hasPin()).thenAnswer((_) async => true);

      final result = await authService.hasPin();

      expect(result.isSuccess, true);
      expect(result.value, true);
      verify(() => mockPinManager.hasPin()).called(1);
    });

    test('should return false when no PIN', () async {
      when(() => mockPinManager.hasPin()).thenAnswer((_) async => false);

      final result = await authService.hasPin();

      expect(result.isSuccess, true);
      expect(result.value, false);
    });

    test('should return AuthFailure when PinManager throws', () async {
      when(() => mockPinManager.hasPin()).thenThrow(Exception('Storage error'));

      final result = await authService.hasPin();

      expect(result.isError, true);
      expect(result.failure?.message, 'Failed to check PIN');
    });
  });

  group('setPin', () {
    test('should return success on success', () async {
      when(() => mockPinManager.setPin('1234')).thenAnswer((_) async {});

      final result = await authService.setPin('1234');

      expect(result.isSuccess, true);
      verify(() => mockPinManager.setPin('1234')).called(1);
    });

    test('should return AuthFailure when PinManager throws', () async {
      when(
        () => mockPinManager.setPin('1234'),
      ).thenThrow(Exception('Write error'));

      final result = await authService.setPin('1234');

      expect(result.isError, true);
      expect(result.failure?.message, 'Failed to set PIN');
    });
  });

  group('verifyPin', () {
    test('should return true when PIN is correct', () async {
      when(
        () => mockPinManager.verifyPin('1234'),
      ).thenAnswer((_) async => true);

      final result = await authService.verifyPin('1234');

      expect(result.isSuccess, true);
      expect(result.value, true);
      verify(() => mockPinManager.verifyPin('1234')).called(1);
    });

    test('should return false when PIN is wrong', () async {
      when(
        () => mockPinManager.verifyPin('0000'),
      ).thenAnswer((_) async => false);

      final result = await authService.verifyPin('0000');

      expect(result.isSuccess, true);
      expect(result.value, false);
    });

    test('should return AuthFailure when PinManager throws', () async {
      when(
        () => mockPinManager.verifyPin('1234'),
      ).thenThrow(Exception('Read error'));

      final result = await authService.verifyPin('1234');

      expect(result.isError, true);
      expect(result.failure?.message, 'Failed to verify PIN');
    });
  });

  group('authenticateWithBiometrics', () {
    test('should return true when biometric succeeds', () async {
      when(
        () => mockLocalSource.authenticateWithBiometrics(),
      ).thenAnswer((_) async => true);

      final result = await authService.authenticateWithBiometrics();

      expect(result.isSuccess, true);
      expect(result.value, true);
      verify(() => mockLocalSource.authenticateWithBiometrics()).called(1);
    });

    test('should return false when biometric is rejected', () async {
      when(
        () => mockLocalSource.authenticateWithBiometrics(),
      ).thenAnswer((_) async => false);

      final result = await authService.authenticateWithBiometrics();

      expect(result.isSuccess, true);
      expect(result.value, false);
    });

    test('should return AuthFailure when biometric throws', () async {
      when(
        () => mockLocalSource.authenticateWithBiometrics(),
      ).thenThrow(Exception('Biometric unavailable'));

      final result = await authService.authenticateWithBiometrics();

      expect(result.isError, true);
      expect(result.failure?.message, 'Biometric authentication failed');
    });
  });
}
