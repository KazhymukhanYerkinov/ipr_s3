sealed class SettingsEvent {}

final class SettingsLoadRequested extends SettingsEvent {}

final class PinChangeRequested extends SettingsEvent {
  final String oldPin;
  final String newPin;
  PinChangeRequested({required this.oldPin, required this.newPin});
}

final class PinDeleteRequested extends SettingsEvent {}
