import 'package:cloud_firestore/cloud_firestore.dart';
import '../modelos/tarea_modelo.dart';

class TareasServicio {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Crear tarea
  Future<void> crearTarea(Tarea tarea) async {
    try {
      await _db.collection("tareas").add(tarea.aMapa());
    } catch (e) {
      throw Exception("Error al crear tarea: $e");
    }
  }

  /// Obtener tareas del usuario
  Stream<List<Tarea>> obtenerTareasUsuario(String usuarioId) {
    return _db
        .collection("tareas")
        .where("usuarioId", isEqualTo: usuarioId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Tarea.desdeMapa(doc.data(), doc.id);
          }).toList();
        });
  }

  /// Actualizar tarea
  Future<void> actualizarTarea(Tarea tarea) async {
    await _db.collection("tareas").doc(tarea.id).update(tarea.aMapa());
  }

  /// Borrar tarea
  Future<void> borrarTarea(String id) async {
    await _db.collection("tareas").doc(id).delete();
  }
}
