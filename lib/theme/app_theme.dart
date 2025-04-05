import 'package:flutter/material.dart';

/// Theme configuration for the Bluesky viewer app
class AppTheme {
  /// Dark theme colors based on X (Twitter) dark theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF1D9BF0), // Twitter blue
    scaffoldBackgroundColor: Colors.black,
    cardColor: const Color(0xFF202327),
    dividerColor: const Color(0xFF38444D),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF1D9BF0),      // Twitter blue
      secondary: Color(0xFF1D9BF0),    // Twitter blue
      background: Colors.black,
      surface: Color(0xFF202327),      // Card/dialog background
      onBackground: Colors.white,
      onSurface: Colors.white,
      error: Color(0xFFE0245E),        // Twitter red for errors
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.white, fontSize: 14),
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
      titleMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
      titleSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      labelMedium: TextStyle(color: Color(0xFF8899A6)), // Twitter muted text
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      selectedItemColor: Color(0xFF1D9BF0), // Twitter blue
      unselectedItemColor: Colors.grey,
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: const Color(0xFF202327),
      hintStyle: const TextStyle(color: Color(0xFF8899A6)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1D9BF0), // Twitter blue
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    ),
  );
}
