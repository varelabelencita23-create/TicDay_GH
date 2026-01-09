import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final ValueNotifier<ThemeMode> temaNotifier = ValueNotifier<ThemeMode>(
  ThemeMode.light,
);

const _temaKey = 'tema_modo';
const _firstLaunchKey = 'first_launch';

Future<void> cargarTemaInicial() async {
  final prefs = await SharedPreferences.getInstance();

  final bool isFirstLaunch = prefs.getBool(_firstLaunchKey) ?? true;

  if (isFirstLaunch) {
    temaNotifier.value = ThemeMode.light;
    await prefs.setString(_temaKey, 'light');
    await prefs.setBool(_firstLaunchKey, false);
  } else {
    final temaGuardado = prefs.getString(_temaKey);

    switch (temaGuardado) {
      case 'dark':
        temaNotifier.value = ThemeMode.dark;
        break;
      case 'system':
        temaNotifier.value = ThemeMode.system;
        break;
      default:
        temaNotifier.value = ThemeMode.light;
    }
  }
}

Future<void> setTema(ThemeMode mode) async {
  final prefs = await SharedPreferences.getInstance();

  temaNotifier.value = mode;

  if (mode == ThemeMode.dark) {
    prefs.setString(_temaKey, 'dark');
  } else if (mode == ThemeMode.system) {
    prefs.setString(_temaKey, 'system');
  } else {
    prefs.setString(_temaKey, 'light');
  }
}
