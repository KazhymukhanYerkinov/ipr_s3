import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/network/auth_interceptor.dart';
import 'package:ipr_s3/core/network/security_interceptor.dart';
import 'package:ipr_s3/core/security/secure_logger.dart';
import 'package:ipr_s3/features/auth/data/sources/auth_local_source.dart';

/// HTTP-клиент приложения, обёртка над Dio.
///
/// Порядок interceptor'ов важен — запрос проходит через них последовательно:
/// 1. SecurityInterceptor — проверяет HTTPS, блокирует HTTP
/// 2. AuthInterceptor — добавляет Bearer-токен из SecureStorage
///
/// Когда появится свой бэкенд:
/// 1. Замени baseUrl на URL своего API
/// 2. Используй apiClient.dio для запросов в remote source'ах
///
/// Пример использования в remote source:
/// ```dart
/// class SomeRemoteSource {
///   final ApiClient _apiClient;
///
///   Future<SomeDto> getData() async {
///     final response = await _apiClient.dio.get('/api/data');
///     return SomeDto.fromJson(response.data);
///   }
/// }
/// ```
@lazySingleton
class ApiClient {
  late final Dio _dio;

  ApiClient(AuthLocalSource authLocalSource) {
    final logger = SecureLogger();

    _dio = Dio(
      BaseOptions(
        // TODO: Замени на URL своего бэкенда, когда он будет готов.
        // ВАЖНО: URL должен начинаться с https://
        // SecurityInterceptor заблокирует запрос, если URL начинается с http://
        baseUrl: 'https://api.example.com',

        // Таймауты — защита от зависания приложения
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),

        // Формат данных по умолчанию
        contentType: 'application/json',
      ),
    );

    // Порядок interceptor'ов:
    // 1. SecurityInterceptor ПЕРВЫЙ — чтобы заблокировать HTTP ДО того,
    //    как AuthInterceptor добавит токен (иначе токен утечёт по HTTP)
    // 2. AuthInterceptor ВТОРОЙ — добавляет токен только к безопасным запросам
    _dio.interceptors.addAll([
      SecurityInterceptor(logger),
      AuthInterceptor(authLocalSource),
    ]);
  }

  /// Dio-инстанс для выполнения запросов.
  /// Используй его в remote source'ах для GET/POST/PUT/DELETE.
  Dio get dio => _dio;
}
