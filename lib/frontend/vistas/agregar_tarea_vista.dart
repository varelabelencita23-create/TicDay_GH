import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ticday/frontend/temas/temas.dart';
import '../../backend/controladores/agregar_tarea_controlador.dart';

class AgregarTareaVista extends StatefulWidget {
  const AgregarTareaVista({super.key});

  @override
  State<AgregarTareaVista> createState() => _AgregarTareaVistaState();
}

class _AgregarTareaVistaState extends State<AgregarTareaVista> {
  final _ctrl = AgregarTareaControlador();
  final TextEditingController _tituloCtrl = TextEditingController();
  final TextEditingController _descripcionCtrl = TextEditingController();

  DateTime? _horaInicio;
  DateTime? _horaFin;
  String? _categoriaSeleccionada;

  bool _guardando = false;

  final List<Map<String, dynamic>> _categorias = [
    {"icon": Icons.book, "label": "Estudio"},
    {"icon": Icons.kitchen, "label": "Cocina"},
    {"icon": Icons.fitness_center, "label": "Ejercicio"},
    {"icon": Icons.shopping_cart, "label": "Compras"},
    {"icon": Icons.cleaning_services, "label": "Limpieza"},
    {"icon": Icons.people, "label": "Social"},
    {"icon": Icons.person, "label": "Personal"},
    {"icon": Icons.event, "label": "Cita"},
    {"icon": Icons.notifications, "label": "Recordatorio"},
    {"icon": Icons.work, "label": "Trabajo"},
    {"icon": Icons.videogame_asset, "label": "Ocio"},
    {"icon": Icons.place, "label": "Lugar"},
  ];

  void _mostrarError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _guardarTarea() async {
    if (_tituloCtrl.text.trim().isEmpty) {
      _mostrarError("El título es obligatorio");
      return;
    }

    if (_categoriaSeleccionada == null) {
      _mostrarError("Seleccioná una categoría");
      return;
    }

    setState(() => _guardando = true);

    try {
      await _ctrl.crearTarea(
        titulo: _tituloCtrl.text.trim(),
        descripcion: _descripcionCtrl.text.trim().isEmpty
            ? null
            : _descripcionCtrl.text.trim(),
        horaInicio: _horaInicio,
        horaFin: _horaFin,
        duracionMinutos: (_horaInicio != null && _horaFin != null)
            ? _ctrl.calcularDuracion(_horaInicio!, _horaFin!).inMinutes
            : null,
        icono: _categoriaSeleccionada!,
        usuarioId: "usuario_demo",
      );

      //limpiar el formulario
      _tituloCtrl.clear();
      _descripcionCtrl.clear();
      setState(() {
        _horaInicio = null;
        _horaFin = null;
        _categoriaSeleccionada = null;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Tarea guardada")));
    } catch (e) {
      _mostrarError("Error al guardar la tarea");
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  //picker hora
  Future<DateTime?> _pickHora() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.white,
              onPrimary: Colors.black,
              surface: Color(0xFF1E1E1E),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (time == null) return null;

    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Temas.FondoOscuro,
      appBar: AppBar(backgroundColor: Temas.FondoOscuro),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _tituloCtrl,
              decoration: _input("Nombre de la actividad"),
              style: const TextStyle(color: Temas.TextOscuro),
            ),

            const SizedBox(height: 10),

            SwitchListTile(
              title: const Text(
                "Hora inicio",
                style: TextStyle(color: Temas.TextOscuro),
              ),
              subtitle: Text(
                _horaInicio != null
                    ? DateFormat("HH:mm").format(_horaInicio!)
                    : "Sin hora",
                style: const TextStyle(color: Colors.grey),
              ),
              value: _horaInicio != null,
              activeColor: Colors.white,
              activeTrackColor: const Color(0xFF39FF14),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.grey.shade700,
              onChanged: (v) async {
                if (!v) {
                  setState(() => _horaInicio = null);
                } else {
                  final h = await _pickHora();
                  if (h != null) setState(() => _horaInicio = h);
                }
              },
            ),

            SwitchListTile(
              title: const Text(
                "Hora fin",
                style: TextStyle(color: Temas.TextOscuro),
              ),
              subtitle: Text(
                _horaFin != null
                    ? DateFormat("HH:mm").format(_horaFin!)
                    : "Sin hora",
                style: const TextStyle(color: Colors.grey),
              ),
              value: _horaFin != null,
              activeColor: Colors.white,
              activeTrackColor: const Color(0xFF39FF14),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.grey.shade700,
              onChanged: (v) async {
                if (!v) {
                  setState(() => _horaFin = null);
                } else {
                  final h = await _pickHora();
                  if (h != null) setState(() => _horaFin = h);
                }
              },
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _descripcionCtrl,
              maxLines: 3,
              decoration: _input("Descripción"),
              style: const TextStyle(color: Temas.TextOscuro),
            ),

            const SizedBox(height: 20),

            const Text(
              "Categorías",
              style: TextStyle(
                color: Temas.TextOscuro,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _categorias.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 80,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (context, i) {
                final cat = _categorias[i];
                final selected = _categoriaSeleccionada == cat["label"];

                return GestureDetector(
                  onTap: () =>
                      setState(() => _categoriaSeleccionada = cat["label"]),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Temas.WidgetOscuro,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: selected ? Colors.white : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(cat["icon"], size: 22, color: Colors.white),
                        const SizedBox(height: 4),
                        Text(
                          cat["label"],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _guardando ? null : _guardarTarea,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Temas.AcentoColorOscuro,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Guardar"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _input(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Temas.WidgetOscuro,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
