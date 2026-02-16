import 'package:dio/dio.dart';
import 'package:ipr_s3/core/security/secure_logger.dart';

/// Interceptor, который обеспечивает безопасность сетевых запросов.
///
/// Что делает:
/// 1. Блокирует любые HTTP-запросы — пропускает только HTTPS
/// 2. Безопасно логирует запросы (только метод + путь, без тела и заголовков)
/// 3. Логирует ошибки без чувствительных данных
///
/// Зачем:
/// - OWASP Mobile Top 10 (M5) — Insecure Communication
/// - Защита от случайного использования HTTP вместо HTTPS
/// - Даже если разработчик ошибётся в URL — interceptor заблокирует запрос
class SecurityInterceptor extends Interceptor {
  final SecureLogger _logger;

  SecurityInterceptor(this._logger);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Проверяем схему URL: пропускаем только HTTPS.
    // Это защита от случайной отправки данных по незащищённому каналу.
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

    // Логируем только метод и путь — без тела запроса и заголовков,
    // потому что в них могут быть токены, пароли, персональные данные.
    _logger.debug('→ ${options.method} ${options.uri.path}');

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Логируем только статус-код — без тела ответа,
    // потому что в нём могут быть персональные данные пользователя.
    _logger.debug(
      '← ${response.statusCode} ${response.requestOptions.method} '
      '${response.requestOptions.uri.path}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Логируем ошибку: метод, путь, статус-код.
    // Не логируем тело ответа — оно может содержать чувствительные данные.
    _logger.error(
      '✗ ${err.requestOptions.method} ${err.requestOptions.uri.path} '
      'failed: ${err.response?.statusCode ?? err.type}',
    );
    handler.next(err);
  }
}
