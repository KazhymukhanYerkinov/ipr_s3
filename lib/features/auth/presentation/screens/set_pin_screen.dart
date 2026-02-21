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
class SetPinScreen extends StatefulWidget {
  const SetPinScreen({super.key});

  @override
  State<SetPinScreen> createState() => _SetPinScreenState();
}

class _SetPinScreenState extends State<SetPinScreen>
    with SingleTickerProviderStateMixin {
  static const _pinLength = 4;

  String _enteredPin = '';
  String? _firstPin;
  bool _isConfirmStep = false;

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
      _handlePinComplete();
    }
  }

  void _handlePinComplete() {
    if (!_isConfirmStep) {
      setState(() {
        _firstPin = _enteredPin;
        _enteredPin = '';
        _isConfirmStep = true;
      });
    } else {
      if (_enteredPin == _firstPin) {
        context.read<AuthBloc>().add(PinSetupSubmitted(_enteredPin));
      } else {
        _onMismatch();
      }
    }
  }

  void _onMismatch() {
    HapticFeedback.heavyImpact();
    _shakeController.forward(from: 0);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(context.locale.pinMismatch),
        behavior: SnackBarBehavior.floating,
      ));
    setState(() {
      _enteredPin = '';
      _firstPin = null;
      _isConfirmStep = false;
    });
  }

  void _onBackspacePressed() {
    if (_enteredPin.isEmpty) return;

    HapticFeedback.lightImpact();
    setState(() {
      _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text(state.message),
              behavior: SnackBarBehavior.floating,
            ));
          setState(() {
            _enteredPin = '';
            _firstPin = null;
            _isConfirmStep = false;
          });
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),
              Icon(
                _isConfirmStep
                    ? Icons.lock_reset_rounded
                    : Icons.lock_open_rounded,
                size: 48,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                _isConfirmStep
                    ? context.locale.confirmPin
                    : context.locale.setupPin,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isConfirmStep
                    ? context.locale.enterPinAgain
                    : context.locale.createFourDigitCode,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
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
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
