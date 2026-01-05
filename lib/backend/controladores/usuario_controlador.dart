import '../modelos/usuario_modelo.dart';
import '../servicios/usuario_servicio.dart';
import '../estado/usuario_estado.dart';

class UsuarioControlador {
  static final UsuarioControlador _instancia = UsuarioControlador._();
  factory UsuarioControlador() => _instancia;
  UsuarioControlador._();

  UsuarioModelo? get usuario => usuarioNotifier.value;

  Future<void> cargarUsuario(String uid) async {
    final usuario = await UsuarioServicio.obtenerUsuario(uid);
    usuarioNotifier.value = usuario;
  }

  Future<void> actualizarUsuario({
    required String uid,
    required String nombre,
    String? avatar,
    String tema = 'light',
  }) async {
    final usuario = UsuarioModelo(
      id: uid,
      nombre: nombre,
      iconoAvatar: avatar,
      tema: tema,
    );

    await UsuarioServicio.guardarUsuario(usuario);
    usuarioNotifier.value = usuario;
  }
}
