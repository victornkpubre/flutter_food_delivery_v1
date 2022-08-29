import 'package:flutter/material.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/views/account/account_page.dart';
import 'package:food_delivery/views/auth/sign_up_page.dart';
import 'package:food_delivery/views/cart/cart_history.dart';
import 'package:food_delivery/views/cart/cart_page.dart';
import 'package:food_delivery/views/home/main_food_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List pages = [
    MainFoodPage(),
    CartHistory(),
    CartPage(),
    AccountPage(),
  ];

  void _onTapNav(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.mainColor,
        unselectedItemColor: Colors.amberAccent,
        currentIndex: _selectedIndex,
        onTap: _onTapNav,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "home"),
          BottomNavigationBarItem(icon: Icon(Icons.archive), label: "history"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "me"),
        ],
      ),
    );
  }
}
