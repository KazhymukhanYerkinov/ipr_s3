sealed class AuthEvent {}

final class GoogleSignInRequested extends AuthEvent {}

final class SignOutRequested extends AuthEvent {}

final class AuthCheckRequested extends AuthEvent {}

final class PinSubmitted extends AuthEvent {
  final String pin;
  PinSubmitted(this.pin);
}

final class PinSetupSubmitted extends AuthEvent {
  final String pin;
  PinSetupSubmitted(this.pin);
}

final class BiometricRequested extends AuthEvent {}
