import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipr_s3/core/di/injection.dart';
import 'package:ipr_s3/core/localization/localization_x.dart';
import 'package:ipr_s3/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ipr_s3/features/auth/presentation/bloc/auth_event.dart';
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
    final l = context.locale;

    return Scaffold(
      appBar: AppBar(title: Text(l.settings)),
      body: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is SettingsLoaded && state.message.isNotEmpty) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  behavior: SnackBarBehavior.floating,
                ),
              );
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
                  SectionHeader(title: l.device, theme: theme),
                  const SizedBox(height: 8),
                  DeviceInfoCard(
                    batteryLevel: batteryLevel,
                    freeStorage: freeStorage,
                    totalStorage: totalStorage,
                    theme: theme,
                  ),
                  const SizedBox(height: 24),
                  SectionHeader(title: l.security, theme: theme),
                  const SizedBox(height: 8),
                  SecurityCard(
                    hasPin: hasPin,
                    theme: theme,
                    onChangePin: () => _showChangePinDialog(context),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _confirmLogout(context),
                      icon: const Icon(Icons.logout),
                      label: Text(l.logOut),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.colorScheme.error,
                        side: BorderSide(color: theme.colorScheme.error),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            SettingsError(:final message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 12),
                  Text(message),
                  const SizedBox(height: 16),
                  FilledButton.tonal(
                    onPressed:
                        () => context.read<SettingsBloc>().add(
                          SettingsLoadRequested(),
                        ),
                    child: Text(l.retry),
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

  void _confirmLogout(BuildContext context) {
    final l = context.locale;
    showDialog(
      context: context,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        return AlertDialog(
          title: Text(l.logOutTitle),
          content: Text(l.logOutConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l.cancel),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<AuthBloc>().add(SignOutRequested());
              },
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
              ),
              child: Text(l.logOut),
            ),
          ],
        );
      },
    );
  }

  void _showChangePinDialog(BuildContext context) {
    final l = context.locale;
    final oldPinController = TextEditingController();
    final newPinController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l.changePin),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: InputDecoration(
                  labelText: l.currentPin,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newPinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: InputDecoration(
                  labelText: l.newPin,
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l.cancel),
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
              child: Text(l.save),
            ),
          ],
        );
      },
    );
  }
}
