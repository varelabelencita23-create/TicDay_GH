import 'package:flutter/material.dart';
import '../../backend/modelos/usuario_modelo.dart';
import '../../backend/estado/usuario_estado.dart';
import 'ios_header.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMenuTap;

  const AppHeader({super.key, required this.onMenuTap});

  @override
  Size get preferredSize => const Size.fromHeight(92);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UsuarioModelo?>(
      valueListenable: usuarioNotifier,
      builder: (context, usuario, _) {
        return IOSHeader(
          nombre: usuario?.nombre ?? "Hola",
          avatar: usuario?.iconoAvatar ?? "",
          onMenuTap: onMenuTap,
        );
      },
    );
  }
}
