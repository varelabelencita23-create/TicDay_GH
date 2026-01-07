import 'package:flutter/material.dart';

import 'inicio_vista.dart';
import 'agregar_tarea_vista.dart';
import 'estadisticas_vista.dart';
import '../../backend/estado/usuario_estado.dart';
import '../../backend/modelos/usuario_modelo.dart';
import '../temas/temas.dart';
import '../widgets/ios_menu.dart';
import '../widgets/ios_header.dart';

class MainLayout extends StatefulWidget {
  final String uid;

  const MainLayout({super.key, required this.uid});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _indexActual = 0;

  final List<Widget> _vistas = const [
    InicioVista(),
    AgregarTareaVista(),
    EstadisticasVista(),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey,
      drawer: IOSDrawer(uid: widget.uid),
      backgroundColor: isDark ? Temas.FondoOscuro : Temas.FondoClaro,

      body: _indexActual == 0
          ? ValueListenableBuilder<UsuarioModelo?>(
              valueListenable: usuarioNotifier,
              builder: (context, usuario, _) {
                return Column(
                  children: [
                    IOSHeader(
                      nombre: usuario?.nombre ?? "Hola",
                      avatar: usuario?.iconoAvatar ?? "",
                      onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
                    ),

                    const Expanded(child: InicioVista()),
                  ],
                );
              },
            )
          : _vistas[_indexActual],

      floatingActionButton: _indexActual == 0
          ? FloatingActionButton(
              backgroundColor: Temas.AcentoColorOscuro,
              onPressed: () => setState(() => _indexActual = 1),
              child: const Icon(Icons.add),
            )
          : null,

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
