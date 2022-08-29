
import 'package:flutter/material.dart';
import 'package:food_delivery/controllers/location_controller.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationDialogue extends StatelessWidget {
  final GoogleMapController mapController;
  const LocationDialogue({ Key? key, required this.mapController }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    
    return Container(
      padding: EdgeInsets.all(Dimensions.width10),
      alignment: Alignment.topCenter,
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius20/2),

        ),
        child: SizedBox(
          width: Dimensions.screenWidth,
          child: Text("")
        ),
      ),
    );
  }
}