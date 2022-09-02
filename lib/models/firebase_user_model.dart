import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUser {
  String? uid;
  String? name;
  String? email;
  String? phone;
  String? status;
  String? client;
  GeoPoint? location;

  FirebaseUser({
     this.uid,
     this.name,
     this.email,
     this.phone,
     this.status,
     this.client,
     this.location,
     
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
    data["uid"] = uid!;
    data["name"] = name!;
    data["email"] = email!;
    data["phone"] = phone!;
    data["status"] = status!;
    data["client"] = client!;
    data["location"] = location!;

    return data;
  }



}