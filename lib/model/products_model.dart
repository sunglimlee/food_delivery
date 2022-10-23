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
  int? _id;
  String? _name;
  String? _description;
  int? _price;
  int? _stars;
  String? _img;
  String? _location;
  String? _createdAt;
  String? _updatedAt;
  int? _typeId;

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
      : _id = id,
        _name = name,
        _description = description,
        _price = price,
        _stars = stars,
        _img = img,
        _location = location,
        _createdAt = createdAt,
        _updatedAt = updatedAt,
        _typeId = typeId;

  ProductModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _description = json['description'];
    _price = json['price'];
    _stars = json['stars'];
    _img = json['img'];
    _location = json['location'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _typeId = json['type_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['description'] = _description;
    data['price'] = _price;
    data['stars'] = _stars;
    data['img'] = _img;
    data['location'] = _location;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['type_id'] = _typeId;
    return data;
  }
}
