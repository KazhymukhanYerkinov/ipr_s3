import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipr_s3/core/di/injection.dart';
import 'package:ipr_s3/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:ipr_s3/features/settings/presentation/bloc/settings_event.dart';
import 'package:ipr_s3/features/settings/presentation/bloc/settings_state.dart';
import 'package:ipr_s3/features/settings/presentation/widgets/device_info_card.dart';
import 'package:ipr_s3/features/settings/presentation/widgets/section_header.dart';
import 'package:ipr_s3/features/settings/presentation/widgets/security_card.dart';

@RoutePage()
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SettingsBloc>()..add(SettingsLoadRequested()),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is SettingsLoaded && state.message.isNotEmpty) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text(state.message),
                behavior: SnackBarBehavior.floating,
              ));
          }
        },
        builder: (context, state) {
          return switch (state) {
            SettingsLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            SettingsLoaded(
              :final batteryLevel,
              :final freeStorage,
              :final totalStorage,
              :final hasPin,
            ) =>
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  SectionHeader(title: 'Device', theme: theme),
                  const SizedBox(height: 8),
                  DeviceInfoCard(
                    batteryLevel: batteryLevel,
                    freeStorage: freeStorage,
                    totalStorage: totalStorage,
                    theme: theme,
                  ),
                  const SizedBox(height: 24),
                  SectionHeader(title: 'Security', theme: theme),
                  const SizedBox(height: 8),
                  SecurityCard(
                    hasPin: hasPin,
                    theme: theme,
                    onChangePin: () => _showChangePinDialog(context),
                  ),
                ],
              ),
            SettingsError(:final message) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48,
                        color: theme.colorScheme.error),
                    const SizedBox(height: 12),
                    Text(message),
                    const SizedBox(height: 16),
                    FilledButton.tonal(
                      onPressed: () => context
                          .read<SettingsBloc>()
                          .add(SettingsLoadRequested()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }

  void _showChangePinDialog(BuildContext context) {
    final oldPinController = TextEditingController();
    final newPinController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Change PIN'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: const InputDecoration(
                  labelText: 'Current PIN',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newPinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: const InputDecoration(
                  labelText: 'New PIN',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final oldPin = oldPinController.text.trim();
                final newPin = newPinController.text.trim();
                if (oldPin.length == 4 && newPin.length == 4) {
                  context.read<SettingsBloc>().add(
                        PinChangeRequested(oldPin: oldPin, newPin: newPin),
                      );
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    ).then((_) {
      oldPinController.dispose();
      newPinController.dispose();
    });
  }
}
