sealed class AuthEvent {}

final class GoogleSignInRequested extends AuthEvent {}

final class SignOutRequested extends AuthEvent {}

final class AuthCheckRequested extends AuthEvent {}
