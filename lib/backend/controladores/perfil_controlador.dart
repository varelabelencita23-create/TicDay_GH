import 'package:flutter/foundation.dart';
import '../modelos/perfil_modelo.dart';
import '../servicios/perfil_servicio.dart';

class PerfilControlador {
  static final PerfilControlador _instancia = PerfilControlador._();
  factory PerfilControlador() => _instancia;
  PerfilControlador._();

  final ValueNotifier<PerfilModelo?> perfilNotifier =
      ValueNotifier<PerfilModelo?>(null);

  PerfilModelo? get perfil => perfilNotifier.value;

  Future<void> cargarPerfil() async {
    final perfil = await PerfilServicio.obtenerPerfil();
    perfilNotifier.value = perfil;
  }

  Future<void> actualizarPerfil({
    required String nombre,
    required String avatar,
  }) async {
    final perfil = PerfilModelo(nombre: nombre, avatar: avatar);

    await PerfilServicio.guardarPerfil(perfil);

    perfilNotifier.value = perfil;
  }
}
