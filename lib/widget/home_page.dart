import 'package:flutter/material.dart';
import 'package:food_delivery/pages/cart/cart_history.dart';
import 'package:food_delivery/pages/home/main_food_page.dart';
import 'package:food_delivery/utils/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List pages = [
    MainFoodPage(),
    Center(
        child: Container(
          child: Text('page1'),
        )),
    Center(
        child: Container(
          child: CartHistory(),
        )),
    Center(
        child: Container(
          child: Text('page3'),
        )),
  ];

  void onTapNav(int pageNo) {
    // 순전히 내가 다 만든거다. 이제 이정도는 해야지..
    setState(() {
      _selectedIndex = pageNo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      // 화면에 안나오는 이유가 뭘까?
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xD8E5FDE6),
          onTap: onTapNav,
          elevation: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: AppColors.mainColor,
          unselectedItemColor: Colors.black26,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "home"),
            BottomNavigationBarItem(icon: Icon(Icons.accessible_outlined), label: "history"),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: "shopping Cart"),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "profile"),
          ]),
    );
  }
}
