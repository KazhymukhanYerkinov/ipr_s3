import 'package:flutter/material.dart';

import 'generated/l10n.dart';

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
    final instance = Localizations.of<GeneratedLocalization>(
      context,
      GeneratedLocalization,
    );
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

  List<Locale> get supportedLocales => const [Locale('en')];

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
