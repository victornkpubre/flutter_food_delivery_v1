import 'package:flutter/material.dart';
import 'package:food_delivery/controllers/auth_controller.dart';
import 'package:food_delivery/controllers/cart_controller.dart';
import 'package:food_delivery/controllers/location_controller.dart';
import 'package:food_delivery/controllers/popular_product_controller.dart';
import 'package:food_delivery/controllers/recommended_products_controller.dart';
import 'package:food_delivery/route/route_helper.dart';
import 'package:food_delivery/utils/app_constants.dart';
import 'package:food_delivery/utils/app_icon.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/views/base/no_data_page.dart';
import 'package:food_delivery/views/home/main_food_page.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:food_delivery/widgets/small_text.dart';
import 'package:get/get.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //Header
          Positioned(
            top: Dimensions.height20 * 3,
            left: Dimensions.width20 * 3,
            right: Dimensions.width20 * 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppIcon(
                  icon: Icons.arrow_back_ios,
                  iconColor: Colors.white,
                  backgroundColor: AppColors.mainColor,
                  iconSize: Dimensions.iconSize24,
                ),
                Wrap(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(GetRouter.getInitial());
                      },
                      child: AppIcon(
                        icon: Icons.home_outlined,
                        iconColor: Colors.white,
                        backgroundColor: AppColors.mainColor,
                        iconSize: Dimensions.iconSize24,
                      ),
                    ),
                    SizedBox(width: Dimensions.width30 * 2),
                    AppIcon(
                      icon: Icons.shopping_cart,
                      iconColor: Colors.white,
                      backgroundColor: AppColors.mainColor,
                      iconSize: Dimensions.iconSize24,
                    ),
                  ],
                ),
              ],
            ),
          ),

          //Body
          GetBuilder<CartController>(builder: (_cartController) {
            return _cartController.getItems.length > 0
                ? Positioned(
                    top: Dimensions.height20 * 6,
                    left: Dimensions.width20 * 3,
                    right: Dimensions.width20 * 3,
                    bottom: 0,
                    child: Container(
                      padding: EdgeInsets.only(top: Dimensions.height10 * 2),
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: GetBuilder<CartController>(
                            builder: (cartController) {
                          var _cartItems = cartController.getItems;
                          return ListView.builder(
                            itemCount: _cartItems.length,
                            itemBuilder: (context, index) {
                              return Container(
                                width: double.maxFinite,
                                // height: 100,
                                child: Row(
                                  children: [
                                    //Image
                                    GestureDetector(
                                      onTap: (() {
                                        var popularIndex =
                                            Get.find<PopularProductController>()
                                                .popularProductList
                                                .indexOf(
                                                    _cartItems[index].product!);
                                        if (popularIndex >= 0) {
                                          Get.toNamed(
                                              GetRouter.getPopularFoodPage(
                                                  popularIndex, "cartpage"));
                                        } else {
                                          var recommendedIndex = Get.find<
                                                  RecommendedProductController>()
                                              .recommendedProductList
                                              .indexOf(
                                                  _cartItems[index].product!);
                                          if (recommendedIndex < 0) {
                                            Get.snackbar("History Products",
                                                "Product review iss not available for history products",
                                                backgroundColor:
                                                    AppColors.mainColor,
                                                colorText: Colors.white);
                                          } else {
                                            Get.toNamed(
                                                GetRouter.getRecommendedFoodPage(
                                                    recommendedIndex,
                                                    "cartpage"));
                                          }
                                        }
                                      }),
                                      child: Container(
                                        height: Dimensions.height20 * 6,
                                        width: Dimensions.height20 * 6,
                                        margin: EdgeInsets.only(
                                            bottom: Dimensions.height10 * 2),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  AppConstants.BASE_URL +
                                                      AppConstants.UPLOADS_URL +
                                                      _cartItems[index].img!)),
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.radius20),
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),

                                    SizedBox(width: Dimensions.width30),

                                    Expanded(
                                        child: Container(
                                      height: Dimensions.height20 * 5,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          BigText(
                                              text: _cartItems[index].name!),
                                          SmallText(text: "Spicy"),
                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                BigText(
                                                    text:
                                                        "\$${_cartItems[index].price!}",
                                                    color: Colors.redAccent),
                                                Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        //Decrement Product in Cart
                                                        cartController.addItem(
                                                            _cartItems[index]
                                                                .product!,
                                                            -1);
                                                      },
                                                      child: const Icon(
                                                        Icons.remove,
                                                        color:
                                                            AppColors.signColor,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          Dimensions.height10,
                                                    ),
                                                    BigText(
                                                        text: _cartItems[index]
                                                            .quantity
                                                            .toString()),
                                                    SizedBox(
                                                      width:
                                                          Dimensions.height10,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        cartController.addItem(
                                                            _cartItems[index]
                                                                .product!,
                                                            1);
                                                      },
                                                      child: Icon(
                                                        Icons.add,
                                                        color:
                                                            AppColors.signColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                                  ],
                                ),
                              );
                            },
                          );
                        }),
                      ),
                    ),
                  )
                : const NoDataPage(
                    text: "Your cart is empty",
                  );
          })
        ],
      ),
      bottomNavigationBar:
          GetBuilder<CartController>(builder: (cartController) {
        return Container(
          height: cartController.getItems.isNotEmpty
              ? Dimensions.bottomHeightBar
              : 0,
          padding: EdgeInsets.only(
            left: Dimensions.width30,
            right: Dimensions.width30,
          ),
          decoration: BoxDecoration(
              color: AppColors.buttonBackgroundColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimensions.radius20 * 2),
                  topRight: Radius.circular(Dimensions.radius20 * 2))),
          child: cartController.getItems.isNotEmpty
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          left: Dimensions.width30,
                          right: Dimensions.width30,
                          bottom: Dimensions.height20,
                          top: Dimensions.height20),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius30),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: Dimensions.height10,
                          ),
                          BigText(
                              text:
                                  "\$" + cartController.totalAmount.toString()),
                          SizedBox(
                            width: Dimensions.height10,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: Dimensions.width30,
                          right: Dimensions.width30,
                          bottom: Dimensions.height20,
                          top: Dimensions.height20),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius30),
                        color: AppColors.mainColor,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          cartController.addToHistory();
                          cartController.clear();
                          Get.toNamed(GetRouter.getPaymentPage());

                          // if (Get.find<AuthController>().userLoggedIn()) {
                          //   if(Get.find<LocationController>().addressList.isEmpty){
                          //     Get.toNamed(GetRouter.getAddressPage());
                          //   }
                          //   else{
                          //     // cartController.addToHistory();
                          //     // cartController.clear();
                          //     Get.offNamed(GetRouter.getInitial());
                          //   }
                          // } else {
                          //   Get.toNamed(GetRouter.getSignInPage());
                          // }
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              top: Dimensions.height10,
                              bottom: Dimensions.height10),
                          child: BigText(text: "Checkout", color: Colors.white),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radius20),
                              color: AppColors.mainColor),
                        ),
                      ),
                    )
                  ],
                )
              : Container(),
        );
      }),
    );
  }
}
