// Shopping Cart 에 대한 CartModel
// 여기서 카트 모델을 이용해서 어떻게 데이터를 저장하는지 확인하자.
// CartMdel 에 상당히 많은 정보가 들어가네.. id 를 이용하는 것도 확인해보고..
import 'package:food_delivery/model/products_model.dart';

class CartModel {
  int? id;
  String? name;
  int? price;
  String? img;
  int? quantity;
  bool? isExit;
  String? time;
  ProductModel? product;

  CartModel({
    id,
    name,
    price,
    img,
    quantity,
    isExit,
    time,
    product,
  })  : id = id,
        name = name,
        price = price,
        img = img,
        quantity = quantity,
        isExit = isExit,
        time = time,
        product = product;

  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    img = json['img'];
    quantity = json['quantity'];
    isExit = json['isexit'];
    time = json['time'];
    product = ProductModel.fromJson(json['product']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['img'] = img;
    data['quantity'] = quantity;
    data['isexit'] = isExit;
    data['time'] = time;
    data['json'] = product?.toJson();
    return data;
  }
}
