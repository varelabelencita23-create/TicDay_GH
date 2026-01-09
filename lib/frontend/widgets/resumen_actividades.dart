import 'package:flutter/material.dart';

class ResumenActividades extends StatelessWidget {
  final int completadas;
  final int pendientes;

  const ResumenActividades({
    super.key,
    required this.completadas,
    required this.pendientes,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: _ItemResumen(
            titulo: 'Completadas',
            cantidad: completadas,
            icono: Icons.check_circle_rounded,
            color: Colors.greenAccent,
            theme: theme,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ItemResumen(
            titulo: 'Pendientes',
            cantidad: pendientes,
            icono: Icons.timelapse_rounded,
            color: theme.primaryColor,
            theme: theme,
          ),
        ),
      ],
    );
  }
}

class _ItemResumen extends StatelessWidget {
  final String titulo;
  final int cantidad;
  final IconData icono;
  final Color color;
  final ThemeData theme;

  const _ItemResumen({
    required this.titulo,
    required this.cantidad,
    required this.icono,
    required this.color,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 86,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.dividerColor.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          /// ICONO
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(isDark ? 0.25 : 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icono, color: color, size: 22),
          ),

          const SizedBox(width: 12),

          /// TEXTO
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  cantidad.toString(),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: theme.textTheme.bodyLarge?.color,
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
