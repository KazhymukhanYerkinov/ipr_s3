import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/features/auth/domain/entities/user.dart';
import 'package:ipr_s3/features/auth/domain/use_cases/auth_get_current_user_use_case.dart';
import 'package:ipr_s3/features/auth/domain/use_cases/auth_sign_in_with_google_use_case.dart';
import 'package:ipr_s3/features/auth/domain/use_cases/auth_sign_out_use_case.dart';
import 'package:ipr_s3/features/auth/domain/use_cases/has_pin_use_case.dart';
import 'package:ipr_s3/features/auth/domain/use_cases/set_pin_use_case.dart';
import 'package:ipr_s3/features/auth/domain/use_cases/verify_pin_use_case.dart';
import 'package:ipr_s3/features/auth/domain/use_cases/authenticate_biometrics_use_case.dart';
import 'package:ipr_s3/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ipr_s3/features/auth/presentation/bloc/auth_event.dart';
import 'package:ipr_s3/features/auth/presentation/bloc/auth_state.dart';

class MockSignInWithGoogle extends Mock
    implements AuthSignInWithGoogleUseCase {}

class MockSignOut extends Mock implements AuthSignOutUseCase {}

class MockGetCurrentUser extends Mock implements AuthGetCurrentUserUseCase {}

class MockHasPin extends Mock implements HasPinUseCase {}

class MockSetPin extends Mock implements SetPinUseCase {}

class MockVerifyPin extends Mock implements VerifyPinUseCase {}

class MockAuthenticateBiometrics extends Mock
    implements AuthenticateBiometricsUseCase {}

