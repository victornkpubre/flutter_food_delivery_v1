import 'package:flutter/material.dart';
import 'package:food_delivery/controllers/auth_controller.dart';
import 'package:food_delivery/controllers/cart_controller.dart';
import 'package:food_delivery/controllers/location_controller.dart';
import 'package:food_delivery/controllers/user_controller.dart';
import 'package:food_delivery/route/route_helper.dart';
import 'package:food_delivery/utils/app_icon.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/views/address/add_address_page.dart';
import 'package:food_delivery/views/base/custom_loader.dart';
import 'package:food_delivery/widgets/account_widget.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:get/get.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
    if (_userLoggedIn) {
      Get.find<UserController>().getUserinfo();
      Get.find<LocationController>().getUserAddress();
    }

    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColors.mainColor,
          title: BigText(
            text: "Profile",
            size: 24,
            color: Colors.white,
          )),
      body: GetBuilder<UserController>(builder: (userController) {
        return _userLoggedIn
            ? (!userController.isLoading
              ? Container(
                  child: Column(
                    children: [

                      AppIcon(
                        icon: Icons.person,
                        backgroundColor: AppColors.mainColor,
                        iconColor: Colors.white,
                        iconSize: Dimensions.height30*3,
                        size: Dimensions.height15 * 10,
                      ),
                      SizedBox(
                        height: Dimensions.height30,
                      ),

                      AccountWidget(
                        icon: Icons.person, 
                        text: userController.userModel.name,
                        bg_color: AppColors.mainColor,
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),

                      AccountWidget(
                        icon: Icons.phone, 
                        text: userController.userModel.phone,
                        bg_color: AppColors.yellowColor,
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      
                      AccountWidget(
                        icon: Icons.mail, 
                        text: userController.userModel.email,
                        bg_color: AppColors.yellowColor,
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),

                      GetBuilder<LocationController>(
                        builder: (locationController) {
                          late String addressString;
                          if(_userLoggedIn && locationController.addressList.isNotEmpty){
                            addressString = locationController.addressList.last.address;
                          }
                          else{
                            addressString = "Fill in your address";
                          }

                          return GestureDetector(
                            onTap: (){
                              Get.toNamed(GetRouter.getAddressPage());
                            },
                            // child: SizedBox(
                            //   width: Dimensions.screenWidth,
                            //   child: AccountWidget(
                            //     icon: Icons.location_pin, 
                            //     text: addressString,
                            //     bg_color: Colors.orangeAccent,
                            //   ),
                            // ),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: Dimensions.width20*2, vertical: Dimensions.width15),
                              child: Row(
                                children: [
                                  AppIcon(
                                    icon: Icons.location_pin,
                                    backgroundColor: Colors.orangeAccent,
                                    iconColor: Colors.white,
                                    iconSize: Dimensions.height10 * 5/2,
                                    size: Dimensions.height10 * 5,
                                  ),
                                  SizedBox(width: Dimensions.width20),
                                  SizedBox(
                                    width: Dimensions.screenWidth*3/4,
                                    child: Text(
                                      addressString,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: Dimensions.font24,
                                        color: Color(0xFF332d2b),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 1,
                                    offset: Offset(0,2),
                                    color: Colors.grey.withOpacity(0.2),
                                  ),
                                ]
                              ),
                            )
                          );
                        }
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),


                      GestureDetector(
                        onTap: () {
                          var authController = Get.find<AuthController>();
                          var cartController = Get.find<CartController>();
                          if (authController.userLoggedIn()) {
                            authController.clearSharedData();
                            cartController.clear();
                            cartController.clearCartHistory();
                            Get.find<LocationController>().clearAddressList();
                            Get.offNamed(GetRouter.getSignInPage());
                          }
                        },
                        child: const AccountWidget(icon: Icons.logout_outlined, text: "Logout", bg_color: Colors.redAccent)
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                    ],
                  ),
                )
              : CustomLoader()
            )
            //Sign In option for logged out users
            :Container(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: double.maxFinite,
                        height: Dimensions.screenHeight / 4,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage("assets/image/signintocontinue.png"),
                          fit: BoxFit.cover,
                        )),
                      ),

                      //SignIn Button
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(GetRouter.getSignInPage());
                        },
                        child: Container(
                          width: double.maxFinite,
                          height: Dimensions.screenHeight / 8,
                          margin: EdgeInsets.symmetric(
                              horizontal: Dimensions.width20 * 2),
                          decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius:
                                BorderRadius.circular(Dimensions.radius20),
                          ),
                          child: Center(
                            child: BigText(text: "Sign In", color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )
                )
              );
      }),
    );
  }
}
