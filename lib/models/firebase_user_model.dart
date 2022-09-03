import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUser {
  String uid;
  String name;
  String email;
  String phone;
  String status;
  String client;
  GeoPoint location;

  FirebaseUser({
     required this.uid,
     required this.name,
     required this.email,
     required this.phone,
     this.status="",
     this.client="",
     this.location= const GeoPoint(0,0),
  });

  factory FirebaseUser.fromJson(Map<String, dynamic> json) {
    return FirebaseUser(
      uid: json["uid"],
      name: json["name"],
      email: json["email"],
      phone: json["phone"],
      status: json["status"],
      client: json["client"],
      location: json["location"]
    );
  }

   Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["uid"] = uid;
    data["name"] = name;
    data["email"] = email;
    data["phone"] = phone;
    data["status"] = status;
    data["client"] = client;
    data["location"] = location;

    return data;
  }

  factory FirebaseUser.fromSnapshot(DocumentSnapshot snapshot) {
    final newUser = FirebaseUser.fromJson(snapshot.data() as Map<String, dynamic>);
    newUser.uid = snapshot.reference.id;

    return newUser;
  }



}