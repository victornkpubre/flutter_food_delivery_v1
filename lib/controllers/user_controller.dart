import 'package:food_delivery/data/repository/user_repo.dart';
import 'package:food_delivery/models/response_model.dart';
import 'package:food_delivery/models/user_model.dart';
import 'package:get/get.dart';

class UserController extends GetxController implements GetxService {
  final UserRepo userRepo;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  late UserModel _userModel;
  UserModel get userModel => _userModel;

  UserController({required this.userRepo});

  Future<ResponseModel> getUserinfo() async {
    _isLoading = true;
    update();
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
    _isLoading = false;
    update();
    return responseModel;
  }
}
