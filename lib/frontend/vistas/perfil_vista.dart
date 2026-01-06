import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ticday/backend/controladores/usuario_controlador.dart';

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

  final List<String> _avatars = List.generate(
    20,
    (index) => 'avatar${index + 1}.png',
  );

  @override
  void initState() {
    super.initState();
    _cargarUsuario();
  }

  Future<void> _cargarUsuario() async {
    try {
      await _controlador.cargarUsuario(widget.uid);

      final usuario = _controlador.usuario;
      if (usuario != null) {
        _nombreController.text = usuario.nombre;
        _avatarSeleccionado = usuario.iconoAvatar;
      }
    } catch (e) {
      debugPrint('Error cargando usuario: $e');
    } finally {
      if (mounted) {
        setState(() => _cargando = false);
      }
    }
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

    await _controlador.actualizarUsuario(
      uid: widget.uid,
      nombre: nombre,
      avatar: _avatarSeleccionado!,
      tema: _controlador.usuario?.tema ?? 'light',
    );

    if (!mounted) return;
    Navigator.pop(context);
  }

  void _mostrarAlerta(String titulo, String mensaje) {
    final theme = Theme.of(context);

    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text(titulo),
        content: Text(mensaje),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text(
              'OK',
              style: TextStyle(color: theme.colorScheme.primary),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_cargando) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: const Center(child: CupertinoActivityIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CupertinoNavigationBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        border: null,
        middle: Text(
          'Perfil',
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: GestureDetector(
          onTap: _guardarPerfil,
          child: Text(
            'Guardar',
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: theme.colorScheme.primary, width: 2),
              ),
              child: ClipOval(
                child: _avatarSeleccionado != null
                    ? Image.asset(
                        'assets/avatars/$_avatarSeleccionado',
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        CupertinoIcons.person_fill,
                        size: 52,
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(
                          0.4,
                        ),
                      ),
              ),
            ),
          ),

          const SizedBox(height: 28),

          CupertinoFormSection.insetGrouped(
            backgroundColor: theme.scaffoldBackgroundColor,
            children: [
              CupertinoTextFormFieldRow(
                controller: _nombreController,
                placeholder: 'Tu nombre',
                style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                placeholderStyle: TextStyle(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.4),
                ),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Text(
            'Elegí tu avatar',
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

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
                      color: seleccionado
                          ? theme.colorScheme.primary
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
    );
  }
}
