import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/platform/device_info_channel.dart';
import 'package:ipr_s3/core/security/pin_manager.dart';
import 'package:ipr_s3/features/settings/presentation/bloc/settings_event.dart';
import 'package:ipr_s3/features/settings/presentation/bloc/settings_state.dart';

@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final DeviceInfoChannel _deviceInfo;
  final PinManager _pinManager;

  SettingsBloc(this._deviceInfo, this._pinManager)
    : super(const SettingsState.initial()) {
    on<SettingsLoadRequested>(_onLoad);
    on<PinChangeRequested>(_onPinChange);
    on<PinDeleteRequested>(_onPinDelete);
  }

  Future<void> _onLoad(
    SettingsLoadRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsState.loading());

    final results = await Future.wait([
      _deviceInfo.getBatteryLevel(),
      _deviceInfo.getFreeStorage(),
      _deviceInfo.getTotalStorage(),
      _pinManager.hasPin(),
    ]);

    emit(
      SettingsState.loaded(
        batteryLevel: results[0] as int?,
        freeStorage: results[1] as int?,
        totalStorage: results[2] as int?,
        hasPin: results[3] as bool,
      ),
    );
  }

  Future<void> _onPinChange(
    PinChangeRequested event,
    Emitter<SettingsState> emit,
  ) async {
    final verified = await _pinManager.verifyPin(event.oldPin);
    if (!verified) {
      final currentState = state;
      if (currentState is SettingsLoaded) {
        emit(currentState.copyWith(message: 'Incorrect current PIN'));
      }
      return;
    }

    await _pinManager.setPin(event.newPin);
    final currentState = state;
    if (currentState is SettingsLoaded) {
      emit(currentState.copyWith(message: 'PIN changed successfully'));
    }
  }

  Future<void> _onPinDelete(
    PinDeleteRequested event,
    Emitter<SettingsState> emit,
  ) async {
    await _pinManager.deletePin();
    add(SettingsLoadRequested());
  }
}
