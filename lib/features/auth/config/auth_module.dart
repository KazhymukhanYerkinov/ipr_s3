import 'package:injectable/injectable.dart';
import 'package:ipr_s3/features/auth/data/services/auth_service.dart';
import 'package:ipr_s3/features/auth/domain/behaviors/authenticate_with_biometrics_behavior.dart';
import 'package:ipr_s3/features/auth/domain/behaviors/get_current_user_behavior.dart';
import 'package:ipr_s3/features/auth/domain/behaviors/has_pin_behavior.dart';
import 'package:ipr_s3/features/auth/domain/behaviors/set_pin_behavior.dart';
import 'package:ipr_s3/features/auth/domain/behaviors/sign_in_with_google_behavior.dart';
import 'package:ipr_s3/features/auth/domain/behaviors/sign_out_behavior.dart';
import 'package:ipr_s3/features/auth/domain/behaviors/verify_pin_behavior.dart';

@module
abstract class AuthModule {
  @factoryMethod
  GetCurrentUserBehavior getCurrentUserBehavior(AuthService authService) =>
      authService;

  @factoryMethod
  SignInWithGoogleBehavior signInWithGoogleBehavior(AuthService authService) =>
      authService;

  @factoryMethod
  SignOutBehavior signOutBehavior(AuthService authService) => authService;

  @factoryMethod
  HasPinBehavior hasPinBehavior(AuthService authService) => authService;

  @factoryMethod
  SetPinBehavior setPinBehavior(AuthService authService) => authService;

  @factoryMethod
  VerifyPinBehavior verifyPinBehavior(AuthService authService) => authService;

  @factoryMethod
  AuthenticateWithBiometricsBehavior authenticateWithBiometricsBehavior(
    AuthService authService,
  ) => authService;
}
