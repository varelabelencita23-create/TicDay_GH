import 'package:cloud_firestore/cloud_firestore.dart';
import '../modelos/usuario_modelo.dart';
import 'firebase_servicio.dart';

class UsuarioServicio {
  final _firebase = FirebaseServicio();

  /// Crear o actualizar usuario
  Future<void> guardarUsuario(Usuario usuario) async {
    try {
      await _firebase
          .coleccion("usuarios")
          .doc(usuario.id)
          .set(usuario.aMapa(), SetOptions(merge: true));
    } catch (e) {
      throw Exception("Error al guardar usuario: $e");
    }
  }

  /// Obtener datos de usuario
  Stream<Usuario?> obtenerUsuario(String usuarioId) {
    try {
      return _firebase.coleccion("usuarios").doc(usuarioId).snapshots().map((
        doc,
      ) {
        if (doc.exists) {
          return Usuario.desdeMapa(doc.data() as Map<String, dynamic>, doc.id);
        }
        return null;
      });
    } catch (e) {
      throw Exception("Error al obtener usuario: $e");
    }
  }

  /// Actualizar solo el nombre
  Future<void> actualizarNombre(String id, String nuevoNombre) async {
    try {
      await _firebase.coleccion("usuarios").doc(id).update({
        "nombre": nuevoNombre,
      });
    } catch (e) {
      throw Exception("Error al actualizar nombre: $e");
    }
  }

  /// Actualizar tema (dark/light)
  Future<void> actualizarTema(String id, String modo) async {
    try {
      await _firebase.coleccion("usuarios").doc(id).update({"tema": modo});
    } catch (e) {
      throw Exception("Error al actualizar tema: $e");
    }
  }

  /// Actualizar icono de usuario
  Future<void> actualizarIcono(String id, String icono) async {
    try {
      await _firebase.coleccion("usuarios").doc(id).update({
        "iconoAvatar": icono,
      });
    } catch (e) {
      throw Exception("Error al actualizar icono: $e");
    }
  }
}
