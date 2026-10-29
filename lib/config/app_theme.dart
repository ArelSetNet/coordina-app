import 'package:flutter/material.dart';

class AppTheme {
  static const Color azulPrincipal = Color(0xFF174A7E);
  static const Color azulSecundario = Color(0xFF2F6FA5);
  static const Color verde = Color(0xFF4F9D79);

  static const Color fondo = Color(0xFFF4F7FA);
  static const Color superficie = Color(0xFFFFFFFF);

  static const Color textoPrincipal = Color(0xFF263238);
  static const Color textoSecundario = Color(0xFF667085);

  static const Color error = Color(0xFFB42318);
  static const Color exito = Color(0xFF2E7D32);

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: azulPrincipal,
      brightness: Brightness.light,
    ).copyWith(
      primary: azulPrincipal,
      secondary: azulSecundario,
      surface: superficie,
      error: error,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: fondo,

      appBarTheme: const AppBarTheme(
        backgroundColor: fondo,
        foregroundColor: textoPrincipal,
        elevation: 0,
        centerTitle: true,
      ),

      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          color: textoPrincipal,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: textoPrincipal,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: textoPrincipal,
        ),
        bodyMedium: TextStyle(
          color: textoSecundario,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: superficie,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: azulPrincipal,
            width: 1.5,
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: azulPrincipal,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: azulSecundario,
        ),
      ),

      cardTheme: CardThemeData(
        color: superficie,
        elevation: 1,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      dividerColor: Colors.grey.shade200,
    );
  }
}