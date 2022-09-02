
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_delivery/data/repository/auth_repo.dart';
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
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  AuthController({required this.authRepo});

  Future<ResponseModel> registration(SignUpBody signUpBody) async {
    _isLoading = true;
    update();
    Response response = await authRepo.registration(signUpBody);
    late ResponseModel responseModel;

    if (response.statusCode == 200) {
      authRepo.saveUserToken(response.body["token"]);
      responseModel = ResponseModel(true, response.body["token"]);

      //Firebase Registration

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

  firebaseLoginUser(SignInBody signInBody) async {
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

  void firebaseRegisterUser(int id, SignUpBody signUpBody) async {  
    String name = signUpBody.name;
    String email = signUpBody.email;
    String password = signUpBody.password;
    try {
      if(name.isNotEmpty && email.isNotEmpty && password.isNotEmpty){
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  
        var user = FirebaseUser(
          uid: cred.user!.uid,
          name: name,
          email: email,
          phone: signUpBody.phone
        );

        // Client user = Client(
        //   uid: cred.user!.uid, 
        //   name: name, 
        //   email: email, 
        //   date: Timestamp.now()
        // );
        await firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
        //Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));

      } 
      else{
        Get.snackbar("Error Creating Account", "Please enter all th fields");
      }
    } catch (e) {
      Get.snackbar("Error Creating Acount", e.toString());
    }
  }
  
}
