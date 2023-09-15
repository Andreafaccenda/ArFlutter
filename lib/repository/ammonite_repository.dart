

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/ammonite.dart';

class AmmoniteService {

  final CollectionReference _ammoniteCollectionRef =
  FirebaseFirestore.instance.collection('ammonite');

  final _db = FirebaseFirestore.instance;

  Future<List<QueryDocumentSnapshot>> getAmmoniti() async {
    var value = await _ammoniteCollectionRef.get();
    return value.docs;
  }
  Future<void> addAmmonite(Ammonite ammonite) async {
    await  _ammoniteCollectionRef
        .doc()
        .set(ammonite.toJson());

  }




}