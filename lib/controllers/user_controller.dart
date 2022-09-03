import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:food_delivery/data/repository/firebase_user_repo.dart';
import 'package:food_delivery/data/repository/user_repo.dart';
import 'package:food_delivery/models/firebase_user_model.dart';
import 'package:food_delivery/models/response_model.dart';
import 'package:food_delivery/models/user_model.dart';
import 'package:get/get.dart';

class UserController extends GetxController implements GetxService {
  final UserRepo userRepo;
  final FirebaseUserRepo firebaseUserRepo;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  late UserModel _userModel;
  UserModel get userModel => _userModel;

  late FirebaseUser _firebaseUser;
  FirebaseUser get firebaseUser => _firebaseUser;

  UserController({required this.userRepo, required this.firebaseUserRepo});

  Future<ResponseModel> getUserinfo() async {
    _isLoading = true;
    update();

    //Get Laravel User
    Response response = await userRepo.getUserInfo();
    print("Gotten User Details"+response.body.toString());
    late ResponseModel responseModel;

    if (response.statusCode == 200) {
      _userModel = UserModel.fromJson(response.body);
      print("Loaded User: "+_userModel.name);
      responseModel = ResponseModel(true, "Loaded User Details Successfully");
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }

    //Get Firebase User
    if(FirebaseAuth.instance.currentUser != null){
      //_firebaseUser = FirebaseUser.fromSnapshot(await firebaseUserRepo.getUser(FirebaseAuth.instance.currentUser!.uid));
    }
    else{
      Get.snackbar("Get User Error ", "You need to Login");
    }


    _isLoading = false;
    update();
    return responseModel;
  }
}
