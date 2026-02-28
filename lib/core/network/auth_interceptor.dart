import 'package:dio/dio.dart';
import 'package:ipr_s3/features/auth/data/sources/auth_local_source.dart';

class AuthInterceptor extends Interceptor {
  final AuthLocalSource _authLocalSource;

  AuthInterceptor(this._authLocalSource);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _authLocalSource.getCachedToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }
}
