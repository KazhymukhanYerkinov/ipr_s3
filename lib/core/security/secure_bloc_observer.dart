import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipr_s3/core/security/secure_logger.dart';

/// Безопасный наблюдатель за всеми BLoC'ами в приложении.
///
/// Зачем нужен:
/// BlocObserver перехватывает ВСЕ события и смены состояний во ВСЕХ BLoC'ах.
/// Стандартный observer может вывести в лог полное содержимое state,
/// например: "AuthAuthenticated(user: UserEntity(email: user@mail.com))"
/// — это утечка персональных данных через logcat.
///
/// Что делает SecureBlocObserver:
/// - Логирует только ТИПЫ событий и состояний (runtimeType),
///   а не их содержимое
/// - Пример вывода: "AuthBloc | AuthInitial → AuthAuthenticated"
///   вместо полного объекта с email/uid/именем
/// - Ошибки логирует через SecureLogger, который маскирует чувствительные данные
class SecureBlocObserver extends BlocObserver {
  final _logger = SecureLogger();

  /// Вызывается при каждом event в любом BLoC.
  /// Логируем только имя BLoC и тип события, НЕ содержимое.
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    _logger.debug('${bloc.runtimeType} | event: ${event.runtimeType}');
  }

  /// Вызывается при каждой смене состояния в любом BLoC.
  /// Логируем: "AuthBloc | AuthInitial → AuthAuthenticated"
  /// НЕ логируем: полный объект state с данными пользователя.
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    _logger.debug(
      '${bloc.runtimeType} | '
      '${transition.currentState.runtimeType} → '
      '${transition.nextState.runtimeType}',
    );
  }

  /// Вызывается при ошибке в любом BLoC.
  /// Ошибка проходит через SecureLogger._sanitize(),
  /// который замаскирует токены/email, если они попали в сообщение.
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    _logger.error('${bloc.runtimeType} error', error, stackTrace);
  }
}
