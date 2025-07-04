import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final defaultColor = Colors.lightGreen.shade500;

class ThemeProvider with ChangeNotifier {
  Color _color = defaultColor;

  Color get themeColor => _color;

  void setThemeColor(Color color) {
    _color = color;
    notifyListeners();
  }

  Color getColor(int? value) {
    return value == null ? _color : Color(value);
  }

  Color _hintColor = Colors.deepOrange.shade700;

  Color get hintColor => _hintColor;

  void setHintColor(Color color) {
    _hintColor = color;
    notifyListeners();
  }

  Map<String, Color> getColorOptions(BuildContext context) {
    return {
      AppLocalizations.of(context)!.colorOption_default: defaultColor,
      AppLocalizations.of(context)!.colorOption_lime: Colors.lime.shade500,
      AppLocalizations.of(context)!.colorOption_teal: Colors.teal.shade500,
      AppLocalizations.of(context)!.colorOption_blueGrey:
          Colors.blueGrey.shade500,
      AppLocalizations.of(context)!.colorOption_indigo: Colors.indigo.shade500,
      AppLocalizations.of(context)!.colorOption_brown: Colors.brown.shade500,
      AppLocalizations.of(context)!.colorOption_pink: Colors.pink.shade500,
      AppLocalizations.of(context)!.colorOption_red: Colors.red.shade500,
      AppLocalizations.of(context)!.colorOption_orange: Colors.orange.shade500,
      AppLocalizations.of(context)!.colorOption_yellow: Colors.yellow.shade500,
      AppLocalizations.of(context)!.colorOption_green: Colors.green.shade500,
      AppLocalizations.of(context)!.colorOption_cyan: Colors.cyan.shade500,
      AppLocalizations.of(context)!.colorOption_blue: Colors.blue.shade500,
      AppLocalizations.of(context)!.colorOption_purple: Colors.purple.shade500,
    };
  }

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  bool isDarkMode(BuildContext context) {
    if (_themeMode == ThemeMode.light) return false;
    if (_themeMode == ThemeMode.dark) return true;
    return Theme.of(context).brightness == Brightness.dark;
  }
}
