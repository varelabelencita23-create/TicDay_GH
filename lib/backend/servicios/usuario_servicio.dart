import 'package:shared_preferences/shared_preferences.dart';
import '../modelos/usuario_modelo.dart';
import '../estado/usuario_estado.dart';

class UsuarioServicio {
  static const _keyNombre = 'usuario_nombre';
  static const _keyAvatar = 'usuario_avatar';
  static const _keyTema = 'usuario_tema';

  static Future<UsuarioModelo?> obtenerUsuario(String uid) async {
    final prefs = await SharedPreferences.getInstance();

    final nombre = prefs.getString(_keyNombre);
    if (nombre == null) return null;

    final avatar = prefs.getString(_keyAvatar);
    final tema = prefs.getString(_keyTema) ?? 'light';

    final usuario = UsuarioModelo(
      id: uid,
      nombre: nombre,
      iconoAvatar: avatar,
      tema: tema,
    );

    usuarioNotifier.value = usuario;
    return usuario;
  }

  static Future<void> guardarUsuario(UsuarioModelo usuario) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_keyNombre, usuario.nombre);
    if (usuario.iconoAvatar != null) {
      await prefs.setString(_keyAvatar, usuario.iconoAvatar!);
    }
    await prefs.setString(_keyTema, usuario.tema);

    usuarioNotifier.value = usuario;
  }
}
