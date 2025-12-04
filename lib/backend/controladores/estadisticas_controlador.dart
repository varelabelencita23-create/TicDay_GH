import '../servicios/tareas_servicio.dart';
import '../modelos/tarea_modelo.dart';

class EstadisticasControlador {
  final TareasServicio _tareasServicio = TareasServicio();

  /// ---------- % del día ----------
  Stream<double> obtenerEstadisticaDiaria(String usuarioId) {
    return _tareasServicio.obtenerTareasUsuario(usuarioId).map((tareas) {
      final hoy = DateTime.now();

      final delDia = tareas.where((t) {
        return t.creadoEl.year == hoy.year &&
            t.creadoEl.month == hoy.month &&
            t.creadoEl.day == hoy.day;
      }).toList();

      if (delDia.isEmpty) return 0;

      final completadas = delDia.where((t) => t.completado).length;
      return completadas / delDia.length;
    });
  }

  /// ---------- % semanal (7 días) ----------
  Stream<List<double>> obtenerEstadisticaSemanal(String usuarioId) {
    return _tareasServicio.obtenerTareasUsuario(usuarioId).map((tareas) {
      final hoy = DateTime.now();
      final inicioSemana = hoy.subtract(Duration(days: hoy.weekday - 1));

      List<double> porcentajes = [];

      for (int i = 0; i < 7; i++) {
        final dia = inicioSemana.add(Duration(days: i));

        final tareasDia = tareas.where((t) {
          return t.creadoEl.year == dia.year &&
              t.creadoEl.month == dia.month &&
              t.creadoEl.day == dia.day;
        }).toList();

        if (tareasDia.isEmpty) {
          porcentajes.add(0);
        } else {
          final comp = tareasDia.where((t) => t.completado).length;
          porcentajes.add(comp / tareasDia.length);
        }
      }

      return porcentajes;
    });
  }

  /// ---------- Datos mensuales ----------
  Stream<List<double>> obtenerEstadisticaMensual(
    String usuarioId,
    int mes,
    int anio,
  ) {
    return _tareasServicio.obtenerTareasUsuario(usuarioId).map((tareas) {
      final diasMes = DateTime(anio, mes + 1, 0).day;
      List<double> porcentajes = [];

      for (int d = 1; d <= diasMes; d++) {
        final tareasDia = tareas.where((t) {
          return t.creadoEl.year == anio &&
              t.creadoEl.month == mes &&
              t.creadoEl.day == d;
        }).toList();

        if (tareasDia.isEmpty) {
          porcentajes.add(0);
        } else {
          final comp = tareasDia.where((t) => t.completado).length;
          porcentajes.add(comp / tareasDia.length);
        }
      }

      return porcentajes;
    });
  }
}
