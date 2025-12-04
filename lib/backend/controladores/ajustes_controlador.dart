import '../servicios/usuario_servicio.dart';

class AjustesControlador {
  final UsuarioServicio _usuarioServicio = UsuarioServicio();

  /// Cambiar nombre
  Future<void> actualizarNombre(String uid, String nombre) async {
    await _usuarioServicio.actualizarNombre(uid, nombre);
  }

  /// Cambiar icono/avatar
  Future<void> actualizarIcono(String uid, String icono) async {
    await _usuarioServicio.actualizarIcono(uid, icono);
  }

  /// Cambiar tema (dark/light)
  Future<void> actualizarTema(String uid, String modo) async {
    await _usuarioServicio.actualizarTema(uid, modo);
  }

  /// Borrar tareas (lo implementamos después)
  Future<void> borrarTodasLasTareas() async {
    // futuro servicio dedicado
  }
}
