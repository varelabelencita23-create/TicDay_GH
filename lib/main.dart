import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'firebase_options.dart';
import 'frontend/vistas/main_layout.dart';
import 'frontend/vistas/splash_vista.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const SplashVista(),
    );
  }
}
