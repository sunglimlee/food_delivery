import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_delivery/base/no_data_page.dart';
import 'package:food_delivery/controller/cart_controller.dart';
import 'package:food_delivery/model/cart_model.dart';
import 'package:food_delivery/routes/route_helper.dart';
import 'package:food_delivery/utils/app_constants.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widget/big_text.dart';
import 'package:food_delivery/widget/small_text.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CartHistory extends StatelessWidget {
  const CartHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 히스토리를 보여주기 위해서 맵과 리스트를 이용해서 뿌릴 준비를 DartPad 를 이용해서 만들어 주었다.
    var getCartHistoryList = Get.find<CartController>().getCartHistoryList().reversed.toList(); // 최신 날짜순으로 보여주려고 reverse 했다.
    Map<String, int> cartItemsPerOrder = {};

    for (int i = 0; i < getCartHistoryList.length; i++) {
      // 같은 갯수가 몇개인지 알기 위함.
      if (cartItemsPerOrder.containsKey(getCartHistoryList[i].time)) {
        // key time 의 시간자체를 key 로 만든다는 것.
        cartItemsPerOrder.update(
            getCartHistoryList[i].time!,
            (value) =>
                ++value); // 두번째게 돌때 같은 키값이 있는지 확인하고 있으면 해당하는 키값을 1 증가 시키라는 의미
      } else {
        cartItemsPerOrder.putIfAbsent(getCartHistoryList[i].time!,
            () => 1); // time 안에 들어있는 값을 키로하고 그 키값이 없으면 키 값을 1로 정한다.
      }
    }
    List<String> timeValue =
        cartItemsPerOrder.entries.map((e) => e.key).toList();

    // 시간 형식을 바꾸기 위해서 사용
    String changeTimeFormat(String time) {
      print("/////////////// ${time}");
      var str = time; //"the quick brown fox jumps over the lazy dog";
      const start = "20";
      const end = ".";

      final startIndex = time.indexOf(start);
      final endIndex = time.indexOf(end, startIndex + start.length);
      //print("endindex 의 값은 ${endIndex.toString()}");
      return time.toString().substring(0, endIndex - 3);
    }
    //print(cartItemsPerOrder);
    //print(getCartHistoryList[0]["time"]);

    List<int> cartItemsPerOrderToList() {
      return cartItemsPerOrder.entries.map((e) => e.value).toList();
    }
    //print(cartOrderTimeToList());

    List<String> cartOrderTimeToList() {
      return cartItemsPerOrder.entries.map((e) => e.key).toList(); // 이렇게 하면 타임만 나오는 리스트가 만들어진다.
    }


    List<int> itemsPerOrder = cartItemsPerOrderToList();  // 3, 2, 3
    //var total1 = 0;
    //orderTimes.forEach((e) => total1 += e);
    //print(total1);

    var listCounter = 0;

