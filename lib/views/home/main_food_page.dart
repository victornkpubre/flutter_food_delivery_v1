import 'package:flutter/material.dart';
import 'package:food_delivery/views/home/food_page_carousel.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:food_delivery/widgets/small_text.dart';

class MainFoodPage extends StatefulWidget {
  const MainFoodPage({Key? key}) : super(key: key);

  @override
  State<MainFoodPage> createState() => _MainFoodPageState();
}

class _MainFoodPageState extends State<MainFoodPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double mainContainerHPadding = width * 0.5 / 10;
    double mainContainerVPadding = height * 0.5 / 10;

    return Scaffold(
      body: Container(
        child: Container(
          margin: EdgeInsets.only(
              top: mainContainerVPadding,
              left: mainContainerHPadding,
              right: mainContainerHPadding),

          //Main Layout Column
          child: Column(
            children: [
              //Top Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Header - Location
                  Column(
                    children: [
                      BigText(
                        text: 'Nigeria',
                        color: AppColors.mainColor,
                      ),
                      SmallText(
                        text: "Lagos",
                        color: Colors.black54,
                      ),
                    ],
                  ),

                  //Search Icon
                  Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColors.mainColor,
                      ),
                      child: const Icon(Icons.search, color: Colors.blue))
                ],
              ),
              SizedBox(
                height: 10,
              ),

              //Carousel
              const FoodPageCarousel()
            ],
          ),
        ),
      ),
    );
  }
}
