import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ticday/backend/controladores/perfil_controlador.dart';

class PerfilVista extends StatefulWidget {
  const PerfilVista({super.key});

  @override
  State<PerfilVista> createState() => _PerfilVistaState();
}

class _PerfilVistaState extends State<PerfilVista> {
  final PerfilControlador _controlador = PerfilControlador();
  final TextEditingController _nombreController = TextEditingController();

  String? _avatarSeleccionado;
  bool _cargando = true;

  final List<String> _avatars = List.generate(
    20,
    (index) => 'avatar${index + 1}.png',
  );

  @override
  void initState() {
    super.initState();
    _cargarPerfil();
  }

  Future<void> _cargarPerfil() async {
    await _controlador.cargarPerfil();
    final perfil = _controlador.perfil;

    if (perfil != null) {
      _nombreController.text = perfil.nombre;
      _avatarSeleccionado = perfil.avatar.isNotEmpty ? perfil.avatar : null;
    }

    setState(() => _cargando = false);
  }

  Future<void> _guardarPerfil() async {
    final nombre = _nombreController.text.trim();

    if (nombre.isEmpty) {
      _mostrarAlerta('Falta tu nombre', 'Ingresá tu nombre para continuar.');
      return;
    }

    if (_avatarSeleccionado == null) {
      _mostrarAlerta('Elegí un avatar', 'Seleccioná uno antes de guardar.');
      return;
    }

    await _controlador.actualizarPerfil(
      nombre: nombre,
      avatar: _avatarSeleccionado!,
    );

    if (!mounted) return;
    Navigator.pop(context);
  }

  void _mostrarAlerta(String titulo, String mensaje) {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text(titulo),
        content: Text(mensaje),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CupertinoActivityIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CupertinoNavigationBar(
        backgroundColor: const Color(0xFF1C1C1E),
        middle: const Text('Perfil', style: TextStyle(color: Colors.white)),
        trailing: GestureDetector(
          onTap: _guardarPerfil,
          child: const Text(
            'Guardar',
            style: TextStyle(
              color: CupertinoColors.activeBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ================= AVATAR PRINCIPAL =================
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: ClipOval(
                child: _avatarSeleccionado != null
                    ? Image.asset(
                        'assets/avatars/$_avatarSeleccionado',
                        fit: BoxFit.cover,
                      )
                    : const Icon(
                        CupertinoIcons.person_fill,
                        size: 52,
                        color: Colors.white38,
                      ),
              ),
            ),
          ),

          const SizedBox(height: 28),

          // ================= INPUT =================
          CupertinoFormSection.insetGrouped(
            backgroundColor: Colors.black,
            children: [
              CupertinoTextFormFieldRow(
                controller: _nombreController,
                placeholder: 'Tu nombre',
                style: const TextStyle(color: Colors.white),
                placeholderStyle: const TextStyle(color: Colors.white38),
                decoration: const BoxDecoration(
                  color: Color(0xFF2C2C2E),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          const Text(
            'Elegí tu avatar',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          // ================= GRID =================
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _avatars.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
            ),
            itemBuilder: (context, index) {
              final avatar = _avatars[index];
              final seleccionado = avatar == _avatarSeleccionado;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _avatarSeleccionado = avatar;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: seleccionado ? Colors.white : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/avatars/$avatar',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
