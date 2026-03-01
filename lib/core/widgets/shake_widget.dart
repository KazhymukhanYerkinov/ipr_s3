import 'package:flutter/material.dart';

class ShakeWidget extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const ShakeWidget({super.key, required this.animation, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(animation.value, 0),
          child: child,
        );
      },
      child: child,
    );
  }
}

mixin ShakeAnimationMixin<T extends StatefulWidget>
    on SingleTickerProviderStateMixin<T> {
  late final AnimationController shakeController;
  late final Animation<double> shakeAnimation;

  void initShakeAnimation() {
    shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10, end: 10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10, end: -10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -10, end: 10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10, end: 0), weight: 1),
    ]).animate(shakeController);
  }

  void disposeShakeAnimation() => shakeController.dispose();

  void triggerShake() => shakeController.forward(from: 0);
}
