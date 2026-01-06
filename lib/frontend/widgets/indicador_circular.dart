import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ticday/frontend/temas/temas.dart';

class IndicadorCircular extends StatelessWidget {
  final double porcentaje; // 0.0 a 1.0
  final String titulo;

  const IndicadorCircular({
    super.key,
    required this.porcentaje,
    required this.titulo,
  });

  @override
  Widget build(BuildContext context) {
    final bool esOscuro = Theme.of(context).brightness == Brightness.dark;

    final Color fondoWidget = esOscuro ? Temas.WidgetOscuro : Temas.WidgetClaro;

    final Color colorTexto = esOscuro ? Temas.TextOscuro : Temas.TextoClaro;

    final double seguro = porcentaje.clamp(0.0, 1.0);
    final int valor = (seguro * 100).round();

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: fondoWidget,
            borderRadius: BorderRadius.circular(22),
          ),
          child: SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(120, 120),
                  painter: _CirculoPainter(
                    porcentaje: seguro,
                    esOscuro: esOscuro,
                  ),
                ),
                Text(
                  "$valor%",
                  style: TextStyle(
                    color: colorTexto,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          titulo,
          style: TextStyle(color: colorTexto.withOpacity(0.7), fontSize: 14),
        ),
      ],
    );
  }
}

class _CirculoPainter extends CustomPainter {
  final double porcentaje;
  final bool esOscuro;

  _CirculoPainter({required this.porcentaje, required this.esOscuro});

  Color _colorContinuo(double p) {
    const stops = [0.0, 0.25, 0.5, 0.75, 1.0];
    const colores = [
      Color.fromARGB(255, 255, 0, 0), // rojo fuerte
      Color.fromARGB(255, 255, 0, 51), // rojo vivo
      Color.fromARGB(255, 255, 123, 0), // naranja
      Color.fromARGB(255, 255, 230, 0), // amarillo
      Color.fromARGB(255, 0, 255, 76), // verde flúor
    ];

    for (int i = 0; i < stops.length - 1; i++) {
      if (p >= stops[i] && p <= stops[i + 1]) {
        final t = (p - stops[i]) / (stops[i + 1] - stops[i]);
        return Color.lerp(colores[i], colores[i + 1], t)!;
      }
    }
    return colores.last;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Offset centro = size.center(Offset.zero);
    final double radio = size.width / 2;

    final Color fondoCirculo = esOscuro
        ? Colors.grey.shade700
        : Colors.grey.shade400;

    final fondo = Paint()
      ..color = fondoCirculo
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    final Color base = _colorContinuo(porcentaje);

    final progreso = Paint()
      ..shader = SweepGradient(
        startAngle: -pi / 2,
        endAngle: 3 * pi / 2,
        colors: [base.withOpacity(0.65), base, base.withOpacity(0.9)],
      ).createShader(Rect.fromCircle(center: centro, radius: radio))
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(centro, radio, fondo);

    final double angulo = 2 * pi * porcentaje;
    canvas.drawArc(
      Rect.fromCircle(center: centro, radius: radio),
      -pi / 2,
      angulo,
      false,
      progreso,
    );
  }

  @override
  bool shouldRepaint(covariant _CirculoPainter oldDelegate) {
    return oldDelegate.porcentaje != porcentaje ||
        oldDelegate.esOscuro != esOscuro;
  }
}
