// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:google_sign_in/google_sign_in.dart' as _i116;
import 'package:injectable/injectable.dart' as _i526;
import 'package:ipr_s3/core/di/register_module.dart' as _i345;
import 'package:ipr_s3/core/platform/device_info_channel.dart' as _i851;
import 'package:ipr_s3/core/platform/native_hash_service.dart' as _i865;
import 'package:ipr_s3/core/security/encryption_helper.dart' as _i564;
import 'package:ipr_s3/core/security/pin_manager.dart' as _i107;
import 'package:ipr_s3/features/auth/config/auth_module.dart' as _i691;
import 'package:ipr_s3/features/auth/data/services/auth_service.dart' as _i77;
import 'package:ipr_s3/features/auth/data/sources/auth_local_source.dart'
    as _i910;
import 'package:ipr_s3/features/auth/data/sources/auth_remote_source.dart'
    as _i1012;
import 'package:ipr_s3/features/auth/domain/behaviors/authenticate_with_biometrics_behavior.dart'
    as _i710;
import 'package:ipr_s3/features/auth/domain/behaviors/get_current_user_behavior.dart'
    as _i342;
import 'package:ipr_s3/features/auth/domain/behaviors/has_pin_behavior.dart'
    as _i664;
import 'package:ipr_s3/features/auth/domain/behaviors/set_pin_behavior.dart'
    as _i503;
import 'package:ipr_s3/features/auth/domain/behaviors/sign_in_with_google_behavior.dart'
    as _i310;
import 'package:ipr_s3/features/auth/domain/behaviors/sign_out_behavior.dart'
    as _i369;
import 'package:ipr_s3/features/auth/domain/behaviors/verify_pin_behavior.dart'
    as _i692;
import 'package:ipr_s3/features/auth/domain/use_cases/auth_get_current_user_use_case.dart'
    as _i254;
import 'package:ipr_s3/features/auth/domain/use_cases/auth_sign_in_with_google_use_case.dart'
    as _i188;
import 'package:ipr_s3/features/auth/domain/use_cases/auth_sign_out_use_case.dart'
    as _i296;
import 'package:ipr_s3/features/auth/domain/use_cases/authenticate_biometrics_use_case.dart'
    as _i139;
import 'package:ipr_s3/features/auth/domain/use_cases/has_pin_use_case.dart'
    as _i411;
import 'package:ipr_s3/features/auth/domain/use_cases/set_pin_use_case.dart'
    as _i712;
import 'package:ipr_s3/features/auth/domain/use_cases/verify_pin_use_case.dart'
    as _i262;
import 'package:ipr_s3/features/auth/presentation/bloc/auth_bloc.dart' as _i541;
import 'package:ipr_s3/features/benchmark/presentation/bloc/benchmark_bloc.dart'
    as _i870;
import 'package:ipr_s3/features/files/config/files_module.dart' as _i594;
import 'package:ipr_s3/features/files/data/repositories/files_repository_impl.dart'
    as _i86;
import 'package:ipr_s3/features/files/data/services/encryption_queue.dart'
    as _i462;
import 'package:ipr_s3/features/files/data/services/file_encryption_service.dart'
    as _i78;
import 'package:ipr_s3/features/files/data/services/file_search_service.dart'
    as _i424;
import 'package:ipr_s3/features/files/data/services/thumbnail_service.dart'
    as _i681;
import 'package:ipr_s3/features/files/data/sources/files_local_source.dart'
    as _i943;
import 'package:ipr_s3/features/files/domain/behaviors/decrypt_file_behavior.dart'
    as _i331;
import 'package:ipr_s3/features/files/domain/behaviors/get_files_behavior.dart'
    as _i570;
import 'package:ipr_s3/features/files/domain/behaviors/import_file_behavior.dart'
    as _i20;
import 'package:ipr_s3/features/files/domain/behaviors/search_files_behavior.dart'
    as _i279;
import 'package:ipr_s3/features/files/domain/commands/command_manager.dart'
    as _i458;
