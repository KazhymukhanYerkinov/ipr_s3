import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/platform/device_info_behavior.dart';
import 'package:ipr_s3/features/settings/presentation/bloc/settings_event.dart';
import 'package:ipr_s3/features/settings/presentation/bloc/settings_state.dart';

@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final DeviceInfoBehavior _deviceInfo;

  SettingsBloc(this._deviceInfo) : super(const SettingsState.initial()) {
    on<SettingsLoadRequested>(_onLoad);
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

    emit(
      SettingsState.loaded(
        batteryLevel: deviceResults[0],
        freeStorage: deviceResults[1],
        totalStorage: deviceResults[2],
      ),
    );
  }
}
