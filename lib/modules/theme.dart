//TODO:implement custom themedata for using in app like color of tile
import 'package:flutter/material.dart';

getDynamicLightTheme(ColorScheme lightScheme) {
  return ThemeData(
    colorScheme: lightScheme,
    scaffoldBackgroundColor: lightScheme.background,
    primaryColor: lightScheme.primary,
    bottomNavigationBarTheme:
        BottomNavigationBarThemeData(selectedItemColor: lightScheme.tertiary),
    cardColor: lightScheme.primary,
    listTileTheme: ListTileThemeData(tileColor: lightScheme.surface),
  );
}

getDynamicDarkTheme(ColorScheme darkScheme) {
  return ThemeData(
    colorScheme: darkScheme,
    scaffoldBackgroundColor: darkScheme.background,
    primaryColor: darkScheme.primary,
    bottomNavigationBarTheme:
        BottomNavigationBarThemeData(selectedItemColor: darkScheme.tertiary),
    cardColor: darkScheme.primary,
    listTileTheme: ListTileThemeData(tileColor: darkScheme.surface),
  );
}

getLightTheme() {
  return ThemeData(
    brightness: ThemeData.light().brightness,
    colorScheme: ThemeData.light().colorScheme,
    cardColor: Colors.blue.shade600,
    bottomNavigationBarTheme:
        BottomNavigationBarThemeData(selectedItemColor: Colors.amber.shade800),
    listTileTheme: ListTileThemeData(
      selectedColor: Colors.amber,
      tileColor: Colors.white,
    ),
  );
}

getDarkTheme() {
  return ThemeData(
    brightness: ThemeData.dark().brightness,
    colorScheme: ThemeData.dark().colorScheme,
    scaffoldBackgroundColor: Colors.black,
    cardColor: Colors.grey.shade900,
    appBarTheme: AppBarTheme(color: Color.fromARGB(255, 24, 24, 24)),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Color.fromARGB(255, 24, 24, 24)),
    listTileTheme: ListTileThemeData(tileColor: Colors.grey.shade800),
  );
}
