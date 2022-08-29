import 'package:flutter/material.dart';
import 'package:food_delivery/controllers/auth_controller.dart';
import 'package:food_delivery/controllers/location_controller.dart';
import 'package:food_delivery/controllers/user_controller.dart';
import 'package:food_delivery/models/address_model.dart';
import 'package:food_delivery/models/response_model.dart';
import 'package:food_delivery/route/route_helper.dart';
import 'package:food_delivery/utils/app_icon.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/views/address/pick_address_map.dart';
import 'package:food_delivery/widgets/app_text_field.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({ Key? key }) : super(key: key);

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  TextEditingController _addressInputController = TextEditingController();
  final TextEditingController _contactPersonNameController = TextEditingController();
  final TextEditingController _contactPersonNumberController = TextEditingController();
  late bool _isLoggedIn;
  CameraPosition _cameraPosition = CameraPosition(target: LatLng(45.525, -122.34), zoom: 17);
  late LatLng _initialPosition;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = Get.find<AuthController>().userLoggedIn();
    if(_isLoggedIn && Get.find<UserController>().userModel==null){
      Get.find<UserController>().getUserinfo();
    }
    if(Get.find<LocationController>().addressList.isNotEmpty){
      if(Get.find<LocationController>().getUserAddressFromLocalStorage()==""){
        var locationController = Get.find<LocationController>();
        var address = locationController.addressList.last;
        locationController.saveUserAddress(address);
      }

      double lat =double.parse(Get.find<LocationController>().getAddress["latitude"]);
      double lng =double.parse(Get.find<LocationController>().getAddress["longitude"]);
      _cameraPosition = CameraPosition(target: LatLng(lat,lng));
      _initialPosition = LatLng(lat, lng);
    }
    else{
      _initialPosition = LatLng(45.525, -122.34);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Address page"),
        backgroundColor: AppColors.mainColor,
      ),
      body: GetBuilder<UserController>(builder: (userController) {
        if(userController.userModel != null && _contactPersonNameController.text.isEmpty){
          _contactPersonNameController.text = '${userController.userModel.name}';
          _contactPersonNumberController.text = '${userController.userModel.phone}';
          if(Get.find<LocationController>().addressList.isNotEmpty){
            _addressInputController.text = Get.find<LocationController>().getUserAddress().address;
          } 
        }

        return GetBuilder<LocationController>(builder: (locationController) {
          _addressInputController.text = '${locationController.placemark.name??''}'
                                          '${locationController.placemark.locality??''}'
                                          '${locationController.placemark.postalCode??''}'
                                          '${locationController.placemark.country??''}';
          print("Address in my view is "+_addressInputController.text);
          
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 140,
                  width: Dimensions.screenWidth,
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      width: 2, color: AppColors.mainColor
                    )
                  ),
                  child: Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(target: _initialPosition, zoom: 17),
                        zoomControlsEnabled: false,
                        compassEnabled: false,
                        indoorViewEnabled: true,
                        mapToolbarEnabled: false,
                        myLocationEnabled: true,
                        onCameraMove: ((position) => _cameraPosition=position),
                        onCameraIdle: (){
                          locationController.updatePosition(_cameraPosition, true);
                        }, 
                        onMapCreated: (GoogleMapController googleMapController){
                          locationController.setMapController(googleMapController);  
                        },
                        onTap: (latlng){
                          Get.toNamed(GetRouter.getPickAddressPage(), 
                            arguments: PickAddressMap(
                              fromSignup: false,
                              fromAddress: true,
                              googleMapController: locationController.mapController,
                            )
                          );
                        },  
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: Dimensions.width20),
                  child: SizedBox(
                    height: 50, 
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: locationController.addressTypeList.length,
                      itemBuilder: (context, index){
                        return InkWell(
                          onTap:() => locationController.setAddressTypeIndex(index),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.width20, vertical: Dimensions.height10),
                            margin: EdgeInsets.only(right: Dimensions.width20*2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radius20/4),
                              color: Theme.of(context).cardColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[200]!,
                                  spreadRadius: 1,
                                  blurRadius: 5
                                ),
                              ]
                            ),
                            child: Icon(
                              index==0?Icons.home_filled:index==1?Icons.work:Icons.location_on,
                              color: locationController.addressTypeIndex==index?AppColors.mainColor:Theme.of(context).disabledColor,
                              size: Dimensions.iconSize28,
                            ),
                          ),
                        );
                      }
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.height20,),
          
                Padding(
                  padding: EdgeInsets.only(left: Dimensions.width20),
                  child: BigText(text: "Delivery Address"),
                ),
                SizedBox(height: Dimensions.height10,),
                AppTextField(
                  textController: _addressInputController,
                  hintText: "Your Address", 
                  icon: Icons.map
                ),
          
                Padding(
                  padding: EdgeInsets.only(left: Dimensions.width20),
                  child: BigText(text: "Contact Name"),
                ),
                SizedBox(height: Dimensions.height10,),
                AppTextField(
                  textController: _contactPersonNameController,
                  hintText: "Your Name", 
                  icon: Icons.map
                ),
          
                Padding(
                  padding: EdgeInsets.only(left: Dimensions.width20),
                  child: BigText(text: "Contact Number"),
                ),
                SizedBox(height: Dimensions.height10,),
                AppTextField(
                  textController: _contactPersonNumberController,
                  hintText: "Your Number", 
                  icon: Icons.map
                ),
              ],
            ),
          );
        });
      }),
      bottomNavigationBar: GetBuilder<LocationController>(
        builder: (locationController) {
          return Container(
            color: AppColors.buttonBackgroundColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width30 * 2,
                      vertical: Dimensions.height20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: Dimensions.height45),
                        padding: EdgeInsets.only(
                            left: Dimensions.width30,
                            right: Dimensions.width30,
                            bottom: Dimensions.height20,
                            top: Dimensions.height20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radius30),
                          color: AppColors.mainColor,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            String type = locationController.addressTypeList[locationController.addressTypeIndex];
                            AddressModel _addressModel = AddressModel(
                              addressType: type,
                              contactPersonName: _contactPersonNameController.text,
                              contactPersonNumber: _contactPersonNumberController.text,
                              address: _addressInputController.text,
                              latitude: locationController.position.latitude.toString(),
                              longitude: locationController.position.longitude.toString()
                            );
                            locationController.addAddress(_addressModel).then((response){
                              print("Address was added succesfully? "+response.toString());
                              if(response.isSuccess){
                                Get.back();
                                Get.snackbar("Address", "Added Successfully");
                              }
                              else{
                                Get.snackbar("Address", "Couldn't save address");
                              }
                            });
                          },
                          child: BigText(
                            text: "Save Address",
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}