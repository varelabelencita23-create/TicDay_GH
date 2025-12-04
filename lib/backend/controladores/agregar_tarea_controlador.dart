import '../servicios/tareas_servicio.dart';
import '../modelos/tarea_modelo.dart';

class AgregarTareaControlador {
  final TareasServicio _tareasServicio = TareasServicio();

  /// Crear tarea
  Future<void> crearTarea(Tarea tarea) async {
    await _tareasServicio.crearTarea(tarea);
  }

  /// Editar tarea
  Future<void> actualizarTarea(Tarea tarea) async {
    await _tareasServicio.actualizarTarea(tarea);
  }

  /// Calcular duración (según inicio/fin)
  Duration calcularDuracion(DateTime inicio, DateTime fin) {
    return fin.difference(inicio);
  }
}
