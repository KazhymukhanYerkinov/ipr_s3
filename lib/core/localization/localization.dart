import 'package:flutter/material.dart';

import 'generated/l10n.dart';

/// Wrapper around [GeneratedLocalization] that provides a clean API
/// and a custom [LocalizationsDelegate].
///
/// To add a new language in the future:
/// 1. Create `lib/core/localization/l10n/intl_<lang>.arb`
/// 2. Run `dart run intl_utils:generate`
/// 3. Add the new [Locale] to [LocalizationDelegate.supportedLocales]
class Localization extends GeneratedLocalization {
  static Localization? _current;

  static Localization get current {
    assert(
      _current != null,
      'Localization was not initialized. '
      'Make sure LocalizationDelegate is added to localizationsDelegates.',
    );
    return _current!;
  }

  static Localization of(BuildContext context) {
    final instance =
        Localizations.of<GeneratedLocalization>(context, GeneratedLocalization);
    assert(
      instance != null,
      'No Localization found in context. '
      'Did you add LocalizationDelegate to localizationsDelegates?',
    );
    return instance! as Localization;
  }

  static const LocalizationDelegate delegate = LocalizationDelegate();
}

class LocalizationDelegate
    extends LocalizationsDelegate<GeneratedLocalization> {
  const LocalizationDelegate();

  /// Supported locales for the app.
  ///
  /// When adding a new language, add the corresponding [Locale] here.
  List<Locale> get supportedLocales => const [
        Locale('en'),
      ];

  @override
  bool isSupported(Locale locale) {
    return supportedLocales.any(
      (supported) => supported.languageCode == locale.languageCode,
    );
  }

  @override
  Future<GeneratedLocalization> load(Locale locale) async {
    await GeneratedLocalization.load(locale);
    Localization._current = Localization();
    return Localization._current!;
  }

  @override
  bool shouldReload(LocalizationDelegate old) => false;
}
