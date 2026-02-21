import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipr_s3/core/security/secure_logger.dart';

class SecureBlocObserver extends BlocObserver {
  final _logger = SecureLogger();

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    _logger.debug('${bloc.runtimeType} | event: ${event.runtimeType}');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    _logger.debug(
      '${bloc.runtimeType} | '
      '${transition.currentState.runtimeType} → '
      '${transition.nextState.runtimeType}',
    );
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    _logger.error('${bloc.runtimeType} error', error, stackTrace);
  }
}
