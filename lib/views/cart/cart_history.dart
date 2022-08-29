import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_delivery/controllers/cart_controller.dart';
import 'package:food_delivery/models/cart_model.dart';
import 'package:food_delivery/route/route_helper.dart';
import 'package:food_delivery/utils/app_constants.dart';
import 'package:food_delivery/utils/app_icon.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/views/base/no_data_page.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:food_delivery/widgets/date_widget.dart';
import 'package:food_delivery/widgets/small_text.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CartHistory extends StatefulWidget {
  const CartHistory({Key? key}) : super(key: key);

  @override
  State<CartHistory> createState() => _CartHistoryState();
}

class _CartHistoryState extends State<CartHistory> {
  @override
  Widget build(BuildContext context) {

    //Extracting a list of item Amounts and dates from the cart history
    Map<String, int> cartItemsPerOrder = Map();
    List<CartModel> getCartHistoryList =
        Get.find<CartController>().getCartHistoryList();

    for (int i = 0; i < getCartHistoryList.length; i++) {
      if (cartItemsPerOrder.containsKey(getCartHistoryList[i].time)) {
        cartItemsPerOrder.update(
            getCartHistoryList[i].time.toString(), (value) => ++value);
      } else {
        cartItemsPerOrder.putIfAbsent(
            getCartHistoryList[i].time.toString(), () => 1);
      }
    }

    List<int> cartItemsPerOrderToList() {
      return cartItemsPerOrder.entries.map((e) => e.value).toList();
    }

    List<String> cartOrderTimeToList() {
      return cartItemsPerOrder.entries.map((e) => e.key).toList();
    }

    List<int> itemsPerOrder = cartItemsPerOrderToList();

    var listCounter = 0;

    return Scaffold(
      body: Column(
        children: [
          //Header
          Container(
            padding: EdgeInsets.only(top: Dimensions.height20*2.2, bottom: Dimensions.height20, left: Dimensions.width20*2, right: Dimensions.width20*2),
            color: AppColors.mainColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BigText(text: "Cart History", color: Colors.white),

                GetBuilder<CartController>(builder: (_cartController) {
                  var total = _cartController.getItems.length;
                  return GestureDetector(
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
                }),
                
                // GestureDetector(
                //   onTap: () => Get.toNamed(GetRouter.getCartPage()),
                //   child: AppIcon(
                //     icon: Icons.shopping_cart_outlined,
                //     iconColor: AppColors.mainColor,
                //     backgroundColor: AppColors.yellowColor,
                //   ),
                // )
              ],
            ),
          ),
          
          //Body
          GetBuilder<CartController>(
            builder: (_cartController) {
              return _cartController.getCartHistoryList().isNotEmpty? Expanded(
                child: Container(
                  //List of Orders
                  child: MediaQuery.removePadding(
                    removeTop: true,
                    context: context,
                    child: ListView(
                      children: [
                        for (int i = 0; i < itemsPerOrder.length; i++)
                          Container(
                            margin: EdgeInsets.symmetric(vertical: Dimensions.height15, horizontal: Dimensions.width30*2),
                            //height: Dimensions.screenHeight/6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // (() {
                                  
                                // }()),
                                DateWidget(item: getCartHistoryList[listCounter]),
                                SizedBox(height: Dimensions.height10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Wrap(
                                        direction: Axis.horizontal,
                                        children:
                                            List.generate(itemsPerOrder[i], (index) {
                                          if (listCounter <
                                              getCartHistoryList.length) {
                                            listCounter++;
                                          }
                                          return Container(
                                            height: Dimensions.height20 * 4,
                                            width: Dimensions.height20 * 4,
                                            margin: EdgeInsets.only(
                                                right: Dimensions.width10 / 2),
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        AppConstants.BASE_URL +
                                                            AppConstants.UPLOADS_URL +
                                                            getCartHistoryList[
                                                                    listCounter - 1]
                                                                .img!))),
                                          );
                                        })),
                                    Container(
                                      height: Dimensions.height20 * 4,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          SmallText(
                                            text: "Total",
                                            color: AppColors.titleColor,
                                          ),
                                          BigText(
                                            text:
                                                itemsPerOrder[i].toString() + "Items",
                                            color: AppColors.mainBlackColor,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              var orderTime = cartOrderTimeToList();
                                              Map<int, CartModel> moreOrder = {};
                                              for (int j = 0; j < getCartHistoryList.length; j++) {
                                                if (getCartHistoryList[j].time == orderTime[i]) {
                                                  moreOrder.putIfAbsent(
                                                      getCartHistoryList[j].id!,
                                                      (() => CartModel.fromJson(
                                                          jsonDecode(jsonEncode(
                                                              getCartHistoryList[
                                                                  j]))))
                                                  );
                                                }
                                              }
                                              Get.find<CartController>().setItems=moreOrder;
                                              Get.find<CartController>().addToCartList();
                                              Get.toNamed(GetRouter.getCartPage());
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: Dimensions.height10 / 2,
                                                  horizontal: Dimensions.width10),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(
                                                      Dimensions.radius15 / 2),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: AppColors.mainColor)),
                                              child: SmallText(
                                                  text: "Reorder",
                                                  color: AppColors.mainColor),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ): Expanded(child: NoDataPage(text: "Your History is empty", imgPath: "assets/image/empty_box.png",));
            }
          )
        ],
      ),
    );
  }
}
