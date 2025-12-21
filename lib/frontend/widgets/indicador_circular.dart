import 'dart:math';
import 'package:flutter/material.dart';

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
    final double seguro = porcentaje.clamp(0.0, 1.0);
    final int valor = (seguro * 100).round();

    return Column(
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(120, 120),
                painter: _CirculoPainter(seguro),
              ),
              Text(
                "$valor%",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          titulo,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }
}

class _CirculoPainter extends CustomPainter {
  final double porcentaje;

  _CirculoPainter(this.porcentaje);

  @override
  void paint(Canvas canvas, Size size) {
    final Offset centro = size.center(Offset.zero);
    final double radio = size.width / 2;

    final fondo = Paint()
      ..color = Colors.grey.shade800
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    final progreso = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFF39FF14), // verde flúor premium
          Color(0xFF2ECC71),
        ],
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
    return oldDelegate.porcentaje != porcentaje;
  }
}
