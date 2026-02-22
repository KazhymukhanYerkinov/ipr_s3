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
import 'package:ipr_s3/core/network/api_client.dart' as _i140;
import 'package:ipr_s3/core/security/encryption_helper.dart' as _i564;
import 'package:ipr_s3/core/security/pin_manager.dart' as _i107;
import 'package:ipr_s3/features/auth/data/services/auth_service.dart' as _i77;
import 'package:ipr_s3/features/auth/data/sources/auth_local_source.dart'
    as _i910;
import 'package:ipr_s3/features/auth/data/sources/auth_remote_source.dart'
    as _i1012;
import 'package:ipr_s3/features/auth/domain/behaviors/auth_behavior.dart'
    as _i514;
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
import 'package:ipr_s3/features/files/domain/behaviors/files_behavior.dart'
    as _i679;
import 'package:ipr_s3/features/files/domain/use_cases/decrypt_file.dart'
    as _i166;
import 'package:ipr_s3/features/files/domain/use_cases/delete_file.dart'
    as _i475;
import 'package:ipr_s3/features/files/domain/use_cases/get_files.dart' as _i942;
import 'package:ipr_s3/features/files/domain/use_cases/import_file.dart'
    as _i188;
import 'package:ipr_s3/features/files/domain/use_cases/search_files.dart'
    as _i787;
import 'package:ipr_s3/features/files/presentation/bloc/files_bloc.dart'
    as _i288;
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
    gh.lazySingleton<_i59.FirebaseAuth>(() => registerModule.firebaseAuth);
    gh.lazySingleton<_i116.GoogleSignIn>(() => registerModule.googleSignIn);
    gh.lazySingleton<_i558.FlutterSecureStorage>(
        () => registerModule.secureStorage);
    gh.lazySingleton<_i152.LocalAuthentication>(() => registerModule.localAuth);
    gh.lazySingleton<_i424.FileSearchService>(() => _i424.FileSearchService());
    gh.lazySingleton<_i681.ThumbnailService>(() => _i681.ThumbnailService());
    gh.lazySingleton<_i910.AuthLocalSource>(() => _i910.AuthLocalSourceImpl(
          gh<_i558.FlutterSecureStorage>(),
          gh<_i152.LocalAuthentication>(),
        ));
    gh.lazySingleton<_i107.PinManager>(
        () => _i107.PinManager(gh<_i558.FlutterSecureStorage>()));
    gh.lazySingleton<_i564.EncryptionHelper>(
        () => _i564.EncryptionHelper(gh<_i558.FlutterSecureStorage>()));
    gh.lazySingleton<_i140.ApiClient>(
        () => _i140.ApiClient(gh<_i910.AuthLocalSource>()));
    gh.lazySingleton<_i78.FileEncryptionService>(
        () => _i78.FileEncryptionService(gh<_i564.EncryptionHelper>()));
    gh.lazySingleton<_i1012.AuthRemoteSource>(() => _i1012.AuthRemoteSourceImpl(
          gh<_i59.FirebaseAuth>(),
          gh<_i116.GoogleSignIn>(),
        ));
    gh.lazySingleton<_i943.FilesLocalSource>(
        () => _i943.FilesLocalSourceImpl(gh<_i564.EncryptionHelper>()));
    gh.lazySingleton<_i462.EncryptionQueue>(
        () => _i462.EncryptionQueue(gh<_i78.FileEncryptionService>()));
    gh.lazySingleton<_i679.FilesBehavior>(() => _i86.FilesRepositoryImpl(
          gh<_i943.FilesLocalSource>(),
          gh<_i78.FileEncryptionService>(),
          gh<_i681.ThumbnailService>(),
          gh<_i424.FileSearchService>(),
        ));
    gh.lazySingleton<_i514.AuthBehavior>(() => _i77.AuthService(
          gh<_i1012.AuthRemoteSource>(),
          gh<_i910.AuthLocalSource>(),
          gh<_i107.PinManager>(),
        ));
    gh.lazySingleton<_i475.DeleteFileUseCase>(
        () => _i475.DeleteFileUseCase(gh<_i679.FilesBehavior>()));
    gh.lazySingleton<_i188.ImportFileUseCase>(
        () => _i188.ImportFileUseCase(gh<_i679.FilesBehavior>()));
    gh.lazySingleton<_i166.DecryptFileUseCase>(
        () => _i166.DecryptFileUseCase(gh<_i679.FilesBehavior>()));
    gh.lazySingleton<_i942.GetFilesUseCase>(
        () => _i942.GetFilesUseCase(gh<_i679.FilesBehavior>()));
    gh.lazySingleton<_i787.SearchFilesUseCase>(
        () => _i787.SearchFilesUseCase(gh<_i679.FilesBehavior>()));
    gh.factory<_i288.FilesBloc>(() => _i288.FilesBloc(
          gh<_i942.GetFilesUseCase>(),
          gh<_i188.ImportFileUseCase>(),
          gh<_i475.DeleteFileUseCase>(),
          gh<_i787.SearchFilesUseCase>(),
        ));
    gh.lazySingleton<_i262.VerifyPinUseCase>(
        () => _i262.VerifyPinUseCase(gh<_i514.AuthBehavior>()));
    gh.lazySingleton<_i188.AuthSignInWithGoogleUseCase>(
        () => _i188.AuthSignInWithGoogleUseCase(gh<_i514.AuthBehavior>()));
    gh.lazySingleton<_i296.AuthSignOutUseCase>(
        () => _i296.AuthSignOutUseCase(gh<_i514.AuthBehavior>()));
    gh.lazySingleton<_i411.HasPinUseCase>(
        () => _i411.HasPinUseCase(gh<_i514.AuthBehavior>()));
    gh.lazySingleton<_i254.AuthGetCurrentUserUseCase>(
        () => _i254.AuthGetCurrentUserUseCase(gh<_i514.AuthBehavior>()));
    gh.lazySingleton<_i139.AuthenticateBiometricsUseCase>(
        () => _i139.AuthenticateBiometricsUseCase(gh<_i514.AuthBehavior>()));
    gh.lazySingleton<_i712.SetPinUseCase>(
        () => _i712.SetPinUseCase(gh<_i514.AuthBehavior>()));
    gh.factory<_i541.AuthBloc>(() => _i541.AuthBloc(
          gh<_i296.AuthSignOutUseCase>(),
          gh<_i188.AuthSignInWithGoogleUseCase>(),
          gh<_i254.AuthGetCurrentUserUseCase>(),
          gh<_i411.HasPinUseCase>(),
          gh<_i712.SetPinUseCase>(),
          gh<_i262.VerifyPinUseCase>(),
          gh<_i139.AuthenticateBiometricsUseCase>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i345.RegisterModule {}
