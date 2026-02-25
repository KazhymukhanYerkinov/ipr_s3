import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipr_s3/core/di/injection.dart';
import 'package:ipr_s3/features/settings/presentation/bloc/settings_bloc.dart';

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
                  _SectionHeader(title: 'Device', theme: theme),
                  const SizedBox(height: 8),
                  _DeviceInfoCard(
                    batteryLevel: batteryLevel,
                    freeStorage: freeStorage,
                    totalStorage: totalStorage,
                    theme: theme,
                  ),
                  const SizedBox(height: 24),
                  _SectionHeader(title: 'Security', theme: theme),
                  const SizedBox(height: 8),
                  _SecurityCard(
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

class _SectionHeader extends StatelessWidget {
  final String title;
  final ThemeData theme;

  const _SectionHeader({required this.title, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: theme.textTheme.titleSmall?.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _DeviceInfoCard extends StatelessWidget {
  final int? batteryLevel;
  final int? freeStorage;
  final int? totalStorage;
  final ThemeData theme;

  const _DeviceInfoCard({
    required this.batteryLevel,
    required this.freeStorage,
    required this.totalStorage,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final usedStorage = (totalStorage != null && freeStorage != null)
        ? totalStorage! - freeStorage!
        : null;
    final usagePercent = (totalStorage != null && usedStorage != null && totalStorage! > 0)
        ? usedStorage / totalStorage!
        : null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _BatteryRow(level: batteryLevel, theme: theme),
            const Divider(height: 24),
            _StorageSection(
              freeStorage: freeStorage,
              totalStorage: totalStorage,
              usagePercent: usagePercent,
              theme: theme,
            ),
          ],
        ),
      ),
    );
  }
}

class _BatteryRow extends StatelessWidget {
  final int? level;
  final ThemeData theme;

  const _BatteryRow({required this.level, required this.theme});

  @override
  Widget build(BuildContext context) {
    final displayLevel = level != null ? '$level%' : 'N/A';

    IconData icon;
    Color color;
    if (level == null) {
      icon = Icons.battery_unknown_rounded;
      color = theme.colorScheme.onSurfaceVariant;
    } else if (level! <= 15) {
      icon = Icons.battery_alert_rounded;
      color = theme.colorScheme.error;
    } else if (level! <= 50) {
      icon = Icons.battery_3_bar_rounded;
      color = Colors.orange;
    } else {
      icon = Icons.battery_full_rounded;
      color = Colors.green;
    }

    return Row(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Text('Battery', style: theme.textTheme.bodyLarge),
        ),
        Text(
          displayLevel,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _StorageSection extends StatelessWidget {
  final int? freeStorage;
  final int? totalStorage;
  final double? usagePercent;
  final ThemeData theme;

  const _StorageSection({
    required this.freeStorage,
    required this.totalStorage,
    required this.usagePercent,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.storage_rounded, size: 28,
                color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text('Storage', style: theme.textTheme.bodyLarge),
            ),
            if (usagePercent != null)
              Text(
                '${(usagePercent! * 100).toStringAsFixed(0)}% used',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: usagePercent ?? 0,
            minHeight: 8,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation(
              usagePercent != null && usagePercent! > 0.9
                  ? theme.colorScheme.error
                  : theme.colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          freeStorage != null && totalStorage != null
              ? '${_formatSize(freeStorage!)} free of ${_formatSize(totalStorage!)}'
              : 'Storage info unavailable',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}

class _SecurityCard extends StatelessWidget {
  final bool hasPin;
  final ThemeData theme;
  final VoidCallback onChangePin;

  const _SecurityCard({
    required this.hasPin,
    required this.theme,
    required this.onChangePin,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.lock_outline_rounded,
                color: theme.colorScheme.primary),
            title: const Text('Change PIN'),
            subtitle: Text(hasPin ? 'PIN is set' : 'No PIN set'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: hasPin ? onChangePin : null,
          ),
        ],
      ),
    );
  }
}
