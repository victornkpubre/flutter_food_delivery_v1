import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_delivery/controllers/cart_controller.dart';
import 'package:food_delivery/controllers/popular_product_controller.dart';
import 'package:food_delivery/controllers/recommended_products_controller.dart';
import 'package:food_delivery/route/route_helper.dart';
import 'package:food_delivery/utils/app_constants.dart';
import 'package:food_delivery/utils/app_icon.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/views/cart/cart_page.dart';
import 'package:food_delivery/widgets/app_column.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:food_delivery/widgets/expandable_text.dart';
import 'package:food_delivery/widgets/small_text.dart';
import 'package:get/get.dart';

class PopularFoodDetail extends StatefulWidget {
  int pageId;
  String page;

  PopularFoodDetail({Key? key, required this.pageId, required this.page})
      : super(key: key);

  @override
  State<PopularFoodDetail> createState() => _PopularFoodDetailState();
}

class _PopularFoodDetailState extends State<PopularFoodDetail> {
  @override
  Widget build(BuildContext context) {
    var product =
        Get.find<PopularProductController>().popularProductList[widget.pageId];
    Get.find<PopularProductController>()
        .initProduct(product, Get.find<CartController>());

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(children: [
          Positioned(
            left: 0,
            right: 0,
            child: Container(
              width: double.maxFinite,
              height: Dimensions.popularFoodImgSize,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(AppConstants.BASE_URL +
                          AppConstants.UPLOADS_URL +
                          product.img!))),
            ),
          ),

          //Back and Cart Button
          Positioned(
            top: Dimensions.height45,
            left: Dimensions.width20,
            right: Dimensions.width20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    if (widget.page == "cartPage") {
                      Get.toNamed(GetRouter.getCartPage());
                    } else {
                      Get.toNamed(GetRouter.getInitial());
                    }
                  },
                  child: AppIcon(icon: Icons.clear)
                ),
                GetBuilder<PopularProductController>(builder: (popularProduct) {
                  var total = Get.find<PopularProductController>().totalItems;
                  return !popularProduct.isLoaded
                      ? Container()
                      : GestureDetector(
                          onTap: () {
                            Get.toNamed(GetRouter.getCartPage());
                          },
                          child: Stack(
                            children: [
                              AppIcon(icon: Icons.shopping_cart),
                              Positioned(
                                  child: total >= 1
                                      ? Container(
                                          padding: EdgeInsets.all(
                                              Dimensions.width10 / 2),
                                          decoration: BoxDecoration(
                                              color: AppColors.mainColor,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      Dimensions.width10 * 2))),
                                          child: SmallText(
                                              text: total.toString(),
                                              color: Colors.white,
                                              size: 12),
                                        )
                                      : Container())
                            ],
                          ),
                        );
                })
              ],
            ),
          ),

          //Food Summary
          Positioned(
            left: 0,
            right: 0,
            top: Dimensions.popularFoodImgSize - 30,
            bottom: 0,
            child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width30 * 2,
                    vertical: Dimensions.height30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimensions.radius30),
                    topRight: Radius.circular(Dimensions.radius30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppColumn(text: "Chinese Side"),
                    SizedBox(height: Dimensions.height20),
                    BigText(text: "Introduce"),
                    Expanded(
                      child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: ExpandableText(text: product.description!)),
                    )
                  ],
                )),
          ),
        ]),
      ),
      bottomNavigationBar:
          GetBuilder<PopularProductController>(builder: (popularProduct) {
        return Container(
          height: Dimensions.bottomHeightBar,
          padding: EdgeInsets.only(
            left: Dimensions.width30,
            right: Dimensions.width30,
          ),
          decoration: BoxDecoration(
              color: AppColors.buttonBackgroundColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimensions.radius20 * 2),
                  topRight: Radius.circular(Dimensions.radius20 * 2))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(
                    left: Dimensions.width30,
                    right: Dimensions.width30,
                    bottom: Dimensions.height20,
                    top: Dimensions.height20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius30),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        popularProduct.setQuantity(false);
                      },
                      child: Icon(
                        Icons.remove,
                        color: AppColors.signColor,
                      ),
                    ),
                    SizedBox(
                      width: Dimensions.height10,
                    ),
                    BigText(text: popularProduct.inCartItems.toString()),
                    SizedBox(
                      width: Dimensions.height10,
                    ),
                    GestureDetector(
                      onTap: () {
                        popularProduct.setQuantity(true);
                      },
                      child: Icon(
                        Icons.add,
                        color: AppColors.signColor,
                      ),
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
                  borderRadius: BorderRadius.circular(Dimensions.radius30),
                  color: AppColors.mainColor,
                ),
                child: GestureDetector(
                  onTap: () {
                    popularProduct.addItemtoCart(product);
                  },
                  child: BigText(
                    text: "\$${product.price} | Add to Cart",
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