import 'package:ipr_s3/features/files/domain/use_cases/decrypt_file.dart'
    as _i166;
import 'package:ipr_s3/features/files/domain/use_cases/get_files.dart' as _i942;
import 'package:ipr_s3/features/files/domain/use_cases/import_file.dart'
    as _i188;
import 'package:ipr_s3/features/files/domain/use_cases/search_files.dart'
    as _i787;
import 'package:ipr_s3/features/files/presentation/bloc/files_bloc.dart'
    as _i288;
import 'package:ipr_s3/features/folders/config/folders_module.dart' as _i13;
import 'package:ipr_s3/features/folders/data/repositories/folders_repository_impl.dart'
    as _i575;
import 'package:ipr_s3/features/folders/data/sources/folders_local_source.dart'
    as _i57;
import 'package:ipr_s3/features/folders/domain/behaviors/create_folder_behavior.dart'
    as _i19;
import 'package:ipr_s3/features/folders/domain/behaviors/delete_folder_behavior.dart'
    as _i559;
import 'package:ipr_s3/features/folders/domain/behaviors/get_folders_behavior.dart'
    as _i152;
import 'package:ipr_s3/features/folders/domain/behaviors/move_file_to_folder_behavior.dart'
    as _i164;
import 'package:ipr_s3/features/folders/domain/use_cases/create_folder.dart'
    as _i327;
import 'package:ipr_s3/features/folders/domain/use_cases/delete_folder.dart'
    as _i246;
import 'package:ipr_s3/features/folders/domain/use_cases/move_file_to_folder.dart'
    as _i562;
import 'package:ipr_s3/features/folders/presentation/bloc/folders_bloc.dart'
    as _i134;
import 'package:ipr_s3/features/settings/presentation/bloc/settings_bloc.dart'
    as _i789;
import 'package:ipr_s3/features/stats/presentation/bloc/stats_bloc.dart'
    as _i243;
