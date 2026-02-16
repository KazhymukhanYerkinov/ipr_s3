import 'package:dio/dio.dart';
import 'package:ipr_s3/features/auth/data/sources/auth_local_source.dart';

/// Interceptor для автоматической вставки токена авторизации.
///
/// Что делает:
/// - Перед каждым запросом берёт токен из FlutterSecureStorage
/// - Добавляет его в заголовок `Authorization: Bearer {token}`
/// - Если токена нет — запрос уходит без заголовка (для публичных API)
///
/// Зачем:
/// - Токен передаётся ТОЛЬКО через HTTPS-заголовок, не в URL и не в теле
/// - Единая точка управления авторизацией — не нужно руками добавлять
///   токен в каждый запрос
/// - Токен берётся из SecureStorage (Keychain/Keystore),
///   а не хранится в переменной в памяти
class AuthInterceptor extends Interceptor {
  final AuthLocalSource _authLocalSource;

  AuthInterceptor(this._authLocalSource);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Достаём токен из FlutterSecureStorage.
    // Если пользователь не авторизован — токена не будет,
    // и запрос уйдёт без заголовка Authorization.
    final token = await _authLocalSource.getCachedToken();

    if (token != null) {
      // Добавляем токен в заголовок.
      // Формат "Bearer {token}" — стандарт OAuth 2.0 (RFC 6750).
      // Dio отправит этот заголовок по HTTPS — SecurityInterceptor
      // уже проверил, что запрос идёт только по HTTPS.
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }
}
