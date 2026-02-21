import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ipr_s3/features/auth/domain/entities/user.dart';
import 'package:ipr_s3/features/auth/presentation/screens/auth_home_screen.dart';
import 'package:ipr_s3/features/auth/presentation/screens/auth_sign_in_screen.dart';
import 'package:ipr_s3/features/auth/presentation/screens/lock_screen.dart';
import 'package:ipr_s3/features/auth/presentation/screens/set_pin_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: AuthSignInRoute.page, initial: true),
    AutoRoute(page: AuthHomeRoute.page),
    AutoRoute(page: LockRoute.page),
    AutoRoute(page: SetPinRoute.page),
  ];
}
