import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectorMes extends StatelessWidget {
  final DateTime mesActual;
  final VoidCallback onAnterior;
  final VoidCallback onSiguiente;

  const SelectorMes({
    super.key,
    required this.mesActual,
    required this.onAnterior,
    required this.onSiguiente,
  });

  @override
  Widget build(BuildContext context) {
    final texto = DateFormat("MMMM yyyy", "es")
        .format(mesActual)
        .replaceFirstMapped(RegExp(r'^\w'), (m) => m.group(0)!.toUpperCase());

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color textoColor = isDark ? Colors.white : Colors.black87;

    final Color iconoColor = isDark ? Colors.white70 : Colors.black54;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          color: iconoColor,
          onPressed: onAnterior,
        ),
        Text(
          texto,
          style: TextStyle(
            color: textoColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          color: iconoColor,
          onPressed: onSiguiente,
        ),
      ],
    );
  }
}
