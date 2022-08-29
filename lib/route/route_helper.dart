import 'package:food_delivery/views/address/add_address_page.dart';
import 'package:food_delivery/views/address/pick_address_map.dart';
import 'package:food_delivery/views/auth/sign_in_page.dart';
import 'package:food_delivery/views/cart/cart_page.dart';
import 'package:food_delivery/views/food/popular_food_detail.dart';
import 'package:food_delivery/views/food/recommended_food_details.dart';
import 'package:food_delivery/views/home/home_page.dart';
import 'package:food_delivery/views/home/main_food_page.dart';
import 'package:food_delivery/views/payment/payment_page.dart';
import 'package:food_delivery/views/splash/splash_screen.dart';
import 'package:get/get.dart';

//Getx Route Managment uses three main components, the route names, route functions & route logic
// the route functions are called from the ui, which in turn call the 


class GetRouter {
  //Route Names
  static const String initial = "/";
  static const String splashPage = "/splash-page";
  static const String signInPage = "/signin-page";
  static const String popularFood = "/popular-food";
  static const String recommendedFood = "/recommended-food";
  static const String cartPage = "/cart-page";
  static const String addAddress="/add-address";
  static const String pickAddressMap = "/pick-address";
  static const String paymentPage = "/payment";

  //Route Functions
  // - route functions create route uri using route names
  // - use it to pass variables
  // - benefit: calling routes and pass arguments via a function
  //            its more readable, modular and separates concerns 
  static String getInitial() => '$initial';
  static String getSplashPage() => '$splashPage';
  static String getSignInPage() => '$signInPage';
  static String getPopularFoodPage(int pageId, String page) => '$popularFood?pageId=$pageId&page=$page';
  static String getRecommendedFoodPage(int pageId, String page) => '$recommendedFood?pageId=$pageId&page=$page';
  static String getCartPage() => '$cartPage';
  static String getAddressPage() => '$addAddress';
  static String getPickAddressPage() => '$pickAddressMap';
  static String getPaymentPage() => '$paymentPage'; 


  //Route or Routing Logic
  // - routes link the route names to their appropriate pages thus NamedRoutes
  // - use it to access and pass route variables
  // - may include transition and middleware(program that runs between uri call and page build. used to redirect or customize routing pages)
  static List<GetPage> routes = [
    GetPage(name: initial, page: () => HomePage()),
    GetPage(name: splashPage, page: () => SplashScreen()),
    GetPage(name: signInPage, page: () => SignInPage()),
    GetPage(
      name: popularFood,
      transition: Transition.fadeIn,
      page: () {
        var pageId = Get.parameters['pageId'];
        var page = Get.parameters['page'];
        return PopularFoodDetail(pageId: int.parse(pageId!), page: page!);
      }
    ),
    GetPage(
      name: recommendedFood,
      transition: Transition.fadeIn,
      page: () {
        var pageId = Get.parameters['pageId'];
        var page = Get.parameters['page'];
        return RecommendedFoodDetails(
          pageId: int.parse(pageId!),
          page: page!,
        );
      }
    ),
    GetPage(
      name: cartPage,
      transition: Transition.fadeIn,
      page: () {
        return CartPage();
      }
    ),
    GetPage(
      name: addAddress,
      transition: Transition.fadeIn,
      page: (){
        return AddAddressPage();  
      }
    ),
    GetPage(name: pickAddressMap, page: (){
      PickAddressMap _pickAddress = Get.arguments;
      return _pickAddress;
    }),
    GetPage(name: paymentPage, page: (){
      return PaymentPage();
    })
  ];
}
