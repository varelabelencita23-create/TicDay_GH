import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../backend/servicios/tareas_servicio.dart';
import '../../backend/modelos/tarea_modelo.dart';

import '../widgets/tarjeta_tarea.dart';
import '../temas/temas.dart';
import '../widgets/iconos_categorias.dart';
import 'package:ticday/frontend/widgets/ios_menu.dart';

class InicioVista extends StatefulWidget {
  const InicioVista({super.key});

  @override
  State<InicioVista> createState() => _InicioVistaState();
}

class _InicioVistaState extends State<InicioVista> {
  final TareasServicio _servicio = TareasServicio();
  final String usuarioId = "usuario_demo";

  bool ordenarAZ = false;

  List<Tarea> _ordenar(List<Tarea> tareas) {
    final copia = List<Tarea>.from(tareas);
    copia.sort((a, b) {
      if (a.completado != b.completado) {
        return a.completado ? 1 : -1;
      }
      return ordenarAZ
          ? a.titulo.compareTo(b.titulo)
          : b.creadoEl.compareTo(a.creadoEl);
    });
    return copia;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Tarea>>(
      stream: _servicio.obtenerTareasUsuario(usuarioId),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final tareas = _ordenar(snap.data!);
        final hoy = tareas
            .where((t) => DateUtils.isSameDay(t.creadoEl, DateTime.now()))
            .toList();
        final pendientes = tareas.where((t) => !t.completado).toList();
        final completas = tareas.where((t) => t.completado).toList();

        return ListView(
          padding: const EdgeInsets.only(top: kToolbarHeight + 12),
          children: [
            _seccionHoy(hoy),
            _seccionExpandable("Pendientes", pendientes),
            _seccionExpandable("Completadas", completas),
            const SizedBox(height: 110),
          ],
        );
      },
    );
  }

  Widget _seccionHoy(List<Tarea> tareas) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _tituloSeccion("Hoy"),
        if (tareas.isEmpty) _textoVacio() else ...tareas.map(_tarjeta),
      ],
    );
  }

  Widget _seccionExpandable(String titulo, List<Tarea> tareas) {
    return ExpansionTile(
      title: Text(titulo, style: const TextStyle(color: Colors.white)),
      iconColor: Colors.white,
      collapsedIconColor: Colors.white54,
      children: tareas.isEmpty
          ? [_textoVacio()]
          : tareas.map(_tarjeta).toList(),
    );
  }

  Widget _tarjeta(Tarea t) {
    return TareaTarjeta(
      tarea: t,
      onToggle: () =>
          _servicio.actualizarTarea(t.copiaCon(completado: !t.completado)),
      onEliminar: () async {
        final ok = await _confirmarEliminar();
        if (ok) _servicio.borrarTarea(t.id);
      },
      onEditar: () => _mostrarBottomSheet(context, tarea: t),
    );
  }

  Future<bool> _confirmarEliminar() async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Eliminar tarea"),
            content: const Text("¿Seguro que querés eliminarla?"),
            actions: [
              TextButton(
                child: const Text("Cancelar"),
                onPressed: () => Navigator.pop(context, false),
              ),
              TextButton(
                child: const Text("Eliminar"),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
        ) ??
        false;
  }

  Widget _tituloSeccion(String texto) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Text(
        texto,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _textoVacio() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Text("No hay tareas aún", style: TextStyle(color: Colors.white54)),
    );
  }

  // ---------------- BOTTOM SHEET (ADD / EDIT) ----------------

  void _mostrarBottomSheet(BuildContext context, {Tarea? tarea}) {
    final tituloCtrl = TextEditingController(text: tarea?.titulo ?? "");
    DateTime? horaInicio = tarea?.horaInicio;
    DateTime? horaFin = tarea?.horaFin;
    String categoria = tarea?.icono ?? iconosCategorias.keys.first;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (_) {
        return SafeArea(
          child: StatefulBuilder(
            builder: (context, setModal) {
              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  MediaQuery.of(context).viewInsets.bottom + 32,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // HANDLE
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    TextField(
                      controller: tituloCtrl,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      decoration: const InputDecoration(
                        hintText: "Tarea",
                        hintStyle: TextStyle(color: Colors.white38),
                        border: InputBorder.none,
                      ),
                    ),

                    const SizedBox(height: 18),

                    Row(
                      children: [
                        _horaBox(
                          label: "Inicio",
                          hora: horaInicio,
                          onTap: () async {
                            final t = await _pickHora(context);
                            if (t != null) {
                              setModal(() => horaInicio = t);
                            }
                          },
                        ),
                        const SizedBox(width: 12),
                        _horaBox(
                          label: "Fin",
                          hora: horaFin,
                          onTap: () async {
                            final t = await _pickHora(context);
                            if (t != null) {
                              setModal(() => horaFin = t);
                            }
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: iconosCategorias.keys.map((key) {
                        final selected = key == categoria;
                        return ChoiceChip(
                          label: Text(key),
                          selected: selected,
                          selectedColor: Colors.grey.shade300,
                          backgroundColor: Colors.grey.shade800,
                          labelStyle: TextStyle(
                            color: selected ? Colors.black : Colors.white,
                          ),
                          onSelected: (_) => setModal(() => categoria = key),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Temas.AcentoColorOscuro,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          "Guardar",
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: () {
                          if (tituloCtrl.text.trim().isEmpty ||
                              horaInicio == null ||
                              horaFin == null)
                            return;

                          final nueva = Tarea(
                            id: tarea?.id ?? "",
                            titulo: tituloCtrl.text.trim(),
                            descripcion: "",
                            horaInicio: horaInicio,
                            horaFin: horaFin,
                            duracionMinutos: horaFin!
                                .difference(horaInicio!)
                                .inMinutes,
                            icono: categoria,
                            completado: tarea?.completado ?? false,
                            creadoEl: tarea?.creadoEl ?? DateTime.now(),
                            usuarioId: usuarioId,
                          );

                          tarea == null
                              ? _servicio.crearTarea(nueva)
                              : _servicio.actualizarTarea(nueva);

                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _horaBox({
    required String label,
    required DateTime? hora,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(label, style: const TextStyle(color: Colors.white54)),
              const SizedBox(height: 4),
              Text(
                hora == null ? "--:--" : DateFormat("HH:mm").format(hora),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<DateTime?> _pickHora(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked == null) return null;
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
  }
}
