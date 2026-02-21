import 'package:flutter/material.dart';

class AppTheme {
  static const _seed = Color(0xFF0B6B46);
  static const _surfaceTint = Color(0xFFE8F3EE);
  static const _bg = Color(0xFFF3F6F5);
  static const _text = Color(0xFF123126);

  static ThemeData get lightTheme => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seed,
          brightness: Brightness.light,
          primary: _seed,
          secondary: const Color(0xFFC5A24A),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: _bg,
        textTheme: const TextTheme(
          displaySmall:
              TextStyle(fontWeight: FontWeight.w700, letterSpacing: -0.5),
          headlineSmall: TextStyle(fontWeight: FontWeight.w700, color: _text),
          titleLarge: TextStyle(fontWeight: FontWeight.w700, color: _text),
          titleMedium: TextStyle(fontWeight: FontWeight.w600, color: _text),
          bodyMedium: TextStyle(color: Color(0xFF456356), height: 1.45),
          bodySmall: TextStyle(color: Color(0xFF58786B)),
        ),
        cardTheme: const CardThemeData(
          elevation: 2,
          color: Colors.white,
          margin: EdgeInsets.zero,
          surfaceTintColor: _surfaceTint,
          shadowColor: Color(0x14000000),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            side: BorderSide(color: Color(0x110B6B46)),
          ),
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          foregroundColor: _text,
          titleTextStyle: TextStyle(
            color: _text,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0x1A0B6B46)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0x1A0B6B46)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _seed, width: 1.2),
          ),
          labelStyle: const TextStyle(color: Color(0xFF56776A)),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: _seed, brightness: Brightness.dark),
        useMaterial3: true,
      );
}
