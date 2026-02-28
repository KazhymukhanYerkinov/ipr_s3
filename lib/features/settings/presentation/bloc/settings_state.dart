import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_state.freezed.dart';

@freezed
sealed class SettingsState with _$SettingsState {
  const factory SettingsState.initial() = SettingsInitial;
  const factory SettingsState.loading() = SettingsLoading;
  const factory SettingsState.loaded({
    int? batteryLevel,
    int? freeStorage,
    int? totalStorage,
    required bool hasPin,
    @Default('') String message,
  }) = SettingsLoaded;
  const factory SettingsState.error({required String message}) = SettingsError;
}
