import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/features/auth/domain/entities/user.dart';
import 'package:ipr_s3/features/auth/domain/use_cases/auth_get_current_user_use_case.dart';
import 'package:ipr_s3/features/auth/domain/use_cases/auth_sign_in_with_google_use_case.dart';
import 'package:ipr_s3/features/auth/domain/use_cases/auth_sign_out_use_case.dart';
import 'package:ipr_s3/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ipr_s3/features/auth/presentation/bloc/auth_event.dart';
import 'package:ipr_s3/features/auth/presentation/bloc/auth_state.dart';

class MockSignInWithGoogle extends Mock
    implements AuthSignInWithGoogleUseCase {}

class MockSignOut extends Mock implements AuthSignOutUseCase {}

class MockGetCurrentUser extends Mock implements AuthGetCurrentUserUseCase {}

void main() {
  late AuthBloc authBloc;
  late MockSignInWithGoogle mockSignIn;
  late MockSignOut mockSignOut;
  late MockGetCurrentUser mockGetCurrentUser;

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
    authBloc = AuthBloc(mockSignOut, mockSignIn, mockGetCurrentUser);
  });

  tearDown(() {
    authBloc.close();
  });

  test('initial state should be AuthInitial', () {
    expect(authBloc.state, const AuthState.initial());
  });

  group('GoogleSignInRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [loading, authenticated] when sign-in succeeds',
      build: () {
        when(() => mockSignIn()).thenAnswer(
          (_) async => const Right(testUser),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(GoogleSignInRequested()),
      expect: () => [
        const AuthState.loading(),
        const AuthState.authenticated(user: testUser),
      ],
      verify: (_) {
        verify(() => mockSignIn()).called(1);
      },
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
      'emits [authenticated] when user exists',
      build: () {
        when(() => mockGetCurrentUser()).thenAnswer(
          (_) async => const Right(testUser),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthCheckRequested()),
      expect: () => [
        const AuthState.authenticated(user: testUser),
      ],
      verify: (_) {
        verify(() => mockGetCurrentUser()).called(1);
      },
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
}
