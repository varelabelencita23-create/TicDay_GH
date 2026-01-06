import 'package:flutter/material.dart';
import 'temas.dart';

class AppTheme {
  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Temas.FondoOscuro,
    primaryColor: Temas.AcentoColorOscuro,
    cardColor: Temas.WidgetOscuro,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Temas.TextOscuro),
      bodyMedium: TextStyle(color: Temas.TextOscuro),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Temas.FondoOscuro,
      indicatorColor: Colors.white.withOpacity(0.12),
      labelTextStyle: MaterialStateProperty.all(
        const TextStyle(color: Colors.white),
      ),
      iconTheme: MaterialStateProperty.all(
        const IconThemeData(color: Colors.white),
      ),
    ),
  );

  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Temas.FondoClaro,
    primaryColor: Temas.AcentoColorClaro,
    cardColor: Temas.WidgetClaro,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Temas.TextoClaro),
      bodyMedium: TextStyle(color: Temas.TextoClaro),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Temas.FondoClaro,
      indicatorColor: Colors.black.withOpacity(0.08),
      labelTextStyle: MaterialStateProperty.all(
        const TextStyle(color: Colors.black),
      ),
      iconTheme: MaterialStateProperty.all(
        const IconThemeData(color: Colors.black),
      ),
    ),
  );
}
