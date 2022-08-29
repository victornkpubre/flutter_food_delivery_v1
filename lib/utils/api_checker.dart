
import 'package:food_delivery/route/route_helper.dart';
import 'package:food_delivery/views/base/show_custom_message.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class ApiChecker {
  static void checkApi(Response response){
    if(response.statusCode == 401){
      Get.offNamed(GetRouter.getSignInPage());
    }
    else{
      showCustomSnackBar(response.statusText!);
    }
  }
}