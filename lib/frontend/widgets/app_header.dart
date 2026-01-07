import 'package:flutter/material.dart';
import '../../backend/modelos/usuario_modelo.dart';
import '../../backend/estado/usuario_estado.dart';
import 'ios_header.dart';
import '../../frontend/vistas/perfil_vista.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMenuTap;
  final String uid;

  const AppHeader({super.key, required this.onMenuTap, required this.uid});

  @override
  Size get preferredSize => const Size.fromHeight(90);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UsuarioModelo?>(
      valueListenable: usuarioNotifier,
      builder: (context, usuario, _) {
        return IOSHeader(
          nombre: usuario?.nombre ?? "",
          avatar: usuario?.iconoAvatar ?? "",
          onMenuTap: onMenuTap,
          onAvatarTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PerfilVista(uid: uid)),
            );
          },
        );
      },
    );
  }
}
