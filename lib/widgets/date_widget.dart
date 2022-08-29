import 'package:flutter/material.dart';
import 'package:food_delivery/models/cart_model.dart';
import 'package:intl/intl.dart';

class DateWidget extends StatelessWidget {
  CartModel item;

  DateWidget({ required this.item, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss")
        .parse(item.time!);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat("MM/dd/yyyy hh:mm a");
    var outputDate = outputFormat.format(inputDate);
    return Text(item.time!);
  }
}
