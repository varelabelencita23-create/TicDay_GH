import '../servicios/usuario_servicio.dart';
import '../estado/usuario_estado.dart';
import '../modelos/usuario_modelo.dart';

class AjustesControlador {
  /// Cambiar nombre
  Future<void> actualizarNombre(String uid, String nombre) async {
    final usuario = usuarioNotifier.value;
    if (usuario == null) return;

    final actualizado = UsuarioModelo(
      id: uid,
      nombre: nombre,
      iconoAvatar: usuario.iconoAvatar,
      tema: usuario.tema,
    );

    await UsuarioServicio.guardarUsuario(actualizado);
  }

  /// Cambiar icono/avatar
  Future<void> actualizarIcono(String uid, String icono) async {
    final usuario = usuarioNotifier.value;
    if (usuario == null) return;

    final actualizado = UsuarioModelo(
      id: uid,
      nombre: usuario.nombre,
      iconoAvatar: icono,
      tema: usuario.tema,
    );

    await UsuarioServicio.guardarUsuario(actualizado);
  }

  /// Cambiar tema (dark/light)
  Future<void> actualizarTema(String uid, String tema) async {
    final usuario = usuarioNotifier.value;
    if (usuario == null) return;

    final actualizado = UsuarioModelo(
      id: uid,
      nombre: usuario.nombre,
      iconoAvatar: usuario.iconoAvatar,
      tema: tema,
    );

    await UsuarioServicio.guardarUsuario(actualizado);
  }

  Future<void> borrarTodasLasTareas() async {
    // después lo conectamos con tareas_servicio
  }
}
