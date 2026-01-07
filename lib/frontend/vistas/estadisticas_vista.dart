import 'package:flutter/material.dart';
import 'package:ticday/frontend/temas/temas.dart';

import '../../backend/controladores/estadisticas_controlador.dart';

import '../widgets/indicador_circular.dart';
import '../widgets/grafico_mensual.dart';
import '../widgets/selector_mes.dart';
import '../widgets/app_header.dart';
import 'package:ticday/frontend/widgets/ios_menu.dart';

class EstadisticasVista extends StatefulWidget {
  const EstadisticasVista({super.key});

  @override
  State<EstadisticasVista> createState() => _EstadisticasVistaState();
}

class _EstadisticasVistaState extends State<EstadisticasVista> {
  final EstadisticasControlador _controlador = EstadisticasControlador();
  final String usuarioId = "usuario_demo";

  DateTime mesSeleccionado = DateTime.now();

  bool get _esOscuro => Theme.of(context).brightness == Brightness.dark;

  Color get _fondo => _esOscuro ? Temas.FondoOscuro : Temas.FondoClaro;
  Color get _widget => _esOscuro ? Temas.WidgetOscuro : Temas.WidgetClaro;
  Color get _texto => _esOscuro ? Temas.TextOscuro : Temas.TextoClaro;
  Color get _acento =>
      _esOscuro ? Temas.AcentoColorOscuro : Temas.AcentoColorClaro;

  void _mesAnterior() {
    setState(() {
      mesSeleccionado = DateTime(
        mesSeleccionado.year,
        mesSeleccionado.month - 1,
      );
    });
  }

  void _mesSiguiente() {
    setState(() {
      mesSeleccionado = DateTime(
        mesSeleccionado.year,
        mesSeleccionado.month + 1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StreamBuilder<double>(
                  stream: _controlador.obtenerEstadisticaDiaria(usuarioId),
                  builder: (context, snap) {
                    final valor = snap.data ?? 0;
                    return IndicadorCircular(porcentaje: valor, titulo: "Hoy");
                  },
                ),
                StreamBuilder<List<double>>(
                  stream: _controlador.obtenerEstadisticaSemanal(usuarioId),
                  builder: (context, snap) {
                    final datos = snap.data ?? [];
                    final promedio = datos.isEmpty
                        ? 0.0
                        : datos.reduce((a, b) => a + b) / datos.length;

                    return IndicadorCircular(
                      porcentaje: promedio,
                      titulo: "Semana",
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 40),

            // ---------------- MES ----------------
            SelectorMes(
              mesActual: mesSeleccionado,
              onAnterior: _mesAnterior,
              onSiguiente: _mesSiguiente,
            ),

            const SizedBox(height: 24),

            StreamBuilder<List<double>>(
              stream: _controlador.obtenerEstadisticaMensual(
                usuarioId,
                mesSeleccionado.month,
                mesSeleccionado.year,
              ),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    child: Center(
                      child: CircularProgressIndicator(color: _acento),
                    ),
                  );
                }

                final datos = snap.data!;

                if (datos.every((d) => d == 0)) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    child: Center(
                      child: Text(
                        "No hay datos para este mes",
                        style: TextStyle(color: _texto.withOpacity(0.6)),
                      ),
                    ),
                  );
                }

                return GraficoMensual(datos: datos);
              },
            ),
          ],
        ),
      ),
    );
  }
}
