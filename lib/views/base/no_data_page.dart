

import 'package:flutter/material.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';

class NoDataPage extends StatelessWidget{
  final String text;
  final String imgPath; 

  const NoDataPage({Key? key, required this.text, this.imgPath = "assets/image/empty_cart.png" }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container( 
          width: double.maxFinite, 
          child: Image.asset(imgPath, height: Dimensions.height180/1.1,)
        ),
        SizedBox(height: Dimensions.height30,),
        Text(
          text,
          style: TextStyle(
            fontSize: Dimensions.font24,
            color: AppColors.textColor
          ),
        )
      ],
    );
  }
}