import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipr_s3/core/localization/localization_x.dart';
import 'package:ipr_s3/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:ipr_s3/features/settings/presentation/bloc/settings_event.dart';

Future<void> showChangePinDialog(BuildContext context) {
  final l = context.locale;
  final oldPinController = TextEditingController();
  final newPinController = TextEditingController();

  return showDialog(
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
