

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery/models/firebase_user_model.dart';

class FirebaseUserRepo {
  
  final CollectionReference _users = FirebaseFirestore.instance.collection("users");

  Stream<QuerySnapshot> getStream(){
    return _users.snapshots();
  }

  Future<DocumentReference> addUser(FirebaseUser user) async {
    return await _users.add(user.toJson());
  }

  void updateUser(FirebaseUser user){
    _users.doc(user.uid).update(user.toJson());
  }

  void deleteUser(FirebaseUser user){
    _users.doc(user.uid).delete();
  }


}