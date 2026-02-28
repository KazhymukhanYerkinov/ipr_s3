import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/features/auth/domain/models/user.dart';
import 'package:ipr_s3/features/auth/domain/use_cases/authenticate_biometrics_use_case.dart';
import 'package:ipr_s3/features/auth/domain/use_cases/auth_get_current_user_use_case.dart';
import 'package:ipr_s3/features/auth/domain/use_cases/auth_sign_in_with_google_use_case.dart';
import 'package:ipr_s3/features/auth/domain/use_cases/auth_sign_out_use_case.dart';
import 'package:ipr_s3/features/auth/domain/use_cases/has_pin_use_case.dart';
import 'package:ipr_s3/features/auth/domain/use_cases/set_pin_use_case.dart';
import 'package:ipr_s3/features/auth/domain/use_cases/verify_pin_use_case.dart';
import 'package:ipr_s3/features/auth/presentation/bloc/auth_event.dart';
import 'package:ipr_s3/features/auth/presentation/bloc/auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthSignOutUseCase _signOutUseCase;
  final AuthGetCurrentUserUseCase _getCurrentUserUseCase;
  final AuthSignInWithGoogleUseCase _signInWithGoogleUseCase;
  final HasPinUseCase _hasPinUseCase;
  final SetPinUseCase _setPinUseCase;
  final VerifyPinUseCase _verifyPinUseCase;
  final AuthenticateBiometricsUseCase _authenticateBiometricsUseCase;

  AuthBloc(
    this._signOutUseCase,
    this._signInWithGoogleUseCase,
    this._getCurrentUserUseCase,
    this._hasPinUseCase,
    this._setPinUseCase,
    this._verifyPinUseCase,
    this._authenticateBiometricsUseCase,
  ) : super(const AuthState.initial()) {
    _setupHandlers();
  }

  UserEntity? _currentUser;

  void _setupHandlers() {
    on<GoogleSignInRequested>(_onGoogleSignIn);
    on<SignOutRequested>(_onSignOut);
    on<AuthCheckRequested>(_onAuthCheck);
    on<PinSubmitted>(_onPinSubmitted);
    on<PinSetupSubmitted>(_onPinSetupSubmitted);
    on<BiometricRequested>(_onBiometricRequested);
  }

  Future<void> _onGoogleSignIn(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await _signInWithGoogleUseCase();
    final failure = result.failure;

    if (failure != null) {
      emit(AuthState.error(message: failure.message));
      return;
    }

    _currentUser = result.value;
    if (_currentUser != null) {
      await _checkPinStatus(_currentUser!, emit);
    }
  }

  Future<void> _onSignOut(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await _signOutUseCase();
    final failure = result.failure;

    if (failure != null) {
      emit(AuthState.error(message: failure.message));
      return;
    }

    _currentUser = null;
    emit(const AuthState.unauthenticated());
  }

  Future<void> _onAuthCheck(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _getCurrentUserUseCase();
    final failure = result.failure;

    if (failure != null) {
      emit(const AuthState.unauthenticated());
      return;
    }

    final user = result.value;
    if (user == null) {
      emit(const AuthState.unauthenticated());
      return;
    }

    _currentUser = user;
    await _checkPinStatus(user, emit);
  }

  Future<void> _onPinSubmitted(
    PinSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    final user = _currentUser;
    if (user == null) {
      emit(const AuthState.unauthenticated());
      return;
    }

    emit(const AuthState.loading());
    final result = await _verifyPinUseCase(event.pin);
    final failure = result.failure;

    if (failure != null) {
      emit(AuthState.error(message: failure.message));
      return;
    }

    final isValid = result.value ?? false;
    if (isValid) {
      emit(AuthState.authenticated(user: user));
    } else {
      emit(const AuthState.error(message: 'Wrong PIN'));
    }
  }

  Future<void> _onPinSetupSubmitted(
    PinSetupSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    final user = _currentUser;
    if (user == null) {
      emit(const AuthState.unauthenticated());
      return;
    }

    emit(const AuthState.loading());
    final result = await _setPinUseCase(event.pin);
    final failure = result.failure;

    if (failure != null) {
      emit(AuthState.error(message: failure.message));
      return;
    }

    emit(AuthState.authenticated(user: user));
  }

  Future<void> _onBiometricRequested(
    BiometricRequested event,
    Emitter<AuthState> emit,
  ) async {
    final user = _currentUser;
    if (user == null) {
      emit(const AuthState.unauthenticated());
      return;
    }

    final result = await _authenticateBiometricsUseCase();
    final success = result.value ?? false;

    if (success) {
      emit(AuthState.authenticated(user: user));
    } else {
      emit(AuthState.pinRequired(user: user));
    }
  }

  Future<void> _checkPinStatus(UserEntity user, Emitter<AuthState> emit) async {
    final hasPinResult = await _hasPinUseCase();
    final hasPin = hasPinResult.value ?? false;

    if (hasPin) {
      emit(AuthState.pinRequired(user: user));
    } else {
      emit(AuthState.pinSetupRequired(user: user));
    }
  }
}
