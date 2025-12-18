import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:device_preview/device_preview.dart';
import 'firebase_options.dart';
import 'frontend/vistas/inicio_vista.dart';
import 'frontend/vistas/agregar_tarea_vista.dart';
import 'frontend/vistas/main_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const TicDayFinal());
}

class TicDayFinal extends StatelessWidget {
  const TicDayFinal({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const MainLayout(),
    );
  }
}
