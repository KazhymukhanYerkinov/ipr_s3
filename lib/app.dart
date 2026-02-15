import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/di/injection.dart';
import 'core/localization/localization.dart';
import 'core/localization/localization_x.dart';
import 'core/router/app_router.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthBloc>()..add(AuthCheckRequested()),
      child: MaterialApp.router(
        title: context.locale.appTitle,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
        locale: const Locale('en'),
        supportedLocales: Localization.delegate.supportedLocales,
        localizationsDelegates: const [
          Localization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        routerConfig: _appRouter.config(),
      ),
    );
  }
}
