import 'package:flutter/material.dart';
import 'inicio_vista.dart';
import 'agregar_tarea_vista.dart';
import 'estadisticas_vista.dart';
import '../temas/temas.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _indexActual = 0;

  late final List<Widget> _vistas;

  @override
  void initState() {
    super.initState();
    _vistas = [InicioVista(), AgregarTareaVista(), EstadisticasVista()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _vistas[_indexActual],

      bottomNavigationBar: NavigationBar(
        height: 65,
        backgroundColor: Temas.FondoOscuro,
        indicatorColor: Colors.white.withOpacity(0.12),
        selectedIndex: _indexActual,
        onDestinationSelected: (i) {
          setState(() => _indexActual = i);
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle),
            label: "Add",
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: "Stats",
          ),
        ],
      ),
    );
  }
}
