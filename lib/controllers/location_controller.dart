import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:food_delivery/data/repository/location_repo.dart';
import 'package:food_delivery/models/address_model.dart';
import 'package:food_delivery/models/response_model.dart';
import 'package:food_delivery/utils/api_checker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationController extends GetxController implements GetxService{
  LocationRepo locationRepo;
  LocationController({required this.locationRepo});

  bool _loading = false;
  late Position _position;
  late Position _pickPosition;

  Placemark _placemark = Placemark();
  Placemark _pickPlacemark = Placemark();

  List<AddressModel> _addressList=[];
  late List<AddressModel> _allAddressList;
  List<String> _addressTypeList = ["home", "office", "others"];
  int _addressTypeIndex=0;
  late Map<String, dynamic> _getAddress;
  late GoogleMapController _mapController;
  bool _updateAddressData = true;
  bool _changeAddress = false;
  
  bool get loading => _loading;
  Position get position => _position;
  Position get pickPosition => _pickPosition;
  List<AddressModel> get addressList => _addressList;
  Map get getAddress => _getAddress;
  Placemark get placemark => _placemark ;
  Placemark get pickPlacemark => _pickPlacemark;
  List<String> get addressTypeList => _addressTypeList;
  int get addressTypeIndex => _addressTypeIndex;
  GoogleMapController get mapController => _mapController;

  //For service zone
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  //Whether the user is in service zone or not
  bool _inZone = false;
  bool get inZone => _inZone;

  //Showing and hiding the button as the map loads
  bool _buttonDisabled = true;
  bool get buttonDisabled => _buttonDisabled;


  

  void setMapController(GoogleMapController mapController){
    _mapController=mapController;
  }

  Future<AddressModel> getCurrentLocation(bool fromAddress, {required GoogleMapController mapController, LatLng? defaultLatLng, bool notify = true}) async {
    _loading = true;
    if(notify) {
      update();
    }
    AddressModel _addressModel;
    Position _myPosition;
    try {
      Position newLocalData = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      _myPosition = newLocalData;
     // print("I am from getcurrentPos1 "+defaultLatLng!.latitude.toString());
    }catch(e) {
      _myPosition = Position(
        latitude: defaultLatLng != null ? defaultLatLng.latitude : double.parse( '0'),
        longitude: defaultLatLng != null ? defaultLatLng.longitude : double.parse( '0'),
        timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1,
      );
    }
    if(fromAddress) {
      _position = _myPosition;
    }else {
      _pickPosition = _myPosition;
    }
    if (mapController != null) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(_myPosition.latitude, _myPosition.longitude), zoom: 17),
      ));
    }
    Placemark _myPlaceMark;
    try {
      if(!GetPlatform.isWeb) {

        List<Placemark> placeMarks = await placemarkFromCoordinates(_myPosition.latitude, _myPosition.longitude);
        _myPlaceMark = placeMarks.first;
      }else {

        String _address = await getAddressFromGeocode(LatLng(_myPosition.latitude, _myPosition.longitude));
        _myPlaceMark = Placemark(name: _address, locality: '', postalCode: '', country: '');
      }
    }catch (e) {
      String _address = await getAddressFromGeocode(LatLng(_myPosition.latitude, _myPosition.longitude));
      _myPlaceMark = Placemark(name: _address, locality: '', postalCode: '', country: '');
    }
    fromAddress ? _placemark = _myPlaceMark : _pickPlacemark = _myPlaceMark;
    ResponseModel _responseModel = await getZone(_myPosition.latitude.toString(), _myPosition.longitude.toString(), true);
    _buttonDisabled = !_responseModel.isSuccess;
    _addressModel = AddressModel(
      latitude: _myPosition.latitude.toString(), longitude: _myPosition.longitude.toString(), addressType: 'others',
      //zoneId: _responseModel.isSuccess ? int.parse(_responseModel.message) : 0,
      address: '${_myPlaceMark.name ?? ''}'
          ' ${_myPlaceMark.locality ?? ''} '
          '${_myPlaceMark.postalCode ?? ''} '
          '${_myPlaceMark.country ?? ''}',
    );
    _loading = false;
    update();
    return _addressModel;
  }

  void updatePosition(CameraPosition position, bool fromAddress) async {
    if(_updateAddressData) {
      _loading = true;
      update();
      try {
        if (fromAddress) {
          _position = Position(
            latitude: position.target.latitude, longitude: position.target.longitude,
            timestamp: DateTime.now(),
            heading: 1, accuracy: 1, altitude: 1, speedAccuracy: 1, speed: 1,
          );

        } else {
          _pickPosition = Position(
            latitude: position.target.latitude, longitude: position.target.longitude,
            timestamp: DateTime.now(),
            heading: 1, accuracy: 1, altitude: 1, speedAccuracy: 1, speed: 1,
          );

        }
        ResponseModel _responseModel = await getZone(position.target.latitude.toString(),
            position.target.longitude.toString(), true);
        _buttonDisabled = !_responseModel.isSuccess;
        if (_changeAddress) {

            String _address = await getAddressFromGeocode(LatLng(position.target.latitude,
                position.target.longitude));
            fromAddress ? _placemark = Placemark(name: _address)
                : _pickPlacemark = Placemark(name: _address);
        } else {
          _changeAddress = true;
        }
      } catch (e) {
        print(e);
      }
      _loading = false;

      update();
    }else {
      _updateAddressData = true;
    }
  }

  Future<String> getAddressFromGeocode(LatLng latLng) async {
    String _address = "Unknown Location Found";
    Response response = await locationRepo.getAddressFromGeocode(latLng);
    if(response.body["status"] == 'OK'){
      _address = response.body["results"][0]["formatted_address"].toString();
    }
    else{
      print("Error getting the google api");
    }
    update();
    return _address;
  }

  AddressModel getUserAddress(){
    late AddressModel _addressModel;

    if(locationRepo.getUserAddress()==""){
      _addressModel = AddressModel(addressType: _addressTypeList[0]);
    }
    else{
      _getAddress = jsonDecode(locationRepo.getUserAddress());
      try {
        _addressModel = AddressModel.fromJson(jsonDecode(locationRepo.getUserAddress()));
      } catch (e) {
        print(e);
      }
    }
    
    return _addressModel;
  }

  void setAddressTypeIndex(int index){
    _addressTypeIndex = index;
    update();
  }

  Future<ResponseModel> addAddress(AddressModel addressModel) async {
    _loading = true;
    update();
    Response response = await locationRepo.addAddress(addressModel);
    ResponseModel responseModel;
    if(response.statusCode==200){
      await getAddressList();
      String message = response.body['message'];
      responseModel = ResponseModel(true, message);
      await saveUserAddress(addressModel);
    }
    else{
      print("couldn't save the address");
      responseModel = ResponseModel(false, response.statusText!);
    }
    //_loading = false;
    update();
    return responseModel;
  }

  Future<void> getAddressList() async{
    Response response = await locationRepo.getAllAddress();
    if(response.statusCode == 200){
      _addressList = [];
      _allAddressList = [];
      response.body.forEach((address){
        _addressList.add(AddressModel.fromJson(address));
        _allAddressList.add(AddressModel.fromJson(address));
      });
    }
    else{
      _addressList = [];
      _allAddressList = [];
    }
    update();
  }

  saveUserAddress(AddressModel addressModel) async {
    String userAddress = jsonEncode(addressModel.toJson());
    return await locationRepo.saveUserAddress(userAddress);
  }

  void clearAddressList(){
    _addressList=[];
    _allAddressList=[];
    update();
  }

  String getUserAddressFromLocalStorage() {
    return locationRepo.getUserAddress();
  }

  void setAddressData(){
    _position = _pickPosition;
    _placemark = _pickPlacemark;
    _updateAddressData = false;
    update();
  }

  Future<ResponseModel> getZone(String lat, String long, bool markerLoad) async {
    if(markerLoad) {
      _loading = true;
    }else {
      _isLoading = true;
    }
    update();
    ResponseModel _responseModel;
    Response response = await locationRepo.getZone(lat, long);
    if(response.statusCode == 200) {
      _inZone = true;
      _responseModel = ResponseModel(true, response.body['zone_id'].toString());
    }else {
      _inZone = false;
      _responseModel = ResponseModel(false, response.statusText!);
    }
    if(markerLoad) {
      _loading = false;
    }else {
      _isLoading = false;
    }
    update();
    return _responseModel;
  }

  // searchLocation(BuildContext context, String text) async {
  //   if(text.isNotEmpty){
  //     Response response = await locationRepo.searchLocation(text);
  //     if(response.statusCode == 200 && response.body["status"] == 'OK'){
  //       _predictionList = [];
  //       response.body['predictions'].forEach((prediction) => _predictionList.add(Prediction.fromJson(prediction)));
  //     }
  //     else{
  //       ApiChecker.checkApi(response);
  //     }
  //     return _predictionList;
  //   }
  // }

  // setLocation(String placeID, String address, GoogleMapController mapController) async {
  //   _loading = true;
  //   update();
  //   PlacesDetailsResponse detail;
  //   Response response = await locationRepo.setLocation(placeID);
  //   detail = PlacesDetailsResponse.fromJson(response.body);
  //   _pickPosition = Position(
  //     latitude: detail.result.geometry!.location.lat,
  //     longitude: detail.result.geometry!.location.lng,
  //     timestamp: DateTime.now(),
  //     accuracy: 1,
  //     altitude: 1,
  //     heading: 1,
  //     speed: 1,
  //     speedAccuracy: 1
  //   );

  //   _pickPlacemark = Placemark(name: address);
  //   _changeAddress = false;
  //   if(!mapController.isNull){
  //     mapController.animateCamera(CameraUpdate.newCameraPosition(
  //       CameraPosition(target: LatLng(
  //         detail.result.geometry!.location.lat,
  //         detail.result.geometry!.location.lng
  //       ))
  //     ));
  //   }


  //   _loading = false;
  //   update();

  // }





}