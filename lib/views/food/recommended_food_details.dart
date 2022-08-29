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
import 'package:food_delivery/widgets/big_text.dart';
import 'package:food_delivery/widgets/expandable_text.dart';
import 'package:food_delivery/widgets/small_text.dart';
import 'package:get/get.dart';

class RecommendedFoodDetails extends StatefulWidget {
  final int pageId;
  final String page;

  RecommendedFoodDetails({Key? key, required this.pageId, required this.page}) : super(key: key);

  @override
  State<RecommendedFoodDetails> createState() => _RecommendedFoodDetailsState();
}

class _RecommendedFoodDetailsState extends State<RecommendedFoodDetails> {
  @override
  Widget build(BuildContext context) {
    var product = Get.find<RecommendedProductController>().recommendedProductList[widget.pageId];
    Get.find<PopularProductController>().initProduct(product, Get.find<CartController>());
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            //Back and Cart Icons
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                
                GetBuilder<PopularProductController>(builder: (popularProduct) {
                    var total = Get.find<PopularProductController>().totalItems;
                    return !popularProduct.isLoaded? Container(): GestureDetector(
                      onTap: () {
                        Get.toNamed(GetRouter.getCartPage());
                      },
                      child: Stack(
                        children: [
                          AppIcon(icon: Icons.shopping_cart),
                          Positioned(
                            child: total>=1? Container(
                              padding: EdgeInsets.all(Dimensions.width10/2),
                              decoration: BoxDecoration(
                                color: AppColors.mainColor,
                                borderRadius: BorderRadius.all(Radius.circular(Dimensions.width10*2))
                              ),
                              child: SmallText(
                                text: total.toString(),
                                color: Colors.white,
                                size: 12
                              ),
                            ):
                            Container()
                          )
                        ],
                      ),
                    );
                  }
                )
              ],
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
                child: Center(
                    child: BigText(
                  text: product.name!,
                  size: Dimensions.font26,
                )),
                width: double.maxFinite,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(Dimensions.radius30),
                        topRight: Radius.circular(Dimensions.radius30))),
              ),
            ),
            pinned: true,
            backgroundColor: AppColors.yellowColor,
            toolbarHeight: 100,
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                AppConstants.BASE_URL + AppConstants.UPLOADS_URL + product.img!,
                fit: BoxFit.cover,
                width: double.maxFinite,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: Dimensions.height30),
                  child: ExpandableText(
                      text: product.description!
                  ),
                
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: GetBuilder<PopularProductController>(
        builder: (controller) {
          return Container(
            color: AppColors.buttonBackgroundColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: Dimensions.width20,
                      horizontal: Dimensions.height30 * 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => controller.setQuantity(false),
                        child: AppIcon(
                          icon: Icons.remove,
                          iconColor: Colors.white,
                          backgroundColor: AppColors.mainColor,
                          iconSize: Dimensions.iconSize24,
                        ),
                      ),
                      BigText(text: "\$${product.price!} X ${controller.inCartItems.toString()}", color: AppColors.mainColor),
                      GestureDetector(
                        onTap: () => controller.setQuantity(true),
                        child: AppIcon(
                          icon: Icons.add,
                          iconColor: Colors.white,
                          backgroundColor: AppColors.mainColor,
                          iconSize: Dimensions.iconSize24,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width30 * 2,
                      vertical: Dimensions.height20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(Dimensions.width20 * 2))),
                          padding: EdgeInsets.all(Dimensions.width30),
                          child: Icon(
                            Icons.favorite,
                            size: Dimensions.iconSize28,
                            color: AppColors.mainColor,
                          )),
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
                            controller.addItemtoCart(product);
                          },
                          child: BigText(
                            text: "\$${product.price} | Add to Cart",
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      ),
    
    );
  }
}
