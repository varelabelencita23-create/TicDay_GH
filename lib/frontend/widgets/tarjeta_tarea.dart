import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../backend/modelos/tarea_modelo.dart';
import '../temas/temas.dart';
import '../widgets/iconos_categorias.dart';

class TareaTarjeta extends StatelessWidget {
  final Tarea tarea;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;
  final VoidCallback onToggle;

  const TareaTarjeta({
    super.key,
    required this.tarea,
    required this.onEditar,
    required this.onEliminar,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final icono = iconosCategorias[tarea.icono] ?? iconoDefault;

    return Dismissible(
      key: Key(tarea.id),
      direction: DismissDirection.horizontal,

      // FONDO EDITAR (derecha)
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        color: Colors.orangeAccent,
        child: const Icon(Icons.edit, color: Colors.white),
      ),

      // FONDO ELIMINAR (izquierda)
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.redAccent,
        child: const Icon(Icons.delete, color: Colors.white),
      ),

      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // EDITAR
          onEditar();
          return false;
        }

        if (direction == DismissDirection.endToStart) {
          // ELIMINAR con confirmación
          final ok =
              await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Eliminar tarea"),
                  content: const Text(
                    "¿Seguro que querés eliminar esta tarea?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancelar"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Eliminar"),
                    ),
                  ],
                ),
              ) ??
              false;

          if (ok) onEliminar();
          return false;
        }

        return false;
      },

      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Temas.WidgetOscuro,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // ICONO
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Temas.WidgetOscuro,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icono, color: Colors.white, size: 18),
            ),

            const SizedBox(width: 10),

            // TEXTO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tarea.titulo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      decoration: tarea.completado
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  if (tarea.horaInicio != null && tarea.horaFin != null)
                    Text(
                      "${DateFormat("HH:mm").format(tarea.horaInicio!)} - ${DateFormat("HH:mm").format(tarea.horaFin!)}",
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
            ),

            // CHECK
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: Icon(
                tarea.completado
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                size: 20,
                color: tarea.completado
                    ? const Color(0xFF39FF14) // verde flúor
                    : const Color.fromARGB(255, 255, 255, 255),
              ),
              onPressed: onToggle,
            ),
          ],
        ),
      ),
    );
  }
}

