import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../backend/servicios/tareas_servicio.dart';
import '../../backend/modelos/tarea_modelo.dart';

import '../widgets/tarjeta_tarea.dart';
import '../widgets/calendario_horizontal.dart';
import '../widgets/selector_mes.dart';
import '../widgets/resumen_actividades.dart';
import 'package:ticday/frontend/temas/temas.dart';

enum OrdenTareas { az, za, fechaAsc, fechaDesc, horaAsc, horaDesc }

class InicioVista extends StatefulWidget {
  const InicioVista({super.key});

  @override
  State<InicioVista> createState() => _InicioVistaState();
}

class _InicioVistaState extends State<InicioVista>
    with SingleTickerProviderStateMixin {
  final TareasServicio _servicio = TareasServicio();
  final String usuarioId = "usuario_demo";

  DateTime mesActual = DateTime.now();
  DateTime fechaSeleccionada = DateTime.now();

  OrdenTareas ordenActual = OrdenTareas.fechaDesc;

  bool _mostrarConfetti = false;
  bool _celebracionMostrada = false;

  late final AnimationController _confettiController;
  late final List<_ConfettiStrip> _confetti;

  @override
  void initState() {
    super.initState();

    _confettiController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 1600),
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            setState(() => _mostrarConfetti = false);
          }
        });

    _confetti = List.generate(260, (_) => _ConfettiStrip.random());
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  List<Tarea> _ordenar(List<Tarea> tareas) {
    final copia = List<Tarea>.from(tareas);

    copia.sort((a, b) {
      if (a.completado != b.completado) {
        return a.completado ? 1 : -1;
      }

      switch (ordenActual) {
        case OrdenTareas.az:
          return a.titulo.compareTo(b.titulo);
        case OrdenTareas.za:
          return b.titulo.compareTo(a.titulo);
        case OrdenTareas.fechaAsc:
          return a.creadoEl.compareTo(b.creadoEl);
        case OrdenTareas.fechaDesc:
          return b.creadoEl.compareTo(a.creadoEl);
        case OrdenTareas.horaAsc:
          return (a.horaInicio ?? DateTime(0)).compareTo(
            b.horaInicio ?? DateTime(0),
          );
        case OrdenTareas.horaDesc:
          return (b.horaInicio ?? DateTime(0)).compareTo(
            a.horaInicio ?? DateTime(0),
          );
      }
    });

    return copia;
  }

  void _celebrar(BuildContext context) {
    if (_celebracionMostrada) return;

    _celebracionMostrada = true;
    setState(() => _mostrarConfetti = true);
    _confettiController.forward(from: 0);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? Temas.AcentoColorOscuro : Temas.AcentoColorClaro;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? Temas.WidgetOscuro : Temas.WidgetClaro,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Día PERFECTO!",
          style: TextStyle(color: accent, fontWeight: FontWeight.w800),
        ),
        content: Text(
          "Completaste el 100% de tus tareas.\nEsto no es suerte, es disciplina.",
          textAlign: TextAlign.center,
          style: TextStyle(color: isDark ? Temas.TextOscuro : Temas.TextoClaro),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _confettiController.stop();
              setState(() => _mostrarConfetti = false);
            },
            child: Text(
              "Seguir rompiéndola",
              style: TextStyle(color: accent, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          StreamBuilder<List<Tarea>>(
            stream: _servicio.obtenerTareasUsuario(usuarioId),
            builder: (context, snap) {
              if (!snap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final tareas = _ordenar(snap.data!);
              final tareasDelDia = tareas
                  .where(
                    (t) => DateUtils.isSameDay(t.creadoEl, fechaSeleccionada),
                  )
                  .toList();

              final completas = tareasDelDia.where((t) => t.completado).length;
              final total = tareasDelDia.length;
              final progreso = total == 0 ? 0.0 : completas / total;

              if (total > 0 && completas == total) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _celebrar(context);
                });
              }

              return ListView(
                padding: const EdgeInsets.only(top: 8),
                children: [
                  SelectorMes(
                    mesActual: mesActual,
                    onAnterior: () => setState(() {
                      mesActual = DateTime(mesActual.year, mesActual.month - 1);
                      fechaSeleccionada = DateTime(
                        mesActual.year,
                        mesActual.month,
                        1,
                      );
                      _celebracionMostrada = false;
                    }),
                    onSiguiente: () => setState(() {
                      mesActual = DateTime(mesActual.year, mesActual.month + 1);
                      fechaSeleccionada = DateTime(
                        mesActual.year,
                        mesActual.month,
                        1,
                      );
                      _celebracionMostrada = false;
                    }),
                  ),

                  const SizedBox(height: 6),

                  CalendarioHorizontal(
                    mesActual: mesActual,
                    fechaSeleccionada: fechaSeleccionada,
                    onSeleccionar: (d) => setState(() {
                      fechaSeleccionada = d;
                      _celebracionMostrada = false;
                    }),
                  ),

                  const SizedBox(height: 14),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ResumenActividades(
                      completadas: completas,
                      pendientes: total - completas,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _ProductividadDiaria(porcentaje: progreso),
                  ),

                  const SizedBox(height: 18),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      DateUtils.isSameDay(fechaSeleccionada, DateTime.now())
                          ? "Hoy"
                          : DateFormat(
                              "EEEE d MMM",
                              'es',
                            ).format(fechaSeleccionada),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  if (tareasDelDia.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        "No hay tareas para este día",
                        style: TextStyle(
                          color: theme.textTheme.bodyMedium?.color?.withOpacity(
                            0.6,
                          ),
                        ),
                      ),
                    )
                  else
                    ...tareasDelDia.map(
                      (t) => TareaTarjeta(
                        tarea: t,
                        onToggle: () => _servicio.actualizarTarea(
                          t.copiaCon(completado: !t.completado),
                        ),
                        onEliminar: () => _servicio.borrarTarea(t.id),
                        onEditar: () {},
                      ),
                    ),

                  const SizedBox(height: 120),
                ],
              );
            },
          ),

          if (_mostrarConfetti)
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _ConfettiStripPainter(
                    animation: _confettiController,
                    strips: _confetti,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// ================= PRODUCTIVIDAD =================

class _ProductividadDiaria extends StatelessWidget {
  final double porcentaje;

  const _ProductividadDiaria({required this.porcentaje});

  String _mensaje() {
    if (porcentaje == 0) return "Arrancá tranqui, todo suma";
    if (porcentaje < 0.3) return "Todavía hay margen";
    if (porcentaje < 0.7) return "Buen ritmo, seguí así!";
    if (porcentaje < 1) return "Tremendo día productivo!";
    return "Perfecto. Nada que mejorar";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final value = (porcentaje * 100).round();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: CustomPaint(painter: _MiniCirculoPainter(porcentaje)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$value% de productividad",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _mensaje(),
                  style: TextStyle(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniCirculoPainter extends CustomPainter {
  final double porcentaje;

  _MiniCirculoPainter(this.porcentaje);

  Color _color() {
    if (porcentaje < 0.3) return Colors.redAccent;
    if (porcentaje < 0.6) return Colors.orangeAccent;
    if (porcentaje < 0.85) return Colors.amber;
    return Colors.greenAccent;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    final bg = Paint()
      ..color = Colors.grey.withOpacity(0.25)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    final fg = Paint()
      ..color = _color()
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, bg);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * porcentaje,
      false,
      fg,
    );
  }

  @override
  bool shouldRepaint(covariant _MiniCirculoPainter oldDelegate) =>
      oldDelegate.porcentaje != porcentaje;
}

/// ================= CONFETTI TIRITAS =================

class _ConfettiStrip {
  final double x;
  final double width;
  final double height;
  final double speed;
  final double rotation;
  final Color color;

  _ConfettiStrip({
    required this.x,
    required this.width,
    required this.height,
    required this.speed,
    required this.rotation,
    required this.color,
  });

  factory _ConfettiStrip.random() {
    final rnd = Random();
    return _ConfettiStrip(
      x: rnd.nextDouble(),
      width: rnd.nextDouble() * 4 + 2,
      height: rnd.nextDouble() * 14 + 8,
      speed: rnd.nextDouble() * 1.2 + 0.6,
      rotation: rnd.nextDouble() * pi,
      color: Colors.primaries[rnd.nextInt(Colors.primaries.length)],
    );
  }
}

class _ConfettiStripPainter extends CustomPainter {
  final Animation<double> animation;
  final List<_ConfettiStrip> strips;

  _ConfettiStripPainter({required this.animation, required this.strips})
    : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    for (final s in strips) {
      final dy = animation.value * size.height * s.speed;
      final dx = s.x * size.width;

      canvas.save();
      canvas.translate(dx, dy - 120);
      canvas.rotate(s.rotation + animation.value * 2);

      final paint = Paint()..color = s.color.withOpacity(0.85);
      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: s.width, height: s.height),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
