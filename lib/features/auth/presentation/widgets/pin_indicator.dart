import 'package:flutter/material.dart';

class PinIndicator extends StatelessWidget {
  final int length;
  final int filledCount;

  const PinIndicator({
    super.key,
    required this.length,
    required this.filledCount,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final outline = Theme.of(context).colorScheme.outlineVariant;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (index) {
        final isFilled = index < filledCount;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 12),
          width: isFilled ? 20 : 16,
          height: isFilled ? 20 : 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled ? primary : Colors.transparent,
            border: Border.all(
              color: isFilled ? primary : outline,
              width: 2,
            ),
          ),
        );
      }),
    );
  }
}
