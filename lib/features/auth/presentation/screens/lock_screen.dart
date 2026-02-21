import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipr_s3/core/localization/localization_x.dart';
import 'package:ipr_s3/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ipr_s3/features/auth/presentation/bloc/auth_event.dart';
import 'package:ipr_s3/features/auth/presentation/bloc/auth_state.dart';
import 'package:ipr_s3/features/auth/presentation/widgets/pin_indicator.dart';
import 'package:ipr_s3/features/auth/presentation/widgets/pin_keyboard.dart';

@RoutePage()
class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen>
    with SingleTickerProviderStateMixin {
  static const _pinLength = 4;

  String _enteredPin = '';
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10, end: 10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10, end: -10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -10, end: 10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10, end: 0), weight: 1),
    ]).animate(_shakeController);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(BiometricRequested());
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _onDigitPressed(int digit) {
    if (_enteredPin.length >= _pinLength) return;

    HapticFeedback.lightImpact();
    setState(() {
      _enteredPin += digit.toString();
    });

    if (_enteredPin.length == _pinLength) {
      context.read<AuthBloc>().add(PinSubmitted(_enteredPin));
    }
  }

  void _onBackspacePressed() {
    if (_enteredPin.isEmpty) return;

    HapticFeedback.lightImpact();
    setState(() {
      _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
    });
  }

  void _onBiometricPressed() {
    context.read<AuthBloc>().add(BiometricRequested());
  }

  void _onError() {
    HapticFeedback.heavyImpact();
    _shakeController.forward(from: 0);
    setState(() {
      _enteredPin = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          _onError();
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text(state.message),
              behavior: SnackBarBehavior.floating,
            ));
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),
              Icon(
                Icons.lock_outline_rounded,
                size: 48,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                context.locale.enterPin,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 32),
              AnimatedBuilder(
                animation: _shakeAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_shakeAnimation.value, 0),
                    child: child,
                  );
                },
                child: PinIndicator(
                  length: _pinLength,
                  filledCount: _enteredPin.length,
                ),
              ),
              const Spacer(flex: 1),
              PinKeyboard(
                onDigitPressed: _onDigitPressed,
                onBackspacePressed: _onBackspacePressed,
                onBiometricPressed: _onBiometricPressed,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
