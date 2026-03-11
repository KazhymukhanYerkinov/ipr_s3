import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'core/devtools/devtools_service.dart';
import 'core/di/injection.dart';
import 'core/security/encryption_helper.dart';
import 'core/security/pin_manager.dart';
import 'core/security/secure_bloc_observer.dart';
import 'core/storage/hive_initializer.dart';
import 'features/files/domain/commands/command_manager.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await initHive();

  await configureDependencies();

  Bloc.observer = SecureBlocObserver();

  DevToolsService(
    getIt<PinManager>(),
    getIt<EncryptionHelper>(),
    getIt<CommandManager>(),
  ).register();

  runApp(MyApp());
}
