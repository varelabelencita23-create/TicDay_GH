import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../backend/modelos/tarea_modelo.dart';
import '../widgets/iconos_categorias.dart';
import '../temas/temas.dart';

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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final icono = iconosCategorias[tarea.icono] ?? iconoDefault;

    final Color fondo = isDark ? Temas.WidgetOscuro : Temas.WidgetClaro;
    final Color textoPrincipal = isDark ? Temas.TextOscuro : Temas.TextoClaro;
    final Color textoSecundario = isDark
        ? Temas.TextOscuro.withOpacity(0.6)
        : Temas.TextoClaro.withOpacity(0.6);

    final Color acento = isDark
        ? Temas.AcentoColorOscuro
        : Temas.AcentoColorClaro;

    return Dismissible(
      key: Key(tarea.id),
      direction: DismissDirection.horizontal,

      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 22),
        decoration: BoxDecoration(
          color: acento.withOpacity(0.9),
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(Icons.edit, color: Colors.white),
      ),

      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 22),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),

      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onEditar();
          return false;
        }

        if (direction == DismissDirection.endToStart) {
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

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: fondo,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.45)
                  : Colors.black.withOpacity(0.08),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 4,
              height: 72,
              decoration: BoxDecoration(
                color: tarea.completado ? acento : acento.withOpacity(0.4),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                ),
              ),
            ),

            const SizedBox(width: 10),

            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: acento.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icono, size: 18, color: acento),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tarea.titulo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textoPrincipal,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      decoration: tarea.completado
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      decorationColor: const Color.fromARGB(255, 0, 0, 0),
                      decorationThickness: 2.2,
                    ),
                  ),

                  if (tarea.horaInicio != null && tarea.horaFin != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        "${DateFormat("HH:mm").format(tarea.horaInicio!)} - ${DateFormat("HH:mm").format(tarea.horaFin!)}",
                        style: TextStyle(color: textoSecundario, fontSize: 11),
                      ),
                    ),
                ],
              ),
            ),

            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: Icon(
                tarea.completado
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                size: 22,
                color: tarea.completado ? acento : textoSecundario,
              ),
              onPressed: onToggle,
            ),
          ],
        ),
      ),
    );
  }
}
