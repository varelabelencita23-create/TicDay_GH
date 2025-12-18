import 'package:flutter/material.dart';
import 'package:ticday/frontend/temas/temas.dart';

class EstadisticasVista extends StatelessWidget {
  const EstadisticasVista({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Temas.FondoOscuro,
      appBar: AppBar(
        backgroundColor: Temas.FondoOscuro,
        title: const Text("Estadísticas"),
      ),
      body: const Center(
        child: Text("Prueba aaa", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
