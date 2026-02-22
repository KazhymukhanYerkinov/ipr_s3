import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/di/injection.dart';
import 'core/localization/localization.dart';
import 'core/router/app_router.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthBloc>()..add(AuthCheckRequested()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          switch (state) {
            case Unauthenticated():
              _appRouter.replaceAll([const AuthSignInRoute()]);
            case PinSetupRequired():
              _appRouter.replaceAll([const SetPinRoute()]);
            case PinRequired():
              _appRouter.replaceAll([const LockRoute()]);
            case Authenticated():
              _appRouter.replaceAll([const HomeRoute()]);
            default:
              break;
          }
        },
        child: MaterialApp.router(
          title: 'File Secure',
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
      ),
    );
  }
}
