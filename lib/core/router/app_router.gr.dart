// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AuthHomeScreen]
class AuthHomeRoute extends PageRouteInfo<AuthHomeRouteArgs> {
  AuthHomeRoute({
    Key? key,
    required UserEntity user,
    List<PageRouteInfo>? children,
  }) : super(
          AuthHomeRoute.name,
          args: AuthHomeRouteArgs(
            key: key,
            user: user,
          ),
          initialChildren: children,
        );

  static const String name = 'AuthHomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AuthHomeRouteArgs>();
      return AuthHomeScreen(
        key: args.key,
        user: args.user,
      );
    },
  );
}

class AuthHomeRouteArgs {
  const AuthHomeRouteArgs({
    this.key,
    required this.user,
  });

  final Key? key;

  final UserEntity user;

  @override
  String toString() {
    return 'AuthHomeRouteArgs{key: $key, user: $user}';
  }
}

/// generated route for
/// [AuthSignInScreen]
class AuthSignInRoute extends PageRouteInfo<void> {
  const AuthSignInRoute({List<PageRouteInfo>? children})
      : super(
          AuthSignInRoute.name,
          initialChildren: children,
        );

  static const String name = 'AuthSignInRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AuthSignInScreen();
    },
  );
}
