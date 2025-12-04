import 'package:cloud_firestore/cloud_firestore.dart';
import '../modelos/tarea_modelo.dart';
import 'firebase_servicio.dart';

class TareasServicio {
  final _firebase = FirebaseServicio();

  /// Crear tarea
  Future<void> crearTarea(Tarea tarea) async {
    try {
      await _firebase.coleccion("tareas").doc(tarea.id).set(tarea.aMapa());
    } catch (e) {
      throw Exception("Error al crear tarea: $e");
    }
  }

  /// Obtener todas las tareas del usuario
  Stream<List<Tarea>> obtenerTareasUsuario(String usuarioId) {
    try {
      return _firebase
          .coleccion("tareas")
          .where("usuarioId", isEqualTo: usuarioId)
          .orderBy("creadoEl", descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              return Tarea.desdeMapa(
                doc.data() as Map<String, dynamic>,
                doc.id,
              );
            }).toList();
          });
    } catch (e) {
      throw Exception("Error al obtener tareas: $e");
    }
  }

  /// Actualizar tarea
  Future<void> actualizarTarea(Tarea tarea) async {
    try {
      await _firebase.coleccion("tareas").doc(tarea.id).update(tarea.aMapa());
    } catch (e) {
      throw Exception("Error al actualizar tarea: $e");
    }
  }

  /// Borrar tarea
  Future<void> borrarTarea(String id) async {
    try {
      await _firebase.coleccion("tareas").doc(id).delete();
    } catch (e) {
      throw Exception("Error al borrar tarea: $e");
    }
  }
}
