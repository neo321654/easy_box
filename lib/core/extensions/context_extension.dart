import 'package:flutter/widgets.dart';
import '../../generated/app_localizations.dart';

extension BuildContextHelper on BuildContext {
  AppLocalizations get S => AppLocalizations.of(this)!;
}
