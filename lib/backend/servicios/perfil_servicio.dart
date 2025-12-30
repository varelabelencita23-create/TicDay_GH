import 'package:shared_preferences/shared_preferences.dart';
import '../modelos/perfil_modelo.dart';
import '../estado/perfil_estado.dart';

class PerfilServicio {
  static const _keyNombre = 'perfil_nombre';
  static const _keyAvatar = 'perfil_avatar';

  static Future<PerfilModelo?> obtenerPerfil() async {
    final prefs = await SharedPreferences.getInstance();

    final nombre = prefs.getString(_keyNombre);
    final avatar = prefs.getString(_keyAvatar);

    if (nombre == null || avatar == null) return null;

    final perfil = PerfilModelo(nombre: nombre, avatar: avatar);

    perfilNotifier.value = perfil;

    return perfil;
  }

  static Future<void> guardarPerfil(PerfilModelo perfil) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_keyNombre, perfil.nombre);
    await prefs.setString(_keyAvatar, perfil.avatar);

    perfilNotifier.value = perfil;
  }
}
