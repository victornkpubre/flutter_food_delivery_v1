import 'package:flutter/material.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widgets/icon_text_widget.dart';
import 'package:food_delivery/widgets/small_text.dart';

import 'big_text.dart';

class AppColumn extends StatelessWidget {
  final String text;

  const AppColumn({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BigText(text: text),
        SizedBox(height: Dimensions.height10),
        //Rating and Comments Section
        Row(
          children: [
            Wrap(
              children: List.generate(5, (index) {
                return const Icon(
                  Icons.star,
                  size: 12,
                  color: AppColors.mainColor,
                );
              }),
            ),
            const SizedBox(width: 10),
            SmallText(text: "4.5"),
            const SizedBox(width: 15),
            SmallText(text: "12300"),
            const SizedBox(width: 5),
            SmallText(text: "comments"),
          ],
        ),
        SizedBox(height: Dimensions.height20),
        //Summary - Details with Icons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            IconTextWidget(
                icon: Icons.circle_sharp,
                text: "Normal",
                iconColor: AppColors.iconColor1),
            IconTextWidget(
                icon: Icons.location_on,
                text: "1.7km",
                iconColor: AppColors.mainColor),
            IconTextWidget(
                icon: Icons.access_time_rounded,
                text: "32min",
                iconColor: AppColors.iconColor2),
          ],
        ),
      ],
    );
  }
}
