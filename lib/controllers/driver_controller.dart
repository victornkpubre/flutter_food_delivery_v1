
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery/data/repository/driver_repo.dart';
import 'package:food_delivery/data/repository/firebase_user_repo.dart';
import 'package:food_delivery/models/delivery_model.dart';
import 'package:food_delivery/models/firebase_user_model.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong/latlong.dart' as latlong;
import 'package:location/location.dart';

class DriverController extends GetxController {
  final DriverRepo driverRepo;
  final FirebaseUserRepo firebaseUserRepo;

  DriverController({required this.driverRepo, required this.firebaseUserRepo});

     //--States-- 
     //offline (Not delivering), 
     //online (Avaliable for delivery), 
     //booking (Recieved delivery request), 
     //rejecting (Rejecting delivery request), 
     //delivering (started delivery), 
     //completing (Finishing delivery), 
     //completed (Finished delivery)
  Stream<DocumentSnapshot<Object?>> goOnline(FirebaseUser user) {
    user.status = "online";
    firebaseUserRepo.updateUser(user);
    return firebaseUserRepo.getUserStream(user);
  }

  Stream<DocumentSnapshot<Object?>> goOffline(FirebaseUser user) {
    user.status = "offline";
    firebaseUserRepo.updateUser(user);
    return firebaseUserRepo.getUserStream(user);
  }

  Stream<DocumentSnapshot<Object?>> rejectRequest(FirebaseUser user){
    user.status = "rejecting";
    firebaseUserRepo.updateUser(user);
    return firebaseUserRepo.getUserStream(user);
  }

  Stream<DocumentSnapshot<Object?>> acceptRejection(FirebaseUser user){
    user.status = "online";
    firebaseUserRepo.updateUser(user);
    return firebaseUserRepo.getUserStream(user);
  }
  Stream<DocumentSnapshot<Object?>> acceptRequest(FirebaseUser user){
    user.status = "delivering";
    firebaseUserRepo.updateUser(user);
    return firebaseUserRepo.getUserStream(user);
  }

  Stream<DocumentSnapshot<Object?>> endDelivery(FirebaseUser user){
    user.status = "completing";
    firebaseUserRepo.updateUser(user);
    return firebaseUserRepo.getUserStream(user);
  }

  Stream<DocumentSnapshot<Object?>> comfirmDelivery(FirebaseUser user){
    user.status = "online";
    firebaseUserRepo.updateUser(user);
    return firebaseUserRepo.getUserStream(user);
  }


  //Called buy client after payment return best fit driver and makes a request to said driver
  Future<Stream<DocumentSnapshot<Object?>>> requestDelivery(FirebaseUser client, Delivery job) async {
    //Start Loading
    FirebaseUser driver = await getClosestDriver(LatLng(client.location.latitude, client.location.longitude));

    //Make request and return stream of user
    return firebaseUserRepo.getUserStream(driver);
  }


  Future<FirebaseUser> getClosestDriver(LatLng location) async{
    latlong.Distance distanceCalculator = latlong.Distance();
    List<FirebaseUser> drivers = await driverRepo.getDriversByZone(0);
    var minDistance = 50000;
    FirebaseUser bestDriver = drivers[0];

    drivers.forEach((driver) {
       final int meter = distanceCalculator(
        latlong.LatLng(location.latitude, location.longitude),
        latlong.LatLng(driver.location.latitude, driver.location.longitude)
      ) as int;

      if(meter < minDistance){
        minDistance = meter;
        bestDriver = driver;
      }
      
    });

    return bestDriver;
  }


  Future<Location> getLocationController() async {
    Location locationController = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await locationController.requestService();
      if (!_serviceEnabled) {
        Get.snackbar("Location Error", "Location Service Disabled");
      }
    }

    _permissionGranted = await locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        Get.snackbar("Location Error", "Permission Denied");
      }
    }
    return locationController;
  }

  Future<StreamSubscription> getLocationSubscription(){

  }



}