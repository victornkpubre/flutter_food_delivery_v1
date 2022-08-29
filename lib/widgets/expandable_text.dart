import 'package:flutter/material.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widgets/small_text.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  const ExpandableText({Key? key, required this.text}) : super(key: key);

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  late String firstHalf;
  late String secondHalf;

  bool hiddenText = true;
  double textHeight = Dimensions.screenHeight / 5.63;

  @override
  void initState() {
    super.initState();
    if (widget.text.length > textHeight) {
      firstHalf = widget.text.substring(0, textHeight.toInt());
      secondHalf =
          widget.text.substring(textHeight.toInt() + 1, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondHalf.isEmpty
          ? SmallText(text: firstHalf, size: Dimensions.font24, color: AppColors.paraColor,)
          : Column(
              children: [
                SmallText(
                  color: AppColors.paraColor,
                  size: Dimensions.font24,
                    text: hiddenText
                        ? (firstHalf + "...")
                        : firstHalf + secondHalf),
                InkWell(
                  onTap: () {
                    setState(() {
                      hiddenText = !hiddenText;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: Dimensions.height10, bottom: Dimensions.height20),
                    child: Row(
                      children: [
                        SmallText(
                          text: "Show more",
                          color: Color.fromARGB(255, 137, 218, 191),
                          size: Dimensions.font24,
                        ),
                        Icon(
                          hiddenText?
                          Icons.arrow_drop_down:
                          Icons.arrow_drop_up,
                          color: AppColors.mainColor,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