void main() {
  late AuthBloc authBloc;
  late MockSignInWithGoogle mockSignIn;
  late MockSignOut mockSignOut;
  late MockGetCurrentUser mockGetCurrentUser;
  late MockHasPin mockHasPin;
  late MockSetPin mockSetPin;
  late MockVerifyPin mockVerifyPin;
  late MockAuthenticateBiometrics mockBiometrics;

  const testUser = UserEntity(
    uid: '123',
    email: 'test@example.com',
    displayName: 'Test User',
    photoUrl: 'https://example.com/photo.jpg',
  );

  setUp(() {
    mockSignIn = MockSignInWithGoogle();
    mockSignOut = MockSignOut();
    mockGetCurrentUser = MockGetCurrentUser();
    mockHasPin = MockHasPin();
    mockSetPin = MockSetPin();
    mockVerifyPin = MockVerifyPin();
    mockBiometrics = MockAuthenticateBiometrics();

    authBloc = AuthBloc(
      mockSignOut,
      mockSignIn,
      mockGetCurrentUser,
      mockHasPin,
      mockSetPin,
      mockVerifyPin,
      mockBiometrics,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  test('initial state should be AuthInitial', () {
    expect(authBloc.state, const AuthState.initial());
  });

  group('GoogleSignInRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [loading, pinRequired] when sign-in succeeds and PIN exists',
      build: () {
        when(() => mockSignIn())
            .thenAnswer((_) async => const Right(testUser));
        when(() => mockHasPin())
            .thenAnswer((_) async => const Right(true));
        return authBloc;
      },
      act: (bloc) => bloc.add(GoogleSignInRequested()),
      expect: () => [
        const AuthState.loading(),
        const AuthState.pinRequired(user: testUser),
      ],
      verify: (_) {
        verify(() => mockSignIn()).called(1);
        verify(() => mockHasPin()).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [loading, pinSetupRequired] when sign-in succeeds and no PIN',
      build: () {
        when(() => mockSignIn())
            .thenAnswer((_) async => const Right(testUser));
        when(() => mockHasPin())
            .thenAnswer((_) async => const Right(false));
        return authBloc;
      },
      act: (bloc) => bloc.add(GoogleSignInRequested()),
      expect: () => [
        const AuthState.loading(),
        const AuthState.pinSetupRequired(user: testUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [loading, authenticated] when sign-in succeeds and hasPin fails',
      build: () {
        when(() => mockSignIn())
            .thenAnswer((_) async => const Right(testUser));
        when(() => mockHasPin()).thenAnswer(
            (_) async => const Left(CacheFailure(message: 'no pin data')));
        return authBloc;
      },
      act: (bloc) => bloc.add(GoogleSignInRequested()),
      expect: () => [
        const AuthState.loading(),
        const AuthState.authenticated(user: testUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [loading, error] when sign-in fails',
      build: () {
        when(() => mockSignIn()).thenAnswer(
          (_) async => const Left(AuthFailure(message: 'Failed to sign in')),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(GoogleSignInRequested()),
      expect: () => [
        const AuthState.loading(),
        const AuthState.error(message: 'Failed to sign in'),
      ],
    );
  });

  group('SignOutRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [loading, unauthenticated] when sign-out succeeds',
      build: () {
        when(() => mockSignOut()).thenAnswer(
          (_) async => const Right(null),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(SignOutRequested()),
      expect: () => [
        const AuthState.loading(),
        const AuthState.unauthenticated(),
      ],
      verify: (_) {
        verify(() => mockSignOut()).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [loading, error] when sign-out fails',
      build: () {
        when(() => mockSignOut()).thenAnswer(
          (_) async => const Left(AuthFailure(message: 'Failed to sign out')),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(SignOutRequested()),
      expect: () => [
        const AuthState.loading(),
        const AuthState.error(message: 'Failed to sign out'),
      ],
    );
  });

  group('AuthCheckRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [pinRequired] when user exists and has PIN',
      build: () {
        when(() => mockGetCurrentUser())
            .thenAnswer((_) async => const Right(testUser));
        when(() => mockHasPin())
            .thenAnswer((_) async => const Right(true));
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthCheckRequested()),
      expect: () => [
        const AuthState.pinRequired(user: testUser),
      ],
      verify: (_) {
        verify(() => mockGetCurrentUser()).called(1);
        verify(() => mockHasPin()).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [pinSetupRequired] when user exists but no PIN',
      build: () {
        when(() => mockGetCurrentUser())
            .thenAnswer((_) async => const Right(testUser));
        when(() => mockHasPin())
            .thenAnswer((_) async => const Right(false));
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthCheckRequested()),
      expect: () => [
        const AuthState.pinSetupRequired(user: testUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [unauthenticated] when no user exists',
      build: () {
        when(() => mockGetCurrentUser()).thenAnswer(
          (_) async => const Right(null),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthCheckRequested()),
      expect: () => [
        const AuthState.unauthenticated(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [unauthenticated] when getCurrentUser fails',
      build: () {
        when(() => mockGetCurrentUser()).thenAnswer(
          (_) async =>
              const Left(AuthFailure(message: 'Failed to get current user')),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthCheckRequested()),
      expect: () => [
        const AuthState.unauthenticated(),
      ],
    );
  });

  group('PinSubmitted', () {
    blocTest<AuthBloc, AuthState>(
      'emits [loading, authenticated] when PIN is correct',
      build: () {
        when(() => mockSignIn())
            .thenAnswer((_) async => const Right(testUser));
        when(() => mockHasPin())
            .thenAnswer((_) async => const Right(true));
        when(() => mockVerifyPin('1234'))
            .thenAnswer((_) async => const Right(true));
        return authBloc;
      },
      act: (bloc) async {
        bloc.add(GoogleSignInRequested());
        await Future.delayed(const Duration(milliseconds: 100));
        bloc.add(PinSubmitted('1234'));
      },
      expect: () => [
        const AuthState.loading(),
        const AuthState.pinRequired(user: testUser),
        const AuthState.loading(),
        const AuthState.authenticated(user: testUser),
      ],
      verify: (_) {
        verify(() => mockVerifyPin('1234')).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [loading, error] when PIN is wrong',
      build: () {
        when(() => mockSignIn())
            .thenAnswer((_) async => const Right(testUser));
        when(() => mockHasPin())
            .thenAnswer((_) async => const Right(true));
        when(() => mockVerifyPin('0000'))
            .thenAnswer((_) async => const Right(false));
        return authBloc;
      },
      act: (bloc) async {
        bloc.add(GoogleSignInRequested());
        await Future.delayed(const Duration(milliseconds: 100));
        bloc.add(PinSubmitted('0000'));
      },
      expect: () => [
        const AuthState.loading(),
        const AuthState.pinRequired(user: testUser),
        const AuthState.loading(),
        const AuthState.error(message: 'Wrong PIN'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [unauthenticated] when no current user',
      build: () => authBloc,
      act: (bloc) => bloc.add(PinSubmitted('1234')),
      expect: () => [
        const AuthState.unauthenticated(),
      ],
    );
  });

  group('PinSetupSubmitted', () {
    blocTest<AuthBloc, AuthState>(
      'emits [loading, authenticated] when PIN setup succeeds',
      build: () {
        when(() => mockSignIn())
            .thenAnswer((_) async => const Right(testUser));
        when(() => mockHasPin())
            .thenAnswer((_) async => const Right(false));
        when(() => mockSetPin('1234'))
            .thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) async {
        bloc.add(GoogleSignInRequested());
        await Future.delayed(const Duration(milliseconds: 100));
        bloc.add(PinSetupSubmitted('1234'));
      },
      expect: () => [
        const AuthState.loading(),
        const AuthState.pinSetupRequired(user: testUser),
        const AuthState.loading(),
        const AuthState.authenticated(user: testUser),
      ],
      verify: (_) {
        verify(() => mockSetPin('1234')).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [unauthenticated] when no current user',
      build: () => authBloc,
      act: (bloc) => bloc.add(PinSetupSubmitted('1234')),
      expect: () => [
        const AuthState.unauthenticated(),
      ],
    );
  });

  group('BiometricRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [authenticated] when biometric succeeds',
      build: () {
        when(() => mockSignIn())
            .thenAnswer((_) async => const Right(testUser));
        when(() => mockHasPin())
            .thenAnswer((_) async => const Right(true));
        when(() => mockBiometrics())
            .thenAnswer((_) async => const Right(true));
        return authBloc;
      },
      act: (bloc) async {
        bloc.add(GoogleSignInRequested());
        await Future.delayed(const Duration(milliseconds: 100));
        bloc.add(BiometricRequested());
      },
      expect: () => [
        const AuthState.loading(),
        const AuthState.pinRequired(user: testUser),
        const AuthState.authenticated(user: testUser),
      ],
      verify: (_) {
        verify(() => mockBiometrics()).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'stays pinRequired when biometric fails',
      build: () {
        when(() => mockSignIn())
            .thenAnswer((_) async => const Right(testUser));
        when(() => mockHasPin())
            .thenAnswer((_) async => const Right(true));
        when(() => mockBiometrics())
            .thenAnswer((_) async => const Right(false));
        return authBloc;
      },
      act: (bloc) async {
        bloc.add(GoogleSignInRequested());
        await Future.delayed(const Duration(milliseconds: 100));
        bloc.add(BiometricRequested());
      },
      expect: () => [
        const AuthState.loading(),
        const AuthState.pinRequired(user: testUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [unauthenticated] when no current user',
      build: () => authBloc,
      act: (bloc) => bloc.add(BiometricRequested()),
      expect: () => [
        const AuthState.unauthenticated(),
      ],
    );
  });
}
