import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/controllers/popular_product_controller.dart';
import 'package:food_delivery/controllers/recommended_products_controller.dart';
import 'package:food_delivery/models/product_model.dart';
import 'package:food_delivery/route/route_helper.dart';
import 'package:food_delivery/utils/app_constants.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/views/food/popular_food_detail.dart';
import 'package:food_delivery/widgets/app_column.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:food_delivery/widgets/icon_text_widget.dart';
import 'package:food_delivery/widgets/small_text.dart';
import 'package:get/get.dart';

class FoodPageCarousel extends StatefulWidget {
  const FoodPageCarousel({Key? key}) : super(key: key);

  @override
  State<FoodPageCarousel> createState() => _FoodPageCarouselState();
}

class _FoodPageCarouselState extends State<FoodPageCarousel> {
  PageController pageController = PageController(viewportFraction: 0.85);
  var _currentPageValue = 0.0;
  double _scaleFactor = 0.8;
  double _height = Dimensions.pageView;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController.addListener(() {
      setState(() {
        _currentPageValue = pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            //Carousel
            GetBuilder<PopularProductController>(builder: (popularProducts) {
              return popularProducts.isLoaded
                  ? Container(
                      height: Dimensions.pageView,
                      child: PageView.builder(
                          controller: pageController,
                          itemCount: popularProducts.popularProductList.length,
                          itemBuilder: (context, index) {
                            return Center(
                              child: _buildPageItem(index,
                                  popularProducts.popularProductList[index]),
                            );
                          }),
                    )
                  : Container(
                      padding: EdgeInsets.only(
                          top: Dimensions.popularFoodImgSize / 2,
                          bottom: Dimensions.popularFoodImgSize / 2,
                          left: Dimensions.width30 * 4,
                          right: Dimensions.width30 * 4),
                      child: LinearProgressIndicator(),
                    );
            }),
            SizedBox(height: Dimensions.height10),

            //Carousel - Indicator
            GetBuilder<PopularProductController>(builder: (popularProducts) {
              return DotsIndicator(
                dotsCount: popularProducts.popularProductList.isEmpty
                    ? 1
                    : popularProducts.popularProductList.length,
                position: _currentPageValue,
                decorator: DotsDecorator(
                  activeColor: AppColors.mainColor,
                  size: const Size.square(9.0),
                  activeSize: const Size(18.0, 9.0),
                  activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                ),
              );
            }),
            SizedBox(height: Dimensions.height30),

            //Recommended section
            Container(
              margin: EdgeInsets.only(left: Dimensions.width30),
              child: Row(
                children: [
                  BigText(text: "Recommended"),
                  SizedBox(width: Dimensions.width10),
                  const Icon(Icons.circle, size: 5),
                  SizedBox(width: Dimensions.width10),
                  Container(
                    child: SmallText(text: "Food Pairing"),
                  )
                ],
              ),
            ),

            //Food List
            GetBuilder<RecommendedProductController>(
                builder: (recommendedProduct) {
              return Container(
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: recommendedProduct.recommendedProductList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed(
                              GetRouter.getRecommendedFoodPage(index, "home"));
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              left: Dimensions.width20,
                              right: Dimensions.width20),
                          child: Row(
                            children: [
                              //Image
                              Container(
                                  width: Dimensions.listViewImgSize,
                                  height: Dimensions.listViewImgSize,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radius30),
                                      color: Colors.white38,
                                      image: DecorationImage(
                                          image: NetworkImage(AppConstants
                                                  .BASE_URL +
                                              AppConstants.UPLOADS_URL +
                                              recommendedProduct
                                                  .recommendedProductList[index]
                                                  .img!)))),
                              //Summary - Panel
                              Expanded(
                                child: Container(
                                  height: Dimensions.listViewTextContSize,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topRight:
                                          Radius.circular(Dimensions.radius20),
                                      bottomRight:
                                          Radius.circular(Dimensions.radius20),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: Dimensions.width10,
                                        right: Dimensions.width10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        BigText(
                                            text: recommendedProduct
                                                .recommendedProductList[index]
                                                .name!),
                                        SizedBox(height: Dimensions.height10),
                                        SmallText(
                                            text:
                                                "With chinese characteristics"),
                                        SizedBox(height: Dimensions.height10),
                                        //Summary - Details with Icons
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: const [
                                            IconTextWidget(
                                                icon: Icons.circle_sharp,
                                                text: "Normal",
                                                iconColor:
                                                    AppColors.iconColor1),
                                            IconTextWidget(
                                                icon: Icons.location_on,
                                                text: "1.7km",
                                                iconColor: AppColors.mainColor),
                                            IconTextWidget(
                                                icon: Icons.access_time_rounded,
                                                text: "32min",
                                                iconColor:
                                                    AppColors.iconColor2),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPageItem(int index, ProductModel popularProduct) {
    Matrix4 matrix = new Matrix4.identity();

    //index matches currentPage (used to target middle page)
    if (index == _currentPageValue.floor()) {
      var currScale = 1 - (_currentPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    }
    //index is greater than curentPage by 1 (used to target page on the right)
    else if (index == _currentPageValue.floor() + 1) {
      var currScale =
          _scaleFactor + (_currentPageValue - index + 1) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    }
    //index is less than curentPage by 1 (used to target page on the left)
    else if (index == _currentPageValue.floor() - 1) {
      var currScale = 1 - (_currentPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else {
      var currScale = 0.8;
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    }

    //Container always take the height of its parent regardless of is height
    //- overriden using sized box or stack widget
    return Transform(
      transform: matrix,
      child: GestureDetector(
        onTap: () {
          Get.toNamed(GetRouter.getPopularFoodPage(index, "home"));
        },
        child: Stack(
          children: [
            //Image
            Container(
              height: Dimensions.pageViewContainer,
              margin: const EdgeInsets.only(left: 5, right: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: index.isEven
                      ? const Color(0xFF69c5df)
                      : const Color(0xFF9294cc),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(AppConstants.BASE_URL +
                          AppConstants.UPLOADS_URL +
                          popularProduct.img!))),
            ),

            //Details
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: Dimensions.pageViewTextContainer,
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                          color: Color(0xFFe8e8e8),
                          blurRadius: 5,
                          offset: Offset(0, 5)),
                    ]),
                child: Container(
                    padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                    child: AppColumn(text: popularProduct.name!)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
