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
import 'package:ipr_s3/core/security/encryption_helper.dart' as _i564;
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
import 'package:ipr_s3/features/auth/presentation/bloc/auth_bloc.dart' as _i541;

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
    gh.lazySingleton<_i564.EncryptionHelper>(
        () => _i564.EncryptionHelper(gh<_i558.FlutterSecureStorage>()));
    gh.lazySingleton<_i910.AuthLocalSource>(
        () => _i910.AuthLocalSourceImpl(gh<_i558.FlutterSecureStorage>()));
    gh.lazySingleton<_i1012.AuthRemoteSource>(() => _i1012.AuthRemoteSourceImpl(
          gh<_i59.FirebaseAuth>(),
          gh<_i116.GoogleSignIn>(),
        ));
    gh.lazySingleton<_i514.AuthBehavior>(() => _i77.AuthService(
          gh<_i1012.AuthRemoteSource>(),
          gh<_i910.AuthLocalSource>(),
        ));
    gh.lazySingleton<_i188.AuthSignInWithGoogleUseCase>(
        () => _i188.AuthSignInWithGoogleUseCase(gh<_i514.AuthBehavior>()));
    gh.lazySingleton<_i296.AuthSignOutUseCase>(
        () => _i296.AuthSignOutUseCase(gh<_i514.AuthBehavior>()));
    gh.lazySingleton<_i254.AuthGetCurrentUserUseCase>(
        () => _i254.AuthGetCurrentUserUseCase(gh<_i514.AuthBehavior>()));
    gh.factory<_i541.AuthBloc>(() => _i541.AuthBloc(
          gh<_i296.AuthSignOutUseCase>(),
          gh<_i188.AuthSignInWithGoogleUseCase>(),
          gh<_i254.AuthGetCurrentUserUseCase>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i345.RegisterModule {}
