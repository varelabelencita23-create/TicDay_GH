import '../servicios/usuario_servicio.dart';
import '../modelos/usuario_modelo.dart';

class SplashControlador {
  /// Crear usuario si no existe
  Future<void> crearUsuarioSiNoExiste(String uid) async {
    final usuario = await UsuarioServicio.obtenerUsuario(uid);

    if (usuario == null) {
      final nuevo = UsuarioModelo(
        id: uid,
        nombre: "Usuario",
        iconoAvatar: "default",
        tema: "light",
      );

      await UsuarioServicio.guardarUsuario(nuevo);
    }
  }
}
