import 'package:auto_route/auto_route.dart';
import 'package:ipr_s3/core/router/app_router.dart';

List<AutoRoute> authRoutes = [
  AutoRoute(page: AuthSignInRoute.page, initial: true),
  AutoRoute(page: AuthHomeRoute.page),
  AutoRoute(page: LockRoute.page),
  AutoRoute(page: SetPinRoute.page),
];
