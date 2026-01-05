import 'package:cloud_firestore/cloud_firestore.dart';
import '../modelos/tarea_modelo.dart';

class TareasServicio {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get _ref => _db.collection('tareas');

  /// Crear tarea
  Future<void> crearTarea(Tarea tarea) async {
    try {
      await _ref.add(tarea.aMapa());
    } catch (e) {
      throw Exception("Error al crear tarea: $e");
    }
  }

  /// Obtener tareas del usuario
  Stream<List<Tarea>> obtenerTareasUsuario(String usuarioId) {
    return _ref
        .where('usuarioId', isEqualTo: usuarioId)
        .orderBy('creadoEl', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Tarea.desdeMapa(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();
        });
  }

  /// Actualizar tarea
  Future<void> actualizarTarea(Tarea tarea) async {
    await _ref.doc(tarea.id).update(tarea.aMapa());
  }

  /// Borrar tareas
  Future<void> borrarTarea(String id) async {
    await _ref.doc(id).delete();
  }
}
