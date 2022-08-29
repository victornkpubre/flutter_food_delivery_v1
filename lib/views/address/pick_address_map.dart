import 'package:flutter/material.dart';
import 'package:food_delivery/controllers/location_controller.dart';
import 'package:food_delivery/route/route_helper.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/views/address/widgets/search_location_page.dart';
import 'package:food_delivery/views/base/custom_button.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PickAddressMap extends StatefulWidget {
  final bool fromSignup;
  final bool fromAddress;
  final GoogleMapController? googleMapController;
  PickAddressMap({
    Key? key, 
    required this.fromSignup, 
    required this.fromAddress, 
    this.googleMapController
  }) : super(key: key);

  @override
  State<PickAddressMap> createState() => _PickAddressMapState();
}

class _PickAddressMapState extends State<PickAddressMap> {
  late LatLng  _initialPosition;
  late GoogleMapController _mapController;
  late CameraPosition _cameraPosition;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var locationController = Get.find<LocationController>();
    if(locationController.addressList.isEmpty){
      _initialPosition = LatLng(45.543, -122);
      _cameraPosition = CameraPosition(target: _initialPosition, zoom: 17);
    }
    else{
      if(locationController.addressList.isNotEmpty){
        _initialPosition = LatLng(
          double.parse(locationController.getAddress["latitude"]),
          double.parse(locationController.getAddress["longitude"]) 
        );
        _cameraPosition = CameraPosition(target: _initialPosition, zoom: 17);
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(builder: (locationController){
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: SizedBox(
              width: double.maxFinite,
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(target: _initialPosition, zoom: 17),
                    zoomControlsEnabled: false,
                    onCameraMove: (CameraPosition cameraPosition){
                      _cameraPosition = cameraPosition;
                    },
                    onCameraIdle: (){
                      Get.find<LocationController>().updatePosition(_cameraPosition, false);
                    },
                    onMapCreated: (GoogleMapController mapController) {
                      _mapController = mapController;
                      if(!widget.fromAddress) {
                        print("pick from web");
                        Get.find<LocationController>().getCurrentLocation(false, mapController: mapController);
                      }
                    },
                    myLocationButtonEnabled: true,
                  ),

                  Center(
                    child: !locationController.loading?
                      Image.asset("assets/image/pick_marker.png", height: 50, width: 50):
                    CircularProgressIndicator()
                  ),

                  Positioned(
                    top: Dimensions.height45,
                    left: Dimensions.width20,
                    right: Dimensions.width20,
                    child: InkWell(
                      onTap: (){
                        Get.dialog(LocationDialogue(mapController: _mapController));
                      },
                      child: Container(
                        height: 50,
                          decoration: BoxDecoration(
                          color: AppColors.mainColor,
                          borderRadius: BorderRadius.circular(Dimensions.radius20/2)
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.location_on, size:25, color: AppColors.yellowColor),
                            Expanded(
                              child: Text(
                                '${locationController.pickPlacemark.name??''}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Dimensions.font20
                                ),
                              )
                            )
                          ],
                        ),
                      ),
                    ) 
                  ),
                  
                  Positioned(
                    bottom: 200,
                    left: Dimensions.width20,
                    right: Dimensions.width20,
                    child: CustomButton(
                      buttonText: widget.fromAddress? "Pick Address": "Pick Location",
                      onPressed: locationController.loading?null:(){

                        var latitude = locationController.pickPosition.latitude;
                        var longitude = locationController.pickPosition.longitude;
                        var name = locationController.pickPlacemark.name;

                        if(latitude!=0 && name!=null){
                          if(widget.fromAddress){
                            if(widget.googleMapController != null){
                              print("Now you can clicked on this");
                              widget.googleMapController!.moveCamera(
                                CameraUpdate.newCameraPosition(
                                  CameraPosition(target: LatLng(latitude, longitude))
                              ));
                            }
                            locationController.setAddressData();
                          }
                          Get.toNamed(GetRouter.getAddressPage());
                        }

                      },
                    ) 
                  ),


                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}