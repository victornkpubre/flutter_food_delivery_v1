import 'package:flutter/material.dart';
import 'package:food_delivery/utils/app_icon.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widgets/big_text.dart';

class AccountWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color bg_color;

  const AccountWidget({ required this.icon, required this.text, Key? key, required this.bg_color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.width20*2, vertical: Dimensions.width15),
      child: Row(
        children: [
          AppIcon(
            icon: icon,
            backgroundColor: bg_color,
            iconColor: Colors.white,
            iconSize: Dimensions.height10 * 5/2,
            size: Dimensions.height10 * 5,
          ),
          SizedBox(width: Dimensions.width20),
          BigText(text: text,)
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
    );
  }
}
