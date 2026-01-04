import 'package:flutter/material.dart';

import 'inicio_vista.dart';
import 'agregar_tarea_vista.dart';
import 'estadisticas_vista.dart';

import '../temas/temas.dart';
import '../widgets/ios_menu.dart';
import '../widgets/ios_header.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _indexActual = 0;

  late final List<Widget> _vistas;

  @override
  void initState() {
    super.initState();
    _vistas = const [InicioVista(), AgregarTareaVista(), EstadisticasVista()];
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey,
      drawer: const IOSDrawer(),
      backgroundColor: isDark ? Temas.FondoOscuro : Temas.FondoClaro,

      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 160,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: IOSHeader(
                nombre: "Belu", // luego viene del perfil
                avatar: "",
                onAvatarTap: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
            ),
          ),

          SliverFillRemaining(
            hasScrollBody: true,
            child: _vistas[_indexActual],
          ),
        ],
      ),

      bottomNavigationBar: NavigationBar(
        height: 65,
        backgroundColor: isDark ? Temas.FondoOscuro : Temas.FondoClaro,
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
