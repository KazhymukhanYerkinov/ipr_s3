import 'package:flutter/material.dart';
import 'package:ipr_s3/features/auth/presentation/widgets/action_button.dart';
import 'package:ipr_s3/features/auth/presentation/widgets/digit_button.dart';

class PinKeyboard extends StatelessWidget {
  final ValueChanged<int> onDigitPressed;
  final VoidCallback onBackspacePressed;
  final VoidCallback? onBiometricPressed;
  final IconData biometricIcon;

  const PinKeyboard({
    super.key,
    required this.onDigitPressed,
    required this.onBackspacePressed,
    this.onBiometricPressed,
    this.biometricIcon = Icons.fingerprint,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        children: [
          _buildRow([1, 2, 3]),
          const SizedBox(height: 16),
          _buildRow([4, 5, 6]),
          const SizedBox(height: 16),
          _buildRow([7, 8, 9]),
          const SizedBox(height: 16),
          _buildBottomRow(context),
        ],
      ),
    );
  }

  Widget _buildRow(List<int> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
          digits
              .map(
                (digit) => DigitButton(
                  digit: digit,
                  onPressed: () => onDigitPressed(digit),
                ),
              )
              .toList(),
    );
  }

  Widget _buildBottomRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (onBiometricPressed != null)
          ActionButton(icon: biometricIcon, onPressed: onBiometricPressed!)
        else
          const SizedBox(width: 72, height: 72),
        DigitButton(digit: 0, onPressed: () => onDigitPressed(0)),
        ActionButton(
          icon: Icons.backspace_outlined,
          onPressed: onBackspacePressed,
        ),
      ],
    );
  }
}
