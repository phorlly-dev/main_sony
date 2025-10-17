import 'package:flutter/material.dart';

class ThemeManager with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(BuildContext context) {
    switch (_themeMode) {
      case ThemeMode.system:
        _themeMode = Theme.of(context).brightness == Brightness.dark
            ? ThemeMode.light
            : ThemeMode.dark;
        break;
      case ThemeMode.light:
        _themeMode = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        _themeMode = ThemeMode.system;
        break;
    }
    notifyListeners();
  }
}
