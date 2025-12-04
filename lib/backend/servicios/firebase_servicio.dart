import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServicio {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  FirebaseFirestore get db => _db;

  CollectionReference coleccion(String nombre) {
    return _db.collection(nombre);
  }
}
