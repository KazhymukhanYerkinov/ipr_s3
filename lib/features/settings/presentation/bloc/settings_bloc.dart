import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/platform/device_info_behavior.dart';
import 'package:ipr_s3/features/auth/domain/use_cases/delete_pin_use_case.dart';
import 'package:ipr_s3/features/auth/domain/use_cases/has_pin_use_case.dart';
import 'package:ipr_s3/features/auth/domain/use_cases/set_pin_use_case.dart';
import 'package:ipr_s3/features/auth/domain/use_cases/verify_pin_use_case.dart';
import 'package:ipr_s3/features/settings/presentation/bloc/settings_event.dart';
import 'package:ipr_s3/features/settings/presentation/bloc/settings_state.dart';

@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final DeviceInfoBehavior _deviceInfo;
  final HasPinUseCase _hasPin;
  final VerifyPinUseCase _verifyPin;
  final SetPinUseCase _setPin;
  final DeletePinUseCase _deletePin;

  SettingsBloc(
    this._deviceInfo,
    this._hasPin,
    this._verifyPin,
    this._setPin,
    this._deletePin,
  ) : super(const SettingsState.initial()) {
    _setupHandlers();
  }

  void _setupHandlers() {
    on<SettingsLoadRequested>(_onLoad);
    on<PinChangeRequested>(_onPinChange);
    on<PinDeleteRequested>(_onPinDelete);
  }

  Future<void> _onLoad(
    SettingsLoadRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsState.loading());

    final deviceResults = await Future.wait([
      _deviceInfo.getBatteryLevel(),
      _deviceInfo.getFreeStorage(),
      _deviceInfo.getTotalStorage(),
    ]);
    final hasPinResult = await _hasPin();

    emit(
      SettingsState.loaded(
        batteryLevel: deviceResults[0],
        freeStorage: deviceResults[1],
        totalStorage: deviceResults[2],
        hasPin: hasPinResult.value ?? false,
      ),
    );
  }

  Future<void> _onPinChange(
    PinChangeRequested event,
    Emitter<SettingsState> emit,
  ) async {
    final verifyResult = await _verifyPin(event.oldPin);
    if (verifyResult.isError || verifyResult.value != true) {
      final currentState = state;
      if (currentState is SettingsLoaded) {
        emit(currentState.copyWith(message: 'Incorrect current PIN'));
      }
      return;
    }

    await _setPin(event.newPin);
    final currentState = state;
    if (currentState is SettingsLoaded) {
      emit(currentState.copyWith(message: 'PIN changed successfully'));
    }
  }

  Future<void> _onPinDelete(
    PinDeleteRequested event,
    Emitter<SettingsState> emit,
  ) async {
    await _deletePin();
    add(SettingsLoadRequested());
  }
}
