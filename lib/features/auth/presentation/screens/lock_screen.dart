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
class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen>
    with SingleTickerProviderStateMixin, ShakeAnimationMixin {
  static const _pinLength = 4;

  String _enteredPin = '';

  @override
  void initState() {
    super.initState();
    initShakeAnimation();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(BiometricRequested());
    });
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
    triggerShake();
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
          context.showFloatingSnackBar(state.message);
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
                onBiometricPressed: _onBiometricPressed,
              ),
              const SizedBox(height: 24),
              TextButton.icon(
                onPressed:
                    () => context.read<AuthBloc>().add(SignOutRequested()),
                icon: Icon(
                  Icons.logout,
                  size: 18,
                  color: theme.colorScheme.error,
                ),
                label: Text(
                  context.locale.logOut,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
