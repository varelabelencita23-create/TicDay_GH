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

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          color: Colors.white70,
          onPressed: onAnterior,
        ),
        Text(
          texto,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          color: Colors.white70,
          onPressed: onSiguiente,
        ),
      ],
    );
  }
}
