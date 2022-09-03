import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/controllers/cart_controller.dart';
import 'package:food_delivery/controllers/popular_product_controller.dart';
import 'package:food_delivery/controllers/recommended_products_controller.dart';
import 'package:food_delivery/route/route_helper.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/views/cart/cart_page.dart';
import 'package:food_delivery/views/food/popular_food_detail.dart';
import 'package:food_delivery/views/food/recommended_food_details.dart';
import 'package:food_delivery/views/home/main_food_page.dart';
import 'package:get/get.dart';
import 'helper/dependencies.dart' as dependencies;

void main() async {
  //Ensures that dependencies.init() is completed before starting the app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dependencies.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.find<CartController>().getCartData();

    return GetBuilder<PopularProductController>(
      builder: (_) {
        return GetBuilder<RecommendedProductController>(
          builder: (_) {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Food Delivery App',
              initialRoute: GetRouter.getSplashPage(),
              getPages: GetRouter.routes,
              theme: ThemeData(
                primaryColor: AppColors.mainColor,
                fontFamily: "Lato",
              ),
            );
          },
        );
      },
    );
  }
}
