import '../servicios/tareas_servicio.dart';
import '../servicios/usuario_servicio.dart';
import '../modelos/tarea_modelo.dart';
import '../modelos/usuario_modelo.dart';

class InicioControlador {
  final TareasServicio _tareasServicio = TareasServicio();
  final UsuarioServicio _usuarioServicio = UsuarioServicio();

  /// Tareas del día (máx 20)
  Stream<List<Tarea>> obtenerTareasDelDia(String usuarioId) {
    return _tareasServicio.obtenerTareasUsuario(usuarioId).map((tareas) {
      final hoy = DateTime.now();

      return tareas
          .where(
            (t) =>
                t.creadoEl.year == hoy.year &&
                t.creadoEl.month == hoy.month &&
                t.creadoEl.day == hoy.day,
          )
          .take(20)
          .toList();
    });
  }

  /// Tareas NO completadas de días anteriores
  Stream<List<Tarea>> obtenerTareasNoCompletadas(String usuarioId) {
    return _tareasServicio.obtenerTareasUsuario(usuarioId).map((tareas) {
      final hoy = DateTime.now();

      return tareas.where((t) {
        final esHoy =
            t.creadoEl.year == hoy.year &&
            t.creadoEl.month == hoy.month &&
            t.creadoEl.day == hoy.day;

        return !esHoy && t.completado == false;
      }).toList();
    });
  }

  /// Actualizar estado (completar o descompletar)
  Future<void> actualizarEstadoTarea(Tarea tarea, bool completado) async {
    final tareaActualizada = tarea.copiaCon(
      completado: completado,
      horaFin: completado ? DateTime.now() : null,
    );

    await _tareasServicio.actualizarTarea(tareaActualizada);
  }

  /// Eliminar tarea
  Future<void> eliminarTarea(String id) async {
    await _tareasServicio.borrarTarea(id);
  }

  /// Obtener usuario (nombre, avatar, tema)
  Stream<Usuario?> obtenerNombreUsuario(String uid) {
    return _usuarioServicio.obtenerUsuario(uid);
  }
}
