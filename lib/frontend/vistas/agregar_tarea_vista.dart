import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ticday/frontend/temas/temas.dart';

class AgregarTareaVista extends StatefulWidget {
  const AgregarTareaVista({super.key});

  @override
  State<AgregarTareaVista> createState() => _AgregarTareaVistaState();
}

class _AgregarTareaVistaState extends State<AgregarTareaVista> {
  final TextEditingController _tituloCtrl = TextEditingController();
  final TextEditingController _descripcionCtrl = TextEditingController();

  DateTime? _horaInicio;
  DateTime? _horaFin;

  String? _categoriaSeleccionada;

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

  Future<void> _seleccionarHoraInicio() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.white,
              onPrimary: Colors.black,
              surface: Temas.WidgetOscuro,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Temas.FondoOscuro,
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      final now = DateTime.now();
      setState(() {
        _horaInicio = DateTime(
          now.year,
          now.month,
          now.day,
          time.hour,
          time.minute,
        );
      });
    }
  }

  Future<void> _seleccionarHoraFin() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.white,
              onPrimary: Colors.black,
              surface: Temas.WidgetOscuro,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Temas.FondoOscuro,
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      final now = DateTime.now();
      setState(() {
        _horaFin = DateTime(
          now.year,
          now.month,
          now.day,
          time.hour,
          time.minute,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Temas.FondoOscuro,

      appBar: AppBar(
        backgroundColor: Temas.FondoOscuro,
        elevation: 0,
        title: const Text(
          "Nueva actividad",
          style: TextStyle(color: Temas.TextOscuro),
        ),
        iconTheme: const IconThemeData(color: Temas.TextOscuro),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // INPUT NOMBRE
            TextField(
              controller: _tituloCtrl,
              style: const TextStyle(color: Temas.TextOscuro),
              decoration: InputDecoration(
                hintText: "Nombre de la actividad",
                hintStyle: TextStyle(color: Temas.TextOscuro.withOpacity(0.5)),
                filled: true,
                fillColor: Temas.WidgetOscuro,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // HORA INICIO
            SwitchListTile(
              activeColor: Colors.white,
              activeTrackColor: const Color(0xFF04ED0C),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Temas.WidgetOscuro,
              contentPadding: EdgeInsets.zero,
              title: const Text(
                "Hora inicio",
                style: TextStyle(
                  color: Temas.TextOscuro,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                _horaInicio != null
                    ? "Hora: ${DateFormat("HH:mm").format(_horaInicio!)}"
                    : "Sin hora",
                style: const TextStyle(color: Colors.white70),
              ),
              value: _horaInicio != null,
              onChanged: (v) async {
                if (v) {
                  await _seleccionarHoraInicio();
                } else {
                  setState(() => _horaInicio = null);
                }
              },
            ),

            const SizedBox(height: 10),

            // HORA FIN
            SwitchListTile(
              activeColor: Colors.white,
              activeTrackColor: const Color(0xFF04ED0C),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Temas.WidgetOscuro,
              contentPadding: EdgeInsets.zero,
              title: const Text(
                "Hora fin",
                style: TextStyle(
                  color: Temas.TextOscuro,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                _horaFin != null
                    ? "Hora: ${DateFormat("HH:mm").format(_horaFin!)}"
                    : "Sin hora",
                style: const TextStyle(color: Colors.white70),
              ),
              value: _horaFin != null,
              onChanged: (v) async {
                if (v) {
                  await _seleccionarHoraFin();
                } else {
                  setState(() => _horaFin = null);
                }
              },
            ),

            const SizedBox(height: 20),

            const Text(
              "Descripción",
              style: TextStyle(
                color: Temas.TextOscuro,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: _descripcionCtrl,
              maxLines: 4,
              style: const TextStyle(color: Temas.TextOscuro),
              decoration: InputDecoration(
                hintText: "Descripción de la actividad",
                hintStyle: TextStyle(color: Temas.TextOscuro.withOpacity(0.5)),
                filled: true,
                fillColor: Temas.WidgetOscuro,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 25),

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
                maxCrossAxisExtent: 75, // MÁS CHICO
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, i) {
                final cat = _categorias[i];
                final selected = _categoriaSeleccionada == cat["label"];

                return GestureDetector(
                  onTap: () =>
                      setState(() => _categoriaSeleccionada = cat["label"]),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 4,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? Temas.AcentoColorOscuro.withOpacity(0.25)
                          : Temas.WidgetOscuro,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: selected
                            ? Temas.AcentoColorOscuro
                            : Colors.white24,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          cat["icon"],
                          size: 22, // ICONO MÁS CHICO
                          color: Temas.TextOscuro,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          cat["label"],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Temas.TextOscuro,
                            fontSize: 10, // TEXTO MÁS CHICO
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Temas.AcentoColorOscuro,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
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
}
