import '../modelos/tarea_modelo.dart';
import '../servicios/tareas_servicio.dart';

class AgregarTareaControlador {
  final TareasServicio _servicio = TareasServicio();

  Future<void> crearTarea({
    required String titulo,
    String? descripcion,
    DateTime? horaInicio,
    DateTime? horaFin,
    int? duracionMinutos,
    String? icono,
    required String usuarioId,
  }) async {
    final tarea = Tarea(
      id: '', // Firestore lo genera
      titulo: titulo,
      descripcion: descripcion,
      horaInicio: horaInicio,
      horaFin: horaFin,
      duracionMinutos: duracionMinutos,
      icono: icono,
      completado: false,
      creadoEl: DateTime.now(),
      usuarioId: usuarioId,
    );

    await _servicio.crearTarea(tarea);
  }

  Duration calcularDuracion(DateTime inicio, DateTime fin) {
    return fin.difference(inicio);
  }
}
