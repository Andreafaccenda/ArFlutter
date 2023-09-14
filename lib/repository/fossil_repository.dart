import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/fossil.dart';


class FossilService {

  final CollectionReference _fossilCollectionRef =
  FirebaseFirestore.instance.collection('Fossils');

  final _db = FirebaseFirestore.instance;

  Future<List<QueryDocumentSnapshot>> getFossils() async {
    var value = await _fossilCollectionRef.get();
    return value.docs;
  }
  Future<void> updateFossils(FossilModel fossile) async {
    await _db.collection("Fossils").doc(fossile.id).update(fossile.toJson());

  }




}