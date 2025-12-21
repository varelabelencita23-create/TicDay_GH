import 'package:flutter/material.dart';

class GraficoMensual extends StatelessWidget {
  final List<double> datos; // valores entre 0.0 y 1.0

  const GraficoMensual({super.key, required this.datos});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: double.infinity,
      child: CustomPaint(painter: _GraficoPainter(datos)),
    );
  }
}

class _GraficoPainter extends CustomPainter {
  final List<double> datos;

  _GraficoPainter(this.datos);

  @override
  void paint(Canvas canvas, Size size) {
    if (datos.isEmpty) return;

    final paintLinea = Paint()
      ..color =
          const Color(0xFF39FF14) // verde flúor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final paintPunto = Paint()
      ..color = const Color(0xFF39FF14)
      ..style = PaintingStyle.fill;

    final ancho = size.width;
    final alto = size.height;
    final pasoX = datos.length > 1 ? ancho / (datos.length - 1) : ancho;

    final path = Path();

    for (int i = 0; i < datos.length; i++) {
      final x = pasoX * i;
      final y = alto - (datos[i].clamp(0.0, 1.0) * alto);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      canvas.drawCircle(Offset(x, y), 3, paintPunto);
    }

    canvas.drawPath(path, paintLinea);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
