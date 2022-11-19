// UserProfile 의 내용을 서버에서 불러들이기 위한 Model. 항상 얘기하는 거지만 객체로 모델화가 되어야만 쉽게 주고 받을 수 있다.
// 일단 객체가 되면 그냥 JSon 으로 변경해서 주고 받기만 하면 되거덩...
class UserModel {
  int _id;
  int _fName;
  String _email;
  String _phone;
  int _orderCount;

  int get id => _id;

  UserModel(
      {required id,
      required fName,
      required email,
      required phone,
      required orderCount})
      : _id = id,
        _fName = fName,
        _email = email,
        _phone = phone,
        _orderCount = orderCount;

  // 서버에서 들어오는 json 파일은 더 많은 정보가 넘어오는구나.. 그런데 여기에서 내가 필요로 하는 것만 빼서 객체를 만드는구나.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json["id"],
        fName: json["f_name"],
        email: json["email"],
        phone: json["phone"],
        orderCount: json["order_count"]);
  }

  int get fName => _fName;

  String get email => _email;

  String get phone => _phone;

  int get orderCount => _orderCount;
}
