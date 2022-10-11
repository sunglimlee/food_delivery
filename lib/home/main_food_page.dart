import 'package:flutter/material.dart';
import 'package:food_delivery/home/food_page_body.dart';
import 'package:food_delivery/home/food_page_header_bar.dart';

class MainFoodPage extends StatelessWidget {
  const MainFoodPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 15, bottom: 15),
          //padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: const [
              FoodPageHeaderBar(),
              FoodPageBody(),
            ],
          ),
        ),
      ),
    );
  }
}
