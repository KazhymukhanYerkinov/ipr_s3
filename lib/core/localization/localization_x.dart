import 'package:flutter/widgets.dart';

import 'localization.dart';

/// Convenient extension to access localized strings via [context.locale].
///
/// Usage:
/// ```dart
/// Text(context.locale.appTitle)
/// ```
extension LocalizationX on BuildContext {
  Localization get locale => Localization.of(this);
}
