import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ipr_s3/features/auth/config/auth_routes.dart';
import 'package:ipr_s3/features/auth/domain/models/user.dart';
import 'package:ipr_s3/features/auth/presentation/screens/auth_home_screen.dart';
import 'package:ipr_s3/features/auth/presentation/screens/auth_sign_in_screen.dart';
import 'package:ipr_s3/features/auth/presentation/screens/lock_screen.dart';
import 'package:ipr_s3/features/auth/presentation/screens/set_pin_screen.dart';
import 'package:ipr_s3/features/benchmark/config/benchmark_routes.dart';
import 'package:ipr_s3/features/benchmark/presentation/screens/benchmark_screen.dart';
import 'package:ipr_s3/features/files/config/files_routes.dart';
import 'package:ipr_s3/features/files/presentation/file_viewer/screens/file_viewer_screen.dart';
import 'package:ipr_s3/features/files/presentation/files/screens/home_screen.dart';
import 'package:ipr_s3/features/folders/config/folders_routes.dart';
import 'package:ipr_s3/features/folders/presentation/screens/folder_tree_screen.dart';
import 'package:ipr_s3/features/settings/config/settings_routes.dart';
import 'package:ipr_s3/features/settings/presentation/screens/settings_screen.dart';
import 'package:ipr_s3/features/stats/config/stats_routes.dart';
import 'package:ipr_s3/features/stats/presentation/screens/stats_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    ...authRoutes,
    ...filesRoutes,
    ...foldersRoutes,
    ...statsRoutes,
    ...settingsRoutes,
    ...benchmarkRoutes,
  ];
}
