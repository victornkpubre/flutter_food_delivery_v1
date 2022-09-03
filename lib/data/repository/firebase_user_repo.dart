

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery/models/firebase_user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseUserRepo {
  //final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference _users = FirebaseFirestore.instance.collection("users");

  Stream<QuerySnapshot> getStream(){
    return _users.snapshots();
  }


  Future<DocumentSnapshot> getUser(String uid) async {
    return await _users.doc(uid).get();
  }

  
  Future<void> createUser(FirebaseUser user) async {
    print("${_users.get().toString()}");
    await _users.doc(user.uid).set(user.toJson());
    print("adding user ${user.toJson()}");
  }

  Future<DocumentReference> addUser(FirebaseUser user) async {
    

    print("adding user ${user.toJson()}");
    return await _users.add(user.toJson());
  }

  void updateUser(FirebaseUser user){
    _users.doc(user.uid).update(user.toJson());
  }

  void deleteUser(FirebaseUser user){
    _users.doc(user.uid).delete();
  }


}