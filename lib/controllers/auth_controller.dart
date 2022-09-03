
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_delivery/data/repository/auth_repo.dart';
import 'package:food_delivery/data/repository/firebase_user_repo.dart';
import 'package:food_delivery/models/firebase_user_model.dart';
import 'package:food_delivery/models/response_model.dart';
import 'package:food_delivery/models/signin_body_model.dart';
import 'package:food_delivery/models/signup_body_model.dart';
import 'package:food_delivery/route/route_helper.dart';
import 'package:get/get.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  FirebaseUserRepo firebaseUserRepo;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  AuthController({required this.authRepo, required this.firebaseUserRepo});

  Future<ResponseModel> registration(SignUpBody signUpBody) async {
    _isLoading = true;
    update();
    Response response = await authRepo.registration(signUpBody);
    late ResponseModel responseModel;

    if (response.statusCode == 200) {
      authRepo.saveUserToken(response.body["token"]);
      responseModel = ResponseModel(true, response.body["token"]);

      //Firebase Registration
      await firebaseRegisterUser(signUpBody);

    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }

    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> login(SignInBody signInBody) async {
    _isLoading = true;
    update();
    Response response = await authRepo.login(signInBody);
    late ResponseModel responseModel;

    if (response.statusCode == 200) {
      authRepo.saveUserToken(response.body["token"]);
      responseModel = ResponseModel(true, response.body["token"]);

      //Firebase Login
      await firebaseLoginUser(signInBody);

    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }

    _isLoading = false;
    update();
    return responseModel;
  }

  void saveUserNumberAndPassword(String number, String password) {
    authRepo.saveUserNumberAndPassword(number, password);
  }

  bool userLoggedIn() {
    return authRepo.userLoggedIn();
  }

  bool clearSharedData() {
    return authRepo.clearSharedData();
  }

  Future<void> firebaseLoginUser(SignInBody signInBody) async {
    String email = signInBody.email;
    String password = signInBody.password;
    try {
      if(email.isNotEmpty && password.isNotEmpty){
        await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      }
      else{
         print("Error Logging in: Email or Password is Empty");
      }
    } catch (e) {
        print("Error Logging in:" + e.toString());
    }
  }

  Future<void> firebaseRegisterUser(SignUpBody signUpBody) async {  
    String name = signUpBody.name;
    String email = signUpBody.email;
    String password = signUpBody.password;
    try {
      UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      var user = FirebaseUser(
        uid: cred.user!.uid,
        name: name,
        email: email,
        phone: signUpBody.phone
      );
      await firebaseUserRepo.createUser(user);
    } catch (e) {
      Get.snackbar("Error Creating Account", "${e.toString()}");
    }
  
  }
  
}
