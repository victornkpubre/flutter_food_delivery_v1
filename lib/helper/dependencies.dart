import 'package:food_delivery/controllers/auth_controller.dart';
import 'package:food_delivery/controllers/cart_controller.dart';
import 'package:food_delivery/controllers/location_controller.dart';
import 'package:food_delivery/controllers/popular_product_controller.dart';
import 'package:food_delivery/controllers/recommended_products_controller.dart';
import 'package:food_delivery/controllers/user_controller.dart';
import 'package:food_delivery/data/api/api_client.dart';
import 'package:food_delivery/data/repository/auth_repo.dart';
import 'package:food_delivery/data/repository/cart_repo.dart';
import 'package:food_delivery/data/repository/firebase_user_repo.dart';
import 'package:food_delivery/data/repository/popular_product_repo.dart';
import 'package:food_delivery/data/repository/recommended_product_repo.dart';
import 'package:food_delivery/data/repository/user_repo.dart';
import 'package:food_delivery/data/repository/location_repo.dart';
import 'package:food_delivery/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final firebaseUserRepo = FirebaseUserRepo();

  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => firebaseUserRepo);

  //Get.find() - uses the variable name in the stated class to find the appropriate Object e.g
  //apiClient:Get.find() finds the variable apiClient in the PopularProductRepo class
  Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.BASE_URL, sharedPreferences: sharedPreferences));

  Get.lazyPut(() => AuthRepo(apiClient: Get.find(), sharedPreferences: sharedPreferences));
  Get.lazyPut(() => AuthController(authRepo: Get.find(), firebaseUserRepo: firebaseUserRepo));

  Get.lazyPut(() => PopularProductRepo(apiClient: Get.find()));
  Get.lazyPut(() => PopularProductController(popularProductRepo: Get.find()));

  Get.lazyPut(() => RecommendedProductRepo(apiClient: Get.find()));
  Get.lazyPut(() => RecommendedProductController(recommendedProductRepo: Get.find()));

  Get.lazyPut(() => CartRepo(sharedPreferences: Get.find()));
  Get.lazyPut(() => CartController(cartRepo: Get.find()));
  
  
  Get.lazyPut(() => UserRepo(apiClient: Get.find()));
  Get.lazyPut(() => UserController(userRepo: Get.find(), firebaseUserRepo: firebaseUserRepo));

  Get.lazyPut(() => LocationRepo(apiClient: Get.find(), sharedPreferences: sharedPreferences));
  Get.lazyPut(() => LocationController(locationRepo: Get.find()));

}
