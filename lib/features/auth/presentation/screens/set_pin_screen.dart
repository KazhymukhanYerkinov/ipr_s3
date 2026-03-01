import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipr_s3/core/extensions/snack_bar_x.dart';
import 'package:ipr_s3/core/localization/localization_x.dart';
import 'package:ipr_s3/core/widgets/shake_widget.dart';
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
    with SingleTickerProviderStateMixin, ShakeAnimationMixin {
  static const _pinLength = 4;

  String _enteredPin = '';
  String? _firstPin;
  bool _isConfirmStep = false;

  @override
  void initState() {
    super.initState();
    initShakeAnimation();
  }

  @override
  void dispose() {
    disposeShakeAnimation();
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
    triggerShake();
    context.showFloatingSnackBar(context.locale.pinMismatch);
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
          context.showFloatingSnackBar(state.message);
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
              ShakeWidget(
                animation: shakeAnimation,
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
