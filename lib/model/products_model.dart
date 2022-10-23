class Product {
  int? _totalSize;
  int? _typeId;
  int? _offset;
  late List<ProductModel> _product;

  List<ProductModel> get products => _product; // getter

  Product(
      {required totalSize, required typeId, required offset, required product})
      : _totalSize = totalSize,
        _typeId = typeId,
        _offset = offset,
        _product = product;

  Product.fromJson(Map<String, dynamic> json) {
    _totalSize = json['total_size'];
    _typeId = json['type_id'];
    _offset = json['offset'];
    if (json['products'] != null) {
      _product = <ProductModel>[];
      json['products'].forEach((v) {
        _product.add(ProductModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = _totalSize;
    data['type_id'] = _typeId;
    data['offset'] = _offset;
    data['products'] = _product.map((v) => v.toJson()).toList();
    return data;
  }
}

class ProductModel {
  int? id;
  String? name;
  String? description;
  int? price;
  int? stars;
  String? img;
  String? location;
  String? createdAt;
  String? updatedAt;
  int? typeId;

  ProductModel(
      {id,
      name,
      description,
      price,
      stars,
      img,
      location,
      createdAt,
      updatedAt,
      typeId})
      : id = id,
        name = name,
        description = description,
        price = price,
        stars = stars,
        img = img,
        location = location,
        createdAt = createdAt,
        updatedAt = updatedAt,
        typeId = typeId;

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    stars = json['stars'];
    img = json['img'];
    location = json['location'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    typeId = json['type_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['stars'] = stars;
    data['img'] = img;
    data['location'] = location;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['type_id'] = typeId;
    return data;
  }
}
