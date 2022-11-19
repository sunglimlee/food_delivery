import 'package:flutter/material.dart';
import 'package:food_delivery/controller/popular_product_controller.dart';
import 'package:food_delivery/controller/recommended_product_controller.dart';
import 'package:food_delivery/data/repository/cart_repo.dart';
import 'package:food_delivery/model/cart_model.dart';
import 'package:food_delivery/model/products_model.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:get/get.dart';

// Shopping Cart 를 위한 Controller
// 뭘 이렇게 정신없이 디테일 페이지로 들어가면 기존에 카트에 수량을 추가하는 작업도 하고 그러냐? 그냥 추가하면 추가하였다고 메세지 보내고 그리고 0으로 quantity 를 초기화를 하는거지..
// 값을 수정하고 싶으면 카트로 가서 수정해 그러면 된다.
// 그래서 여기 cart_controller 의 함수들과 그리고 popular_product_controller 의 함수들의 대부분 의미가 없게 되었다.
class CartController extends GetxController {
  final CartRepo cartRepo;

  CartController({required this.cartRepo});

  //final RxMap<int, CartModel> _items = <int, CartModel>{}.obs; // 여기 맵을 이용해서 데이터를 다 저장하고..
  Map<int, CartModel> _items = {};

  //https://stackoverflow.com/questions/63841151/flutter-dismiss-selected-dialog-with-getx
  removeItems(int key) async {
    Get.dialog(
      AlertDialog(
        title: Text("Shopping Cart"),
        content: Text("Do you want to remove this item from Shopping Cart?"),
        actions: <Widget>[
          ElevatedButton(
            child: Text("YES"),
            onPressed: () {
              _items.remove(key);
              update();
              Get.find<PopularProductController>().update();
              Get.find<RecommendedProductController>().update();
              Get.back();
            },
          ),
          ElevatedButton(
            child: Text("NO"),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
    );
    //_items.remove(key);
  }

  Map<int, CartModel> get items => _items;

  set items(Map<int, CartModel> value) { // 히스토리에서 _items 로 값을 넣어주는 함수
    _items = {}; // 초기화를 해준다.. 그럼 기존에 오더 하고 있던 내용은 다 지워지는데..
    _items = value;
  }


  List<CartModel> storageItems = []; // Items in Cart. Cart Items.

  // 맵에 넣는 함수
  // addItem 함수를 이용해서 UI 에서 추가 버턴을 클릭하면 다시 Controller 가 추가를 하라는 명령을 CartRepo 에 내려준다.
  // 추가를 하기위해서 당연히 ProductModel 과 quantity 가 들어와야 하고.
  // 이제 이 함수에서 putIfAbasent 를 사용하는데 값이 없을 경우에만 추가를 해준다. 어떤 값으로 비교하냐고? product.id! 로 비교한다.
  // 그래서 그안에서 CartModel 을 만들어서 맵에다가 넣어주게 되는거다.
  void addItem(ProductModel product, int quantity) {
    // 만약 기존에 id 값이 존재하고 있다면 거기에다가 quantity 를 추가해주어야 한다.
    if (_items.containsKey(product.id!)) {
      //print("in CartController. ${product.id!}");
      _items.update(product.id!, (value) {
        return CartModel(
          id: value.id!,
          name: value.name!,
          price: value.price,
          img: value.img,
          quantity: value.quantity! + quantity,
          // 맞는 말이네.. 기존에 있는건 그대로 두고 거기에 추가로 더하는 거니깐.
          isExit: true,
          time: DateTime.now().toString(),
          product: product,
        );
      });
      print(
          "in CartController. ${product.id!}. ${_items[product.id!]!.quantity}");
    } else {
      if (quantity > 0) {
        print("length of the item is ${_items.length.toString()}");
        // 중복된 자료가 들어가는 걸 방지하기 위해서
        _items.putIfAbsent(product.id!, () {
          print(
              "adding item to the cart ${product.id!.toString()}. quantity $quantity");
          // 데이터가 값이 이미 존재하면 추가가 되지 않는 문제를 해결한다. 순저히 Map 함수에 의존하는 거다.
          _items.forEach((key, value) {
            print("quantity is ${value.quantity.toString()}");
          });
          return CartModel(
            id: product.id,
            name: product.name!,
            price: product.price,
            img: product.img,
            quantity: quantity,
            isExit: true,
            time: DateTime.now().toString(),
            product: product,
          );
        });
      } else {
        Get.snackbar(
            "Item Count", "You should at least add an item in the cart",
            backgroundColor: AppColors.mainColor, colorText: Colors.black);
      }
    }
    // 히스토리를 위해서 CartRepo 에 CartModel 을 저장한다.
    cartRepo.addToCartList(getItems);
    update();
  }

  // 서버에서 받아온 ProductModel.id 와 Map 안에 들어있는 CartModel.id 가 같은게 있는지 확인해서 들어갈 때 그 값을 보여주고 add, remove 를 해주도록 한다. 그게 제일 맞는것 같다.
  bool existInCart(ProductModel product) {
    if (_items.containsKey(product.id!)) {
      // 맵에 값이 있는지 확인해서 true, false
      return true;
    }
    return false;
  }

  // 그래서 맵에 값이 있다면 그 값을 받아오는 함수.
  // 여기서도 잘봐라.. 로컬변수를 초기화 하고 그값을 조건문에서 바꾸고 나서 맨마지막에 로컬값을 리턴을 해준다. 아주 중요한 내용이다.
  int getQuantity(ProductModel product) {
    var quantity = 0; // 수량을 저장할 임시 로컬값.
    if (_items.containsKey(product.id!)) {
      _items.forEach((key, value) {
        // 맵을 한바퀴 돌리면서
        if (key == product.id) {
          // 키값이 같은게 있는지 확인한 후
          print("in carat_controller. ${value.quantity}");
          quantity = value.quantity!;
        }
      });
    }
    return quantity;
  }

  // 전체적인 총 갯수를 구하는 함수. 전체 선택한 아이템의 총 갯수를 구한다.
  int get totalItems {
    var totalQuantity = 0;
    _items.forEach((key, value) {
      totalQuantity += value.quantity!; // totalQuantity = totalQuantity + value.quantity!; 같은 뜻이다.
    });

    return totalQuantity;
  }

  // Shopping Cart 에서 사용할 List 로서 CartModel 을 가지고 있는 List 로 구성한다.
  List<CartModel> get getItems {
    // 맵의 entries 를 통해서 전체를 돌면서 그안에 map 함수를 통해서 e.value 값을 리턴하고 그 리턴한 값들을 toList() 로 배열로 만들어서 리턴한다. 두번 리턴한다는 거지.
    return _items.entries.map((e) {
      return e.value;
    }).toList();
  }

  double get totalAmount {
    double total = 0;
    // 내가 직접한다. 현재 가지고 있는 모든 가용자원을 다 사용한다.
    List<CartModel> cartModelItems = getItems; // 일단 리스트로 바꾸어서
    cartModelItems.forEach((element) {
      total += element.quantity!.toDouble() * element.price!.toDouble();
    });
    print('in Cart_controller. totalAmount 힘수 실행후 리턴값은 ${total} 입니다.');
    return total;
  }

  List<CartModel> getCartData() {
    // 최초에 실행시에만 이 함수를 실행시켜서 값을 불러들인다.
    // 아마도 Repo 의 getCartList 에서 길이를 받아서 데이터가 있으면 그데이터를 이용하면 되겠네.. 어떤식으로 데이터를 보낼까? 당연히 객체로 보내면 되지.. List<CartModel>
    //print("in Cart_controller. cartRepo.getCartList() ${cartRepo.getCartList()}");
    setCart = cartRepo.getCartList(); // 괭장히 멋진 내용이다. 왜냐면 Get 함수이면서 안에서 set 함수를 실행시키고 그리면서 다시 return 값을 넘겨주니깐..
    return storageItems; // 최종목표는 _items 에 데이터를 넣는거다.
  }

  set setCart(List<CartModel> items) {
    //cartRepo.setCartList(items);
    storageItems = items;
    print(
        "in Cart_controller. Length of cart items ${storageItems.length.toString()}");

    for (int i = 0; i < storageItems.length; i++) {
      _items.putIfAbsent(storageItems[i].product!.id!, () => storageItems[i]);
    }
    cartRepo.addToCartList(storageItems); // 여기도 추가 해주어야지 정확히 되는거지. 그리고 히스토리에 저장할 때도 cart 리스트를 이용해서 저장이 되는거고...
    print("in cart_controller. _items 의 값은 ${_items.length}");
  }

  void addToHistory() {
    cartRepo.addToCartHistoryList();
    clear();
  }

  void clear() {
    _items = {}; // 전부다 지우고.
    update(); // 다 지워지니깐 화면에서도 다지우고..
  }

  List<CartModel> getCartHistoryList() {
    return cartRepo.getCartHistoryList();
  }


  void addToCartList() { //카트에 _items 의 값을 추가해주는 함수
    cartRepo.addToCartList(getItems);
    update();
  }

  void removeCart() {
    cartRepo.removeCart();
  }
  // Cart History 를 전부 지운다.
  void removeCartHistory() {
    cartRepo.removeCartHistory();
  }
  void updateCart() {
    update();
  }


}
