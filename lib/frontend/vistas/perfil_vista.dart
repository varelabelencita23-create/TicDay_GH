import 'package:flutter/material.dart';
import 'package:ticday/backend/controladores/usuario_controlador.dart';
import 'package:ticday/frontend/temas/temas.dart';

class PerfilVista extends StatefulWidget {
  final String uid;

  const PerfilVista({super.key, required this.uid});

  @override
  State<PerfilVista> createState() => _PerfilVistaState();
}

class _PerfilVistaState extends State<PerfilVista> {
  final UsuarioControlador _controlador = UsuarioControlador();
  final TextEditingController _nombreController = TextEditingController();

  String? _avatarSeleccionado;
  bool _cargando = true;

  final List<String> _avatars = List.generate(20, (i) => 'avatar${i + 1}.png');

  @override
  void initState() {
    super.initState();
    _cargarUsuario();
  }

  Future<void> _cargarUsuario() async {
    await _controlador.cargarUsuario(widget.uid);
    final usuario = _controlador.usuario;

    if (usuario != null) {
      _nombreController.text = usuario.nombre;
      _avatarSeleccionado = usuario.iconoAvatar;
    }

    if (mounted) setState(() => _cargando = false);
  }

  Future<void> _guardarPerfil() async {
    if (_nombreController.text.trim().isEmpty) {
      _alerta("Falta tu nombre", "Ingresá tu nombre para continuar");
      return;
    }

    if (_avatarSeleccionado == null) {
      _alerta("Elegí un avatar", "Seleccioná uno antes de guardar");
      return;
    }

    await _controlador.actualizarUsuario(
      uid: widget.uid,
      nombre: _nombreController.text.trim(),
      avatar: _avatarSeleccionado!,
      tema: _controlador.usuario?.tema ?? 'light',
    );

    if (mounted) Navigator.pop(context);
  }

  void _alerta(String titulo, String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(titulo),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "OK",
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Temas.AcentoColorOscuro
                    : Temas.AcentoColorClaro,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final fondo = isDark ? Temas.FondoOscuro : Temas.FondoClaro;
    final card = isDark ? Temas.WidgetOscuro : Temas.WidgetClaro;
    final texto = isDark ? Temas.TextOscuro : Temas.TextoClaro;
    final acento = isDark ? Temas.AcentoColorOscuro : Temas.AcentoColorClaro;

    if (_cargando) {
      return Theme(
        data: Theme.of(context),
        child: const Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return Theme(
      data: Theme.of(context), // 🔥 ESTO ES LA CLAVE
      child: Scaffold(
        backgroundColor: fondo,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: fondo,
          foregroundColor: texto,
          title: const Text("Perfil"),
          actions: [
            TextButton(
              onPressed: _guardarPerfil,
              child: Text(
                "Guardar",
                style: TextStyle(color: acento, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: card,
                  border: Border.all(
                    color: _avatarSeleccionado != null
                        ? (isDark ? Colors.white : Colors.black)
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: _avatarSeleccionado != null
                      ? Image.asset(
                          'assets/avatars/$_avatarSeleccionado',
                          fit: BoxFit.cover,
                        )
                      : Icon(
                          Icons.person_rounded,
                          size: 54,
                          color: texto.withOpacity(0.4),
                        ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                controller: _nombreController,
                style: TextStyle(color: texto),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: "Tu nombre",
                  labelStyle: TextStyle(color: texto.withOpacity(0.6)),
                ),
              ),
            ),

            const SizedBox(height: 32),

            Text(
              "Elegí tu avatar",
              style: TextStyle(
                color: texto,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 16),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _avatars.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
              ),
              itemBuilder: (_, i) {
                final avatar = _avatars[i];
                final selected = avatar == _avatarSeleccionado;

                return GestureDetector(
                  onTap: () => setState(() => _avatarSeleccionado = avatar),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selected
                            ? (isDark ? Colors.white : Colors.black)
                            : Colors.transparent,
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
      ),
    );
  }
}
