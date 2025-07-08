import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFFFF3B1D);
const kDarkBlackColor = Color(0xFF191919);
const kBgColor = Color(0xFFE7E7E7);
const kBodyTextColor = Color(0xFF666666);

const kDefaultPadding = 16.0;
const kMaxWidth = 1232.0;
const kDefaultDuration = Duration(milliseconds: 250);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.teal,
  colorScheme: ColorScheme.light(
    primary: Colors.teal,
    onPrimary: Colors.white,
    secondary: Colors.deepOrange,
    onSecondary: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black87,
    error: Colors.red,
    onError: Colors.white,
  ),
  // Define more if needed
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.teal[300],
  colorScheme: ColorScheme.dark(
    primary: Colors.teal[300]!,
    onPrimary: Colors.black,
    secondary: Colors.orange[300]!,
    onSecondary: Colors.black,
    surface: Color(0xFF222222),
    onSurface: Colors.white70,
    error: Colors.red[300]!,
    onError: Colors.black,
  ),
  // Define more if needed
);

final color = Colors.teal;
final custom = color.withValues(alpha: 0.7, red: 0.2, green: 0.7, blue: 0.4);

enum AppColorRole {
  primary,
  secondary,
  success,
  error,
  warning,
  info,
  surface,
  onPrimary,
  onSecondary,
  onSurface,
}

extension AppColorsExt on BuildContext {
  Color getAppColor(AppColorRole role) {
    final colorScheme = Theme.of(this).colorScheme;
    switch (role) {
      case AppColorRole.primary:
        return colorScheme.primary;
      case AppColorRole.secondary:
        return colorScheme.secondary;
      case AppColorRole.success:
        return Colors.green;
      case AppColorRole.error:
        return colorScheme.error;
      case AppColorRole.warning:
        return Colors.orange;
      case AppColorRole.info:
        return Colors.blueAccent;
      case AppColorRole.surface:
        return colorScheme.surface;
      case AppColorRole.onPrimary:
        return colorScheme.onPrimary;
      case AppColorRole.onSecondary:
        return colorScheme.onSecondary;
      case AppColorRole.onSurface:
        return colorScheme.onSurface;
    }
  }
}

const appColors = {
  AppColorRole.primary: Color(0xFF4DB6AC),
  AppColorRole.secondary: Color(0xFF43CEA2),
  AppColorRole.success: Color(0xFF43A047),
  AppColorRole.error: Color(0xFFE53935),
  AppColorRole.warning: Color(0xFFFFA726),
  AppColorRole.info: Color(0xFF29B6F6),
  AppColorRole.surface: Color(0xFFF5F5F5),
  AppColorRole.onPrimary: Color(0xFFFFFFFF),
  AppColorRole.onSecondary: Color(0xFFFFFFFF),
  AppColorRole.onSurface: Color(0xFF000000),
};

extension AppColorsCustom on AppColorRole {
  Color get color => appColors[this]!;
}
