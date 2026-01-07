import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ticday/frontend/temas/temas.dart';
import '../../backend/controladores/agregar_tarea_controlador.dart';
import '../widgets/app_header.dart';

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

  bool get _esOscuro => Theme.of(context).brightness == Brightness.dark;

  Color get _fondo => _esOscuro ? Temas.FondoOscuro : Temas.FondoClaro;
  Color get _widget => _esOscuro ? Temas.WidgetOscuro : Temas.WidgetClaro;
  Color get _texto => _esOscuro ? Temas.TextOscuro : Temas.TextoClaro;
  Color get _acento =>
      _esOscuro ? Temas.AcentoColorOscuro : Temas.AcentoColorClaro;

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

  Future<DateTime?> _pickHora() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: _fondo,
              hourMinuteColor: _widget,
              hourMinuteTextColor: _texto,
              dialBackgroundColor: _widget,
              dialHandColor: _acento,
              dialTextColor: _texto,
              entryModeIconColor: _acento,
              dayPeriodTextColor: _texto,
            ),
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: _acento,
              onPrimary: Temas.TextOscuro,
              surface: _fondo,
              onSurface: _texto,
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
      backgroundColor: _fondo,
      appBar: AppHeader(onMenuTap: () => Scaffold.of(context).openDrawer()),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _tituloCtrl,
              decoration: _input("Nombre de la actividad"),
              style: TextStyle(color: _texto),
            ),

            const SizedBox(height: 10),

            SwitchListTile(
              title: Text("Hora inicio", style: TextStyle(color: _texto)),
              subtitle: Text(
                _horaInicio != null
                    ? DateFormat("HH:mm").format(_horaInicio!)
                    : "Sin hora",
                style: TextStyle(color: _texto.withOpacity(0.6)),
              ),
              value: _horaInicio != null,
              activeColor: Colors.white, // circulito blanco
              activeTrackColor: _acento, // pista color acento
              inactiveThumbColor: Colors.white, // apagado igual
              inactiveTrackColor: _widget,
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
              title: Text("Hora fin", style: TextStyle(color: _texto)),
              subtitle: Text(
                _horaFin != null
                    ? DateFormat("HH:mm").format(_horaFin!)
                    : "Sin hora",
                style: TextStyle(color: _texto.withOpacity(0.6)),
              ),
              value: _horaFin != null,
              activeColor: Colors.white, // circulito blanco
              activeTrackColor: _acento, // pista color acento
              inactiveThumbColor: Colors.white, // apagado igual
              inactiveTrackColor: _widget,

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
              style: TextStyle(color: _texto),
            ),

            const SizedBox(height: 20),

            Text(
              "Categorías",
              style: TextStyle(color: _texto, fontWeight: FontWeight.bold),
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
                      color: _widget,
                      borderRadius: BorderRadius.circular(10),
                      border: selected
                          ? Border.all(color: _acento, width: 2)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(cat["icon"], size: 22, color: _texto),
                        const SizedBox(height: 4),
                        Text(
                          cat["label"],
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 10, color: _texto),
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
                  backgroundColor: _acento,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Guardar",
                  style: TextStyle(
                    color: Temas.FondoClaro,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
      hintStyle: TextStyle(color: _texto.withOpacity(0.5)),
      filled: true,
      fillColor: _widget,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
