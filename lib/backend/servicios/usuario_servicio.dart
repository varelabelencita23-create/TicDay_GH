import 'package:cloud_firestore/cloud_firestore.dart';
import '../modelos/usuario_modelo.dart';
import '../estado/usuario_estado.dart';

class UsuarioServicio {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _coleccion = 'usuarios';

  static Future<UsuarioModelo?> obtenerUsuario(String uid) async {
    final doc = await _db.collection(_coleccion).doc(uid).get();

    if (!doc.exists) return null;

    final usuario = UsuarioModelo.desdeMapa(
      doc.data() as Map<String, dynamic>,
      doc.id,
    );

    usuarioNotifier.value = usuario;
    return usuario;
  }

  static Future<void> guardarUsuario(UsuarioModelo usuario) async {
    await _db
        .collection(_coleccion)
        .doc(usuario.id)
        .set(usuario.aMapa(), SetOptions(merge: true));

    usuarioNotifier.value = usuario;
  }
}
