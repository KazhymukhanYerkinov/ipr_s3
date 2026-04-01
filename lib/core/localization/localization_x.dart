import 'package:flutter/widgets.dart';

import 'localization.dart';

extension LocalizationX on BuildContext {
  Localization get locale => Localization.of(this);
}
