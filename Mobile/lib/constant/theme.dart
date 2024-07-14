import 'package:flutter/material.dart';

// // Theme
// ThemeMode themeMode = ThemeMode.light;
// String mode = "";

class ThemeColor {
  static Color primarylightColor = const Color(0xff325B90);
  static Color primarylightbg = const Color(0xffF0F4FC);
}

// Theme Data For App
ThemeData light = ThemeData(
    appBarTheme:
        const AppBarTheme(elevation: 0, backgroundColor: Colors.transparent),
    textTheme: TextTheme(
        headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: ThemeColor.primarylightColor),
        bodyMedium: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: ThemeColor.primarylightColor),
        titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: ThemeColor.primarylightColor.withOpacity(.7)),
        titleSmall: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: ThemeColor.primarylightColor),
        displaySmall: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: ThemeColor.primarylightColor),
        headlineSmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: ThemeColor.primarylightColor),
        labelLarge: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
    highlightColor: Colors.transparent,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: ThemeColor.primarylightbg,
    iconTheme: IconThemeData(color: ThemeColor.primarylightColor),
    primaryColor: ThemeColor.primarylightColor,
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            iconColor: const MaterialStatePropertyAll(Colors.white),
            backgroundColor:
                MaterialStatePropertyAll(ThemeColor.primarylightColor))),
    colorScheme: ColorScheme.light(
      brightness: Brightness.dark,
      primary: ThemeColor.primarylightColor,
      secondary: Colors.black,
    ));

// ThemeData dark = ThemeData(
//     appBarTheme:
//         const AppBarTheme(elevation: 0, backgroundColor: Colors.transparent),
//     scaffoldBackgroundColor: ThemeColor.primarydarktbg,
//     primaryColor: Colors.white,
//     iconTheme: const IconThemeData(
//       color: Colors.white,
//     ),
//     colorScheme: ColorScheme.light(
//       primary: ThemeColor.primarydarkColor,
//       secondary: Colors.white,
//     ));
