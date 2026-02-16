import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Безопасный логгер, который:
/// 1. Автоматически маскирует чувствительные данные (токены, email)
/// 2. В release-режиме показывает только ошибки
/// 3. Использует паттерн Singleton — один экземпляр на всё приложение
///
/// Зачем нужен:
/// - OWASP Mobile Top 10 (M9) — утечка данных через логи
/// - На Android logcat доступен через ADB, на рутованных устройствах — любому приложению
/// - Случайный print(token) = скомпрометированная сессия
class SecureLogger {
  // Singleton: гарантируем один экземпляр на всё приложение,
  // чтобы все логи проходили через единую точку фильтрации
  static final SecureLogger _instance = SecureLogger._internal();
  factory SecureLogger() => _instance;

  late final Logger _logger;

  SecureLogger._internal() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 0, // не показываем стек вызовов для обычных логов
        printEmojis: false, // чистый вывод без лишних символов
      ),
      // kReleaseMode — compile-time константа от Flutter.
      // В release-билде Dart tree-shaking полностью вырежет debug-код из APK/IPA.
      // Level.error — в release логируем только ошибки
      // Level.debug — в debug логируем всё
      level: kReleaseMode ? Level.error : Level.debug,
    );
  }

  /// Логирование отладочной информации (только в debug-режиме)
  void debug(String message) {
    _logger.d(_sanitize(message));
  }

  /// Логирование информационных сообщений (только в debug-режиме)
  void info(String message) {
    _logger.i(_sanitize(message));
  }

  /// Логирование предупреждений (только в debug-режиме)
  void warning(String message) {
    _logger.w(_sanitize(message));
  }

  /// Логирование ошибок (работает и в release-режиме)
  /// [error] — объект ошибки
  /// [stackTrace] — стек вызовов для диагностики
  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(_sanitize(message), error: error, stackTrace: stackTrace);
  }

  /// Маскирует чувствительные данные в строке.
  ///
  /// Даже если разработчик случайно передаст токен в лог —
  /// этот метод заменит его на [REDACTED].
  ///
  /// Защищает от утечки:
  /// - JWT токенов (формат eyJhbGci...)
  /// - Email адресов (user@example.com)
  /// - Bearer токенов из HTTP-заголовков
  String _sanitize(String message) {
    var sanitized = message;

    // JWT токены: всегда начинаются с "eyJ" (base64 от {"alg":...})
    // Формат: header.payload.signature
    sanitized = sanitized.replaceAll(
      RegExp(r'eyJ[A-Za-z0-9_-]+\.eyJ[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+'),
      '[REDACTED_JWT]',
    );

    // Email адреса: могут попасть в лог через UserEntity.toString()
    sanitized = sanitized.replaceAll(
      RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'),
      '[REDACTED_EMAIL]',
    );

    // Bearer токены: часто встречаются в HTTP-заголовках
    // Формат: "Bearer eyJhbGci..." или "Bearer abc123..."
    sanitized = sanitized.replaceAll(
      RegExp(r'Bearer\s+[A-Za-z0-9_-]+'),
      'Bearer [REDACTED]',
    );

    return sanitized;
  }
}
