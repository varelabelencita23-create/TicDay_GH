import 'package:flutter/material.dart';

import '../modelos/usuario_modelo.dart';
import '../servicios/usuario_servicio.dart';
import '../estado/usuario_estado.dart';
import '../estado/tema_estado.dart';

class UsuarioControlador {
  static final UsuarioControlador _instancia = UsuarioControlador._();
  factory UsuarioControlador() => _instancia;
  UsuarioControlador._();

  UsuarioModelo? get usuario => usuarioNotifier.value;

  // ================= CARGAR USUARIO =================
  Future<void> cargarUsuario(String uid) async {
    final usuario = await UsuarioServicio.obtenerUsuario(uid);
    usuarioNotifier.value = usuario;

    if (usuario != null) {
      temaNotifier.value = usuario.tema == 'light'
          ? ThemeMode.light
          : ThemeMode.dark;
    }
  }

  // ================= ACTUALIZAR USUARIO =================
  Future<void> actualizarUsuario({
    required String uid,
    required String nombre,
    String? avatar,
    String tema = 'dark',
  }) async {
    final usuario = UsuarioModelo(
      id: uid,
      nombre: nombre,
      iconoAvatar: avatar,
      tema: tema,
    );

    await UsuarioServicio.guardarUsuario(usuario);

    usuarioNotifier.value = usuario;
    temaNotifier.value = tema == 'light' ? ThemeMode.light : ThemeMode.dark;
  }
}
