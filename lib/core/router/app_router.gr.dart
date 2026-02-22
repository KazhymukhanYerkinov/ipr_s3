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

/// generated route for
/// [FileViewerScreen]
class FileViewerRoute extends PageRouteInfo<FileViewerRouteArgs> {
  FileViewerRoute({
    Key? key,
    required String fileId,
    required String fileName,
    List<PageRouteInfo>? children,
  }) : super(
          FileViewerRoute.name,
          args: FileViewerRouteArgs(
            key: key,
            fileId: fileId,
            fileName: fileName,
          ),
          initialChildren: children,
        );

  static const String name = 'FileViewerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<FileViewerRouteArgs>();
      return FileViewerScreen(
        key: args.key,
        fileId: args.fileId,
        fileName: args.fileName,
      );
    },
  );
}

class FileViewerRouteArgs {
  const FileViewerRouteArgs({
    this.key,
    required this.fileId,
    required this.fileName,
  });

  final Key? key;

  final String fileId;

  final String fileName;

  @override
  String toString() {
    return 'FileViewerRouteArgs{key: $key, fileId: $fileId, fileName: $fileName}';
  }
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeScreen();
    },
  );
}

/// generated route for
/// [ImportProgressScreen]
class ImportProgressRoute extends PageRouteInfo<void> {
  const ImportProgressRoute({List<PageRouteInfo>? children})
      : super(
          ImportProgressRoute.name,
          initialChildren: children,
        );

  static const String name = 'ImportProgressRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ImportProgressScreen();
    },
  );
}

/// generated route for
/// [LockScreen]
class LockRoute extends PageRouteInfo<void> {
  const LockRoute({List<PageRouteInfo>? children})
      : super(
          LockRoute.name,
          initialChildren: children,
        );

  static const String name = 'LockRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LockScreen();
    },
  );
}

/// generated route for
/// [SetPinScreen]
class SetPinRoute extends PageRouteInfo<void> {
  const SetPinRoute({List<PageRouteInfo>? children})
      : super(
          SetPinRoute.name,
          initialChildren: children,
        );

  static const String name = 'SetPinRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SetPinScreen();
    },
  );
}
