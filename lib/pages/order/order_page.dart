import 'package:flutter/material.dart';
import 'package:food_delivery/base/custom_app_bar.dart';
import 'package:food_delivery/controller/auth_controller.dart';
import 'package:food_delivery/controller/order_controller.dart';
import 'package:food_delivery/pages/order/view_order.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:get/get.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> with TickerProviderStateMixin {
  late TabController _tabController;
  late bool _isLoggedIn;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = Get.find<AuthController>().userLoggedIn();
    if (_isLoggedIn) {
      _tabController = TabController(length: 2, vsync: this);
      //Get.find<OrderController>().getOrderList();

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "My Orders", ),
      body: Column(
        children: [
          Container(
            width: Dimensions.screenWidth,
            child: TabBar(
              indicatorColor: Theme.of(context).primaryColor,
              indicatorWeight: 3,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Theme.of(context).unselectedWidgetColor,
              controller: _tabController,
              tabs: const [
                Tab(
                  text: "current",
                ),
                Tab(
                  text: "history",
                )
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
                // 이렇게 controller 가 위아래 같이 들어가는구나.. 말되네..
                controller: _tabController,
                children: const [
                  ViewOrder(isCurrent: true,),
                  ViewOrder(isCurrent: false),
                ]),
          ),
        ],
      ),
    );
  }
}
