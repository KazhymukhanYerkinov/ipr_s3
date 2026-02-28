import 'package:dio/dio.dart';
import 'package:ipr_s3/core/security/secure_logger.dart';

class SecurityInterceptor extends Interceptor {
  final SecureLogger _logger;

  SecurityInterceptor(this._logger);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!options.uri.isScheme('https')) {
      _logger.error(
        'BLOCKED insecure request to: ${options.uri.host} '
        '(scheme: ${options.uri.scheme})',
      );
      return handler.reject(
        DioException(
          requestOptions: options,
          message: 'HTTP requests are not allowed. Use HTTPS only.',
          type: DioExceptionType.cancel,
        ),
      );
    }

    _logger.debug('→ ${options.method} ${options.uri.path}');

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.debug(
      '← ${response.statusCode} ${response.requestOptions.method} '
      '${response.requestOptions.uri.path}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.error(
      '✗ ${err.requestOptions.method} ${err.requestOptions.uri.path} '
      'failed: ${err.response?.statusCode ?? err.type}',
    );
    handler.next(err);
  }
}
