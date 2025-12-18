class Tarea {
  final String id;
  final String titulo;
  final String? descripcion;
  final DateTime? horaInicio;
  final DateTime? horaFin;
  final int? duracionMinutos;
  final String? icono;
  final bool completado;
  final DateTime creadoEl;
  final String usuarioId;

  Tarea({
    required this.id,
    required this.titulo,
    this.descripcion,
    this.horaInicio,
    this.horaFin,
    this.duracionMinutos,
    this.icono,
    required this.completado,
    required this.creadoEl,
    required this.usuarioId,
  });

  /// ---------- FROM MAP ----------
  factory Tarea.desdeMapa(Map<String, dynamic> mapa, String id) {
    return Tarea(
      id: id,
      titulo: mapa["titulo"],
      descripcion: mapa["descripcion"], // ← agregado
      horaInicio: mapa["horaInicio"] != null
          ? DateTime.parse(mapa["horaInicio"])
          : null,
      horaFin: mapa["horaFin"] != null ? DateTime.parse(mapa["horaFin"]) : null,
      duracionMinutos: mapa["duracionMinutos"],
      icono: mapa["icono"],
      completado: mapa["completado"] ?? false,
      creadoEl: DateTime.parse(mapa["creadoEl"]),
      usuarioId: mapa["usuarioId"],
    );
  }

  /// ---------- TO MAP ----------
  Map<String, dynamic> aMapa() {
    return {
      "titulo": titulo,
      "descripcion": descripcion, // ← agregado
      "horaInicio": horaInicio?.toIso8601String(),
      "horaFin": horaFin?.toIso8601String(),
      "duracionMinutos": duracionMinutos,
      "icono": icono,
      "completado": completado,
      "creadoEl": creadoEl.toIso8601String(),
      "usuarioId": usuarioId,
    };
  }

  /// ---------- COPIA CON ----------
  Tarea copiaCon({
    String? id,
    String? titulo,
    String? descripcion, // ← agregado
    DateTime? horaInicio,
    DateTime? horaFin,
    int? duracionMinutos,
    String? icono,
    bool? completado,
    DateTime? creadoEl,
    String? usuarioId,
  }) {
    return Tarea(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion, // ← agregado
      horaInicio: horaInicio ?? this.horaInicio,
      horaFin: horaFin ?? this.horaFin,
      duracionMinutos: duracionMinutos ?? this.duracionMinutos,
      icono: icono ?? this.icono,
      completado: completado ?? this.completado,
      creadoEl: creadoEl ?? this.creadoEl,
      usuarioId: usuarioId ?? this.usuarioId,
    );
  }
}
