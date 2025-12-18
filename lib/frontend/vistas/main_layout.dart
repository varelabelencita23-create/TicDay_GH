import 'package:flutter/material.dart';
import 'inicio_vista.dart';
import 'agregar_tarea_vista.dart';
import 'estadisticas_vista.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _indexActual = 1; // 0=Home, 1=Agregar, 2=Stats

  final List<Widget> _vistas = const [
    InicioVista(),
    AgregarTareaVista(),
    EstadisticasVista(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _vistas[_indexActual],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indexActual,
        onTap: (i) => setState(() => _indexActual = i),

        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: "Añadir",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Stats"),
        ],
      ),
    );
  }
}
