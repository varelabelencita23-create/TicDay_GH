import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'firebase_options.dart';
import 'frontend/vistas/splash_vista.dart';
import 'backend/estado/tema_estado.dart';
import 'frontend/temas/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await initializeDateFormatting('es');

  runApp(const TicDayFinal());
}

class TicDayFinal extends StatelessWidget {
  const TicDayFinal({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: temaNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeMode,

          home: const SplashVista(),
        );
      },
    );
  }
}
