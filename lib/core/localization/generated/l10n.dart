// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class GeneratedLocalization {
  GeneratedLocalization();

  static GeneratedLocalization? _current;

  static GeneratedLocalization get current {
    assert(_current != null,
        'No instance of GeneratedLocalization was loaded. Try to initialize the GeneratedLocalization delegate before accessing GeneratedLocalization.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<GeneratedLocalization> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = GeneratedLocalization();
      GeneratedLocalization._current = instance;

      return instance;
    });
  }

  static GeneratedLocalization of(BuildContext context) {
    final instance = GeneratedLocalization.maybeOf(context);
    assert(instance != null,
        'No instance of GeneratedLocalization present in the widget tree. Did you add GeneratedLocalization.delegate in localizationsDelegates?');
    return instance!;
  }

  static GeneratedLocalization? maybeOf(BuildContext context) {
    return Localizations.of<GeneratedLocalization>(
        context, GeneratedLocalization);
  }

  /// `Secure App`
  String get appTitle {
    return Intl.message(
      'Secure App',
      name: 'appTitle',
      desc: 'Application title',
      args: [],
    );
  }

  /// `Protected with OWASP standards`
  String get signInSubtitle {
    return Intl.message(
      'Protected with OWASP standards',
      name: 'signInSubtitle',
      desc: 'Subtitle on the sign-in screen',
      args: [],
    );
  }

  /// `Sign in with Google`
  String get signInWithGoogle {
    return Intl.message(
      'Sign in with Google',
      name: 'signInWithGoogle',
      desc: 'Google sign-in button label',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: 'Home screen app bar title',
      args: [],
    );
  }

  /// `Security Features`
  String get securityFeatures {
    return Intl.message(
      'Security Features',
      name: 'securityFeatures',
      desc: 'Security features card title',
      args: [],
    );
  }

  /// `✓ Token in Secure Storage (Keychain/EncryptedSP)`
  String get securityTokenStorage {
    return Intl.message(
      '✓ Token in Secure Storage (Keychain/EncryptedSP)',
      name: 'securityTokenStorage',
      desc: 'Security feature: token storage',
      args: [],
    );
  }

  /// `✓ HTTPS only (Firebase SDK)`
  String get securityHttpsOnly {
    return Intl.message(
      '✓ HTTPS only (Firebase SDK)',
      name: 'securityHttpsOnly',
      desc: 'Security feature: HTTPS',
      args: [],
    );
  }

  /// `✓ OAuth 2.0 via Google Sign-In`
  String get securityOAuth {
    return Intl.message(
      '✓ OAuth 2.0 via Google Sign-In',
      name: 'securityOAuth',
      desc: 'Security feature: OAuth',
      args: [],
    );
  }

  /// `✓ Sensitive data masked in logs`
  String get securityMaskedLogs {
    return Intl.message(
      '✓ Sensitive data masked in logs',
      name: 'securityMaskedLogs',
      desc: 'Security feature: masked logs',
      args: [],
    );
  }

  /// `✓ Local data encrypted (Hive + AES-256)`
  String get securityEncryptedData {
    return Intl.message(
      '✓ Local data encrypted (Hive + AES-256)',
      name: 'securityEncryptedData',
      desc: 'Security feature: encrypted data',
      args: [],
    );
  }

  /// `Enter PIN`
  String get enterPin {
    return Intl.message(
      'Enter PIN',
      name: 'enterPin',
      desc: 'Lock screen title',
      args: [],
    );
  }

  /// `Set up PIN`
  String get setupPin {
    return Intl.message(
      'Set up PIN',
      name: 'setupPin',
      desc: 'Set PIN screen title — first step',
      args: [],
    );
  }

  /// `Confirm PIN`
  String get confirmPin {
    return Intl.message(
      'Confirm PIN',
      name: 'confirmPin',
      desc: 'Set PIN screen title — confirmation step',
      args: [],
    );
  }

  /// `Enter PIN again`
  String get enterPinAgain {
    return Intl.message(
      'Enter PIN again',
      name: 'enterPinAgain',
      desc: 'Set PIN screen subtitle — confirmation step',
      args: [],
    );
  }

  /// `Create a 4-digit code`
  String get createFourDigitCode {
    return Intl.message(
      'Create a 4-digit code',
      name: 'createFourDigitCode',
      desc: 'Set PIN screen subtitle — first step',
      args: [],
    );
  }

  /// `Wrong PIN`
  String get wrongPin {
    return Intl.message(
      'Wrong PIN',
      name: 'wrongPin',
      desc: 'Error message when PIN is incorrect',
      args: [],
    );
  }

  /// `PINs don't match. Try again`
  String get pinMismatch {
    return Intl.message(
      'PINs don\'t match. Try again',
      name: 'pinMismatch',
      desc: 'Error when confirmation PIN doesn\'t match',
      args: [],
    );
  }

  /// `Confirm to unlock File Secure`
  String get biometricReason {
    return Intl.message(
      'Confirm to unlock File Secure',
      name: 'biometricReason',
      desc: 'Reason string shown during biometric prompt',
      args: [],
    );
  }
}

class AppLocalizationDelegate
    extends LocalizationsDelegate<GeneratedLocalization> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<GeneratedLocalization> load(Locale locale) =>
      GeneratedLocalization.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
