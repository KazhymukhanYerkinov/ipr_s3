import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/network/auth_interceptor.dart';
import 'package:ipr_s3/core/network/security_interceptor.dart';
import 'package:ipr_s3/core/security/secure_logger.dart';
import 'package:ipr_s3/features/auth/data/sources/auth_local_source.dart';

@lazySingleton
class ApiClient {
  late final Dio _dio;

  ApiClient(AuthLocalSource authLocalSource) {
    final logger = SecureLogger();

    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.example.com',

        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),

        contentType: 'application/json',
      ),
    );

    _dio.interceptors.addAll([
      SecurityInterceptor(logger),
      AuthInterceptor(authLocalSource),
    ]);
  }

  Dio get dio => _dio;
}
