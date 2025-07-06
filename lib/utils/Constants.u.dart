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
