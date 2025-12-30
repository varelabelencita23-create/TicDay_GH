class PerfilModelo {
  final String nombre;
  final String avatar;

  PerfilModelo({required this.nombre, required this.avatar});

  Map<String, dynamic> toMap() {
    return {'nombre': nombre, 'avatar': avatar};
  }

  factory PerfilModelo.fromMap(Map<String, dynamic> map) {
    return PerfilModelo(
      nombre: map['nombre'] as String,
      avatar: map['avatar'] as String,
    );
  }
}
