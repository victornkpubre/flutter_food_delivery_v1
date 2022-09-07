
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:food_delivery/controllers/driver_controller.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class DriverPage extends StatefulWidget {
  const DriverPage({ Key? key }) : super(key: key);

  @override
  State<DriverPage> createState() => _DriverPageState();
}

class _DriverPageState extends State<DriverPage> {
  late GoogleMapController _mapController;
  late CameraPosition _cameraPosition;
  late Marker marker;
  late Circle circle; 
  late StreamSubscription _locationSubscription;
  late Location _locationController;



  Future<StreamSubscription> setLocationSubscription(){

  }



  void updateMarkerAndCircle(LocationData newLocation, Uint8List imageData){
    LatLng latlng = LatLng(newLocation.latitude!, newLocation.longitude!);
    setState(() {
      marker = Marker(
        markerId: MarkerId("car"),
        position: latlng,
        rotation: newLocation.heading!,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: const Offset(0.5,0.5),
        icon: BitmapDescriptor.fromBytes(imageData)
      );  
      circle = Circle(
        circleId: CircleId("accuracy"),
        center: latlng,
        radius: newLocation.accuracy!,
        zIndex: 2,
        fillColor: Colors.blue,
        strokeColor: Colors.blueAccent
      );
    });
  }
  
  //Driver page shows driver location, allows setting of location, allows accept or reject delivery request, Shows car, accurancy and route
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          
          GetBuilder<DriverController>(
            builder: (driverController) {
              return GoogleMap(
                initialCameraPosition: CameraPosition(target: LatLng(23,23), zoom: 17),
                zoomControlsEnabled: false,
                onCameraMove: (CameraPosition cameraPosition){
                  _cameraPosition = cameraPosition;
                },
                onMapCreated: (GoogleMapController mapController) async {
                  //Loading
                  _mapController = mapController;
                  _locationController = await driverController.getLocationController();
                  var locationData = await _locationController.getLocation();
                  _mapController.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: LatLng(locationData.latitude!, locationData.longitude!)
                      )
                    )
                  );
                },
                //myLocationButtonEnabled: true,
              );
            }
          ),

          Positioned(
            bottom: Dimensions.bottomHeightBar,
            child: Column(
              children: [
                InkWell(
                  child: const Text("Set Location"),
                  onTap: (){

                  },
                ),

                Row(
                  children: [
                    InkWell(
                      child: const Text("Accept Delivery"),
                      onTap: (){

                      },
                    ),
                    InkWell(
                      child: const Text("Reject Delivery"),
                      onTap: (){

                      },
                    ),
                  ],
                )

              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
      ),
    );
  }
}