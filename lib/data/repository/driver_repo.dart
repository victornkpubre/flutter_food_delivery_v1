
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery/models/firebase_user_model.dart';


class DriverRepo {
  final CollectionReference _users = FirebaseFirestore.instance.collection("users");
  

  

  //returns all online drivers for now
  Future<List<FirebaseUser>> getDriversByZone(int zone) async{
    return [];
  }

  //send request to firebase user and returns the user's status stream
  void requestDelivery(FirebaseUser driver) {

  }


}