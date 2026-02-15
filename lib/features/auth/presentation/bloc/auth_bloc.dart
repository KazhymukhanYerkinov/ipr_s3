import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/features/auth/domain/use_cases/auth_get_current_user_use_case.dart';
import 'package:ipr_s3/features/auth/domain/use_cases/auth_sign_in_with_google_use_case.dart';
import 'package:ipr_s3/features/auth/domain/use_cases/auth_sign_out_use_case.dart';
import 'package:ipr_s3/features/auth/presentation/bloc/auth_event.dart';
import 'package:ipr_s3/features/auth/presentation/bloc/auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthSignOutUseCase _signOutUseCase;
  final AuthGetCurrentUserUseCase _getCurrentUserUseCase;
  final AuthSignInWithGoogleUseCase _signInWithGoogleUseCase;

  AuthBloc(
    this._signOutUseCase,
    this._signInWithGoogleUseCase,
    this._getCurrentUserUseCase,
  ) : super(const AuthState.initial()) {
    on<GoogleSignInRequested>(_onGoogleSignIn);
    on<SignOutRequested>(_onSignOut);
    on<AuthCheckRequested>(_onAuthCheck);
  }

  Future<void> _onGoogleSignIn(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await _signInWithGoogleUseCase();
    result.fold(
      (failure) => emit(AuthState.error(message: failure.message)),
      (user) => emit(AuthState.authenticated(user: user)),
    );
  }

  Future<void> _onSignOut(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await _signOutUseCase();
    result.fold(
      (failure) => emit(AuthState.error(message: failure.message)),
      (_) => emit(const AuthState.unauthenticated()),
    );
  }

  Future<void> _onAuthCheck(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _getCurrentUserUseCase();
    result.fold(
      (_) => emit(const AuthState.unauthenticated()),
      (user) => user != null
          ? emit(AuthState.authenticated(user: user))
          : emit(const AuthState.unauthenticated()),
    );
  }
}
