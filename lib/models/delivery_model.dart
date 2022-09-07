
import 'package:food_delivery/models/firebase_user_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Delivery {
  String uid;
  String status; //initiating 
  String client;
  List<Order> orders;

  Delivery({required this.uid, required this.status, required this.client, required this.orders});

  factory Delivery.fromJson(Map<String, dynamic> json) {
     List<Order> _orders = [];
     json["orders"].forEach((order){
      _orders.add(Order.fromJson(order));
     });

    return Delivery(
      uid: json["uid"],
      status: json["status"],
      client: json["client"],
      orders: json["orders"]
    );
  }

   Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    List<Map<String, dynamic>> _orders = [];

    orders.forEach((order) {
      _orders.add(order.toJson());
    });

    data["uid"] = uid;
    data["status"] = status;
    data["client"] = client;
    data["orders"] = _orders;

    return data;
  }




}




class Order {
  FirebaseUser client;
  LatLng location;
  String cart;

  Order({required this.client, required this.location, required this.cart});

  Map<String, dynamic> toJson(){
    Map<String, dynamic> data = Map();
    data["client"] = client.toJson();
    data["location"] = location.toJson();
    data["cart"] = cart;
    return data; 
  }

  factory Order.fromJson(Map<String, dynamic> json){
    return Order(
      client: FirebaseUser.fromJson(json["client"]), 
      location: LatLng(json["location"].latitude, json["location"].longitude), 
      cart: json["cart"]
    );
  }





}
