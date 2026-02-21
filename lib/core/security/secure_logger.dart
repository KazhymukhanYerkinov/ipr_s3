import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class SecureLogger {
  static final SecureLogger _instance = SecureLogger._internal();
  factory SecureLogger() => _instance;

  late final Logger _logger;

  SecureLogger._internal() {
    _logger = Logger(
      printer: PrettyPrinter(methodCount: 0, printEmojis: false),
      level: kReleaseMode ? Level.error : Level.debug,
    );
  }

  void debug(String message) {
    _logger.d(_sanitize(message));
  }

  void info(String message) {
    _logger.i(_sanitize(message));
  }

  void warning(String message) {
    _logger.w(_sanitize(message));
  }

  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(_sanitize(message), error: error, stackTrace: stackTrace);
  }

  String _sanitize(String message) {
    var sanitized = message;

    sanitized = sanitized.replaceAll(
      RegExp(r'eyJ[A-Za-z0-9_-]+\.eyJ[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+'),
      '[REDACTED_JWT]',
    );

    sanitized = sanitized.replaceAll(
      RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'),
      '[REDACTED_EMAIL]',
    );

    sanitized = sanitized.replaceAll(
      RegExp(r'Bearer\s+[A-Za-z0-9_-]+'),
      'Bearer [REDACTED]',
    );

    return sanitized;
  }
}
