import 'package:flutter/material.dart';

class PinKeyboard extends StatelessWidget {
  final ValueChanged<int> onDigitPressed;
  final VoidCallback onBackspacePressed;
  final VoidCallback? onBiometricPressed;

  const PinKeyboard({
    super.key,
    required this.onDigitPressed,
    required this.onBackspacePressed,
    this.onBiometricPressed,
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
      children: digits.map((digit) => _DigitButton(
        digit: digit,
        onPressed: () => onDigitPressed(digit),
      )).toList(),
    );
  }

  Widget _buildBottomRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (onBiometricPressed != null)
          _ActionButton(
            icon: Icons.fingerprint,
            onPressed: onBiometricPressed!,
          )
        else
          const SizedBox(width: 72, height: 72),
        _DigitButton(
          digit: 0,
          onPressed: () => onDigitPressed(0),
        ),
        _ActionButton(
          icon: Icons.backspace_outlined,
          onPressed: onBackspacePressed,
        ),
      ],
    );
  }
}

class _DigitButton extends StatelessWidget {
  final int digit;
  final VoidCallback onPressed;

  const _DigitButton({required this.digit, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 72,
      height: 72,
      child: Material(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(100),
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Center(
            child: Text(
              '$digit',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _ActionButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 72,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 28),
      ),
    );
  }
}
