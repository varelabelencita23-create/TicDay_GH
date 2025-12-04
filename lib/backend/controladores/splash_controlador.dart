import '../servicios/usuario_servicio.dart';
import '../modelos/usuario_modelo.dart';

class SplashControlador {
  final UsuarioServicio _usuarioServicio = UsuarioServicio();

  /// Crear usuario si no existe
  Future<void> crearUsuarioSiNoExiste(String uid) async {
    final sub = _usuarioServicio.obtenerUsuario(uid).listen((usuario) async {
      if (usuario == null) {
        final nuevo = Usuario(
          id: uid,
          nombre: "Usuario",
          iconoAvatar: "default",
          tema: "claro",
        );
        await _usuarioServicio.guardarUsuario(nuevo);
      }
    });

    // Cancelamos para no dejar listeners colgados
    await Future.delayed(Duration(seconds: 1));
    await sub.cancel();
  }
}