import 'package:local_auth/local_auth.dart' as _i152;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    final authModule = _$AuthModule();
    final filesModule = _$FilesModule();
    final foldersModule = _$FoldersModule();
    gh.lazySingleton<_i59.FirebaseAuth>(() => registerModule.firebaseAuth);
    gh.lazySingleton<_i116.GoogleSignIn>(() => registerModule.googleSignIn);
    gh.lazySingleton<_i558.FlutterSecureStorage>(
        () => registerModule.secureStorage);
    gh.lazySingleton<_i152.LocalAuthentication>(() => registerModule.localAuth);
    gh.lazySingleton<_i851.DeviceInfoChannel>(() => _i851.DeviceInfoChannel());
    gh.lazySingleton<_i865.NativeHashService>(() => _i865.NativeHashService());
    gh.lazySingleton<_i424.FileSearchService>(() => _i424.FileSearchService());
    gh.lazySingleton<_i681.ThumbnailService>(() => _i681.ThumbnailService());
    gh.lazySingleton<_i458.CommandManager>(() => _i458.CommandManager());
    gh.lazySingleton<_i910.AuthLocalSource>(() => _i910.AuthLocalSourceImpl(
          gh<_i558.FlutterSecureStorage>(),
          gh<_i152.LocalAuthentication>(),
        ));
    gh.lazySingleton<_i107.PinManager>(
        () => _i107.PinManager(gh<_i558.FlutterSecureStorage>()));
    gh.lazySingleton<_i564.EncryptionHelper>(
        () => _i564.EncryptionHelper(gh<_i558.FlutterSecureStorage>()));
    gh.lazySingleton<_i57.FoldersLocalSource>(
        () => _i57.FoldersLocalSourceImpl(gh<_i564.EncryptionHelper>()));
    gh.lazySingleton<_i78.FileEncryptionService>(
        () => _i78.FileEncryptionService(gh<_i564.EncryptionHelper>()));
    gh.factory<_i870.BenchmarkBloc>(
        () => _i870.BenchmarkBloc(gh<_i865.NativeHashService>()));
    gh.lazySingleton<_i1012.AuthRemoteSource>(() => _i1012.AuthRemoteSourceImpl(
          gh<_i59.FirebaseAuth>(),
          gh<_i116.GoogleSignIn>(),
        ));
    gh.factory<_i789.SettingsBloc>(() => _i789.SettingsBloc(
          gh<_i851.DeviceInfoChannel>(),
          gh<_i107.PinManager>(),
        ));
    gh.lazySingleton<_i943.FilesLocalSource>(
        () => _i943.FilesLocalSourceImpl(gh<_i564.EncryptionHelper>()));
    gh.lazySingleton<_i462.EncryptionQueue>(
        () => _i462.EncryptionQueue(gh<_i78.FileEncryptionService>()));
    gh.lazySingleton<_i86.FilesRepositoryImpl>(() => _i86.FilesRepositoryImpl(
          gh<_i943.FilesLocalSource>(),
          gh<_i78.FileEncryptionService>(),
          gh<_i681.ThumbnailService>(),
          gh<_i424.FileSearchService>(),
          gh<_i865.NativeHashService>(),
        ));
    gh.lazySingleton<_i77.AuthService>(() => _i77.AuthService(
          gh<_i1012.AuthRemoteSource>(),
          gh<_i910.AuthLocalSource>(),
          gh<_i107.PinManager>(),
        ));
    gh.lazySingleton<_i575.FoldersRepositoryImpl>(
        () => _i575.FoldersRepositoryImpl(
              gh<_i57.FoldersLocalSource>(),
              gh<_i943.FilesLocalSource>(),
            ));
    gh.factory<_i342.GetCurrentUserBehavior>(
        () => authModule.getCurrentUserBehavior(gh<_i77.AuthService>()));
    gh.factory<_i310.SignInWithGoogleBehavior>(
        () => authModule.signInWithGoogleBehavior(gh<_i77.AuthService>()));
    gh.factory<_i369.SignOutBehavior>(
        () => authModule.signOutBehavior(gh<_i77.AuthService>()));
    gh.factory<_i664.HasPinBehavior>(
        () => authModule.hasPinBehavior(gh<_i77.AuthService>()));
    gh.factory<_i503.SetPinBehavior>(
        () => authModule.setPinBehavior(gh<_i77.AuthService>()));
    gh.factory<_i692.VerifyPinBehavior>(
        () => authModule.verifyPinBehavior(gh<_i77.AuthService>()));
    gh.factory<_i710.AuthenticateWithBiometricsBehavior>(() =>
        authModule.authenticateWithBiometricsBehavior(gh<_i77.AuthService>()));
    gh.lazySingleton<_i712.SetPinUseCase>(
        () => _i712.SetPinUseCase(gh<_i503.SetPinBehavior>()));
    gh.lazySingleton<_i411.HasPinUseCase>(
        () => _i411.HasPinUseCase(gh<_i664.HasPinBehavior>()));
    gh.lazySingleton<_i188.AuthSignInWithGoogleUseCase>(() =>
        _i188.AuthSignInWithGoogleUseCase(
            gh<_i310.SignInWithGoogleBehavior>()));
    gh.lazySingleton<_i262.VerifyPinUseCase>(
        () => _i262.VerifyPinUseCase(gh<_i692.VerifyPinBehavior>()));
    gh.lazySingleton<_i254.AuthGetCurrentUserUseCase>(() =>
        _i254.AuthGetCurrentUserUseCase(gh<_i342.GetCurrentUserBehavior>()));
    gh.factory<_i570.GetFilesBehavior>(
        () => filesModule.getFilesBehavior(gh<_i86.FilesRepositoryImpl>()));
    gh.factory<_i20.ImportFileBehavior>(
        () => filesModule.importFileBehavior(gh<_i86.FilesRepositoryImpl>()));
    gh.factory<_i331.DecryptFileBehavior>(
        () => filesModule.decryptFileBehavior(gh<_i86.FilesRepositoryImpl>()));
    gh.factory<_i279.SearchFilesBehavior>(
        () => filesModule.searchFilesBehavior(gh<_i86.FilesRepositoryImpl>()));
    gh.lazySingleton<_i296.AuthSignOutUseCase>(
        () => _i296.AuthSignOutUseCase(gh<_i369.SignOutBehavior>()));
    gh.lazySingleton<_i166.DecryptFileUseCase>(
        () => _i166.DecryptFileUseCase(gh<_i331.DecryptFileBehavior>()));
    gh.factory<_i152.GetFoldersBehavior>(() =>
        foldersModule.getFoldersBehavior(gh<_i575.FoldersRepositoryImpl>()));
    gh.factory<_i19.CreateFolderBehavior>(() =>
        foldersModule.createFolderBehavior(gh<_i575.FoldersRepositoryImpl>()));
    gh.factory<_i559.DeleteFolderBehavior>(() =>
        foldersModule.deleteFolderBehavior(gh<_i575.FoldersRepositoryImpl>()));
    gh.factory<_i164.MoveFileToFolderBehavior>(() => foldersModule
        .moveFileToFolderBehavior(gh<_i575.FoldersRepositoryImpl>()));
    gh.factory<_i243.StatsBloc>(
        () => _i243.StatsBloc(gh<_i570.GetFilesBehavior>()));
    gh.lazySingleton<_i787.SearchFilesUseCase>(
        () => _i787.SearchFilesUseCase(gh<_i279.SearchFilesBehavior>()));
    gh.lazySingleton<_i139.AuthenticateBiometricsUseCase>(() =>
        _i139.AuthenticateBiometricsUseCase(
            gh<_i710.AuthenticateWithBiometricsBehavior>()));
    gh.lazySingleton<_i188.ImportFileUseCase>(
        () => _i188.ImportFileUseCase(gh<_i20.ImportFileBehavior>()));
    gh.factory<_i541.AuthBloc>(() => _i541.AuthBloc(
          gh<_i296.AuthSignOutUseCase>(),
          gh<_i188.AuthSignInWithGoogleUseCase>(),
          gh<_i254.AuthGetCurrentUserUseCase>(),
          gh<_i411.HasPinUseCase>(),
          gh<_i712.SetPinUseCase>(),
          gh<_i262.VerifyPinUseCase>(),
          gh<_i139.AuthenticateBiometricsUseCase>(),
        ));
    gh.factory<_i246.DeleteFolderUseCase>(
        () => _i246.DeleteFolderUseCase(gh<_i559.DeleteFolderBehavior>()));
    gh.factory<_i327.CreateFolderUseCase>(
        () => _i327.CreateFolderUseCase(gh<_i19.CreateFolderBehavior>()));
    gh.lazySingleton<_i942.GetFilesUseCase>(
        () => _i942.GetFilesUseCase(gh<_i570.GetFilesBehavior>()));
    gh.factory<_i562.MoveFileToFolderUseCase>(() =>
        _i562.MoveFileToFolderUseCase(gh<_i164.MoveFileToFolderBehavior>()));
    gh.factory<_i134.FoldersBloc>(() => _i134.FoldersBloc(
          gh<_i152.GetFoldersBehavior>(),
          gh<_i327.CreateFolderUseCase>(),
          gh<_i246.DeleteFolderUseCase>(),
          gh<_i562.MoveFileToFolderUseCase>(),
        ));
    gh.factory<_i288.FilesBloc>(() => _i288.FilesBloc(
          gh<_i942.GetFilesUseCase>(),
          gh<_i188.ImportFileUseCase>(),
          gh<_i787.SearchFilesUseCase>(),
          gh<_i458.CommandManager>(),
          gh<_i943.FilesLocalSource>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i345.RegisterModule {}

class _$AuthModule extends _i691.AuthModule {}

class _$FilesModule extends _i594.FilesModule {}

class _$FoldersModule extends _i13.FoldersModule {}
