class Usuario {
  final String id;
  final String nombre;
  final String? iconoAvatar;
  final String tema;

  Usuario({
    required this.id,
    required this.nombre,
    this.iconoAvatar,
    required this.tema,
  });

  factory Usuario.desdeMapa(Map<String, dynamic> mapa, String id) {
    return Usuario(
      id: id,
      nombre: mapa["nombre"],
      iconoAvatar: mapa["iconoAvatar"],
      tema: mapa["tema"] ?? "light",
    );
  }

  Map<String, dynamic> aMapa() {
    return {"nombre": nombre, "iconoAvatar": iconoAvatar, "tema": tema};
  }
}