/*
    for (int x = 0; x < cartItemsPerOrder.length; x++) {
      for (int y = 0; y < itemsPerOrder[x]; y++) {
        if (y == 0) {
          //print(getCartHistoryList[listCounter].time!.toString());
        } // 시간으로 제목을 넣은 부분
        //print("My order is ${getCartHistoryList[listCounter++].toString()}");
        if (y == itemsPerOrder[x] - 1) {
          //print("\n");
        }
      }
    }
*/
    //print("시간값은 ${changeTimeFormat(timeValue[0])}");


    void convert_getCartHistoryList_to_items() { // List<CartModel> -> Map<int, CartModel> 바꾸어야 함
      Map map = {for (var item in getCartHistoryList) '${item.id}' : getCartHistoryList};
      print("변경된 map의 값은 : ${map}");
    }
    //convert_getCartHistoryList_to_items();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: Dimensions.height10 * 11, // 이걸 몇번이나 했는데 왜 자꾸 잊지? toolbarHeight..
        backgroundColor: AppColors.mainColor,
        title: BigText(text: 'Cart History'),
        actions: [
          Padding( // 패딩으로 감싼건 오른쪽만 떨어뜨리는 신의 한수..
            padding: EdgeInsets.only(
              right: Dimensions.edgeInsets20,
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          GetBuilder<CartController>(builder: (cartController){
            return cartController.getCartHistoryList().length > 0 ? Expanded( // 리스트뷰때문에 Expanded 위젯을 사용한다. 이제는 이건 알겠다.
              child: Container(
                margin: EdgeInsets.only(
                    top: Dimensions.height20,
                    left: Dimensions.height20,
                    right: Dimensions.height20),
                child: ListView( // ListView.Builder 를 사용하지 않았다. 그냥 ListView 만 사용했다 그러면 일일이 children:[] 을 만들어 줘야 한다.
                  // 리스트뷰는 항상 길이가 있어야 한다.
                  children: [
                    // Merging Widget into a collection. 모든 갈증이 해결되는 느낌이네... 이렇게 반복문으로 더 많은 내용을 넣을 수 있다.
                    for (int i = 0; i < itemsPerOrder.length; i++)...[  //여기서는 3번만 반복된다는걸 반드시 기억하자.
                      // 이렇게 반복을 넣을 수 있는데 괄호는 안된다????
                      Container(
                        margin: EdgeInsets.only(bottom: Dimensions.height20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // immediately invoke function, 위젯안에서 실행할 수 있네.. Grammar 너무 중요한거다.
                            // https://medium.com/dartlang/3-cool-dart-patterns-6d8d9d3d8fb8
                            // part 2 06:05:25 에서 체크하자. 제작자는 오류가 나서 수정했는데 나는 괜찮다.
                            (() {
                              // 날짜 보여주는 곳이잖아!.
                              var original = DateFormat("yyyy-MM-dd HH:mm:ss")
                                  .parse(timeValue[
                              i]); // 텍스트를 정해진 형식대로 DateTime 으로변경
                              var inputDate = DateTime.parse(original.toString());
                              var outputFormat = DateFormat(
                                  "MM/dd/yyyy hh:mm a"); // 아웃풋 포맷은 이것으로 하기로 하고
                              var outputDate = outputFormat.format(
                                  inputDate); // 그 아웃풋 형식에 맞게 다른 DateTime 형식을 넣어준다. 그러면 문자열 리턴
                              return BigText(text: outputDate); // 그러면 그거 사용
                              /*return BigText( // 이건 내가 작업한 거고..
                              text: changeTimeFormat(timeValue[i]),
                            );*/
                            }()),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Wrap(
                                  direction: Axis.horizontal,
                                  children: // 이자체가 리스트이므로 [] 할필요가 없지
                                  List.generate(itemsPerOrder[i], (index) { // 3. 2. 3, 총 3번돌아가는 첫번째 돌때 리스트 3개만들고, 두번째 돌때 리스트 2개만들고, 세번째 돌때 리스트 3개 반든다.
                                    print(
                                        "in Cart_history. itemPerOrder[i] ${itemsPerOrder[i]}");
                                    if (listCounter < getCartHistoryList.length) { // 오류를 막기 위해서 필요하다.
                                      listCounter++;
                                    }
                                    return index <= 2 // 최대 3개까지만 그림을 그리겠다는것
                                        ? Container(
                                      height: Dimensions.height20*4,
                                      width: Dimensions.height20*4,
                                      margin: EdgeInsets.only(
                                          right: Dimensions.edgeInsets20),
                                      decoration: BoxDecoration(
                                        //color: Colors.red,
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.radius15 / 2),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(AppConstants
                                                .BASE_URL +
                                                AppConstants.UPLOAD_URL +
                                                // 이렇게하면 반복되면서 결국 전체 이미지를 다 그려주게 된다.
                                                getCartHistoryList[
                                                listCounter - 1]
                                                    .img!)),
                                      ),
                                    )
                                        : Container();
                                  }),
                                ),
                                Container(
                                  height: Dimensions.height30 * 4,
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SmallText(
                                        text: "Total",
                                        color: AppColors.titleColor,
                                      ),
                                      BigText(
                                        text: "${itemsPerOrder[i]} items",
                                        color: AppColors.titleColor,
                                      ),
                                      GestureDetector(
                                        onTap: (){
                                          // 이게 시간이 들어있는거지
                                          List<String> ordertime = cartOrderTimeToList(); // 지금 리스트뷰 돌아가는 곳의 해당 타임을 가지고 온거다. 이거부터 해야 되는거 맞는데.. 대단하다.
                                          //print("in cart_history. ordertime  ${ordertime[i]}");
                                          // 이제 위의 이 리스트가 회전할 때 정해진 타임 ordertime[i] 를 가지고 getCartHistoryList 에서 새로운 맵을 추출한다.
                                          // 클릭하는 부분이니깐 새롭게 만들어도 괜찮지..
                                          Map<int, CartModel> moreOrder = {};
                                          // 기억해라 GestureDector 안에 있는거로 반복문과는 조금밖에 관련없다.
                                          for (int j=0; j<getCartHistoryList.length; j++) {
                                            if (getCartHistoryList[j].time == ordertime[i].toString()) { // 위의 반복문의 i
                                              moreOrder.putIfAbsent(getCartHistoryList[j].id!, () => getCartHistoryList[j]!); // 새로운 Map 을 만들어 값을 넣는걸 putIfAbsent 를 사용한다.
                                              // CartModel.fromJson(jsonDecode(jsonEncode(getCartHistoryList[j]!))); // 아직도 왜 이렇게 해야하는지 모르겠다.
                                              print("in cart_history. Product info is ${jsonEncode(getCartHistoryList[j])}");
                                            }
                                          }
                                          Get.find<CartController>().items = moreOrder; // setter 이므로 이렇게 해야한다.
                                          Get.find<CartController>().addToCartList(); // 카트에다가 추가시켜준다.
                                          Get.toNamed(RouteHelper.getCartPage());
                                        },
                                        child: Container(
                                          //padding: EdgeInsets.symmetric(horizontal: Dimensions.edgeInsets5, vertical: Dimensions.edgeInsets5),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.radius15 / 3),
                                            border: Border.all(
                                                width: 1,
                                                color: AppColors.mainColor),
                                          ),
                                          child: SmallText(
                                            text: "one more",
                                            color: AppColors.mainColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                           ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ) : Center(child: Container(height: MediaQuery.of(context).size.height/1.5,child: const NoDataPage(text: "You didn't buy anything so far")));
          }),
        ],
      ),
    );
  }
}
