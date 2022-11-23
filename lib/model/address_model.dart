class AddressModel {
  // fields
  late int? _id; // id 는 뭘까? 각 사람에 대해서 연결되는 아이디? 아니면 그냥 랜덤하게 저장되는 아이디? 마치 키값처럼?
  late String _addressType;
  late String? _contactPersonName;
  late String? _contactPersonNumber;
  late String? _address;
  late String? _latitude;
  late String? _longitude;

  // constructor
  AddressModel(
      {int? id,
      required String addressType,
      String? contactPersonName,
      String? contactPersonNumber,
      String? address,
      String? latitude,
      String? longitude})
      : _id = id,
        _addressType = addressType,
        _contactPersonName = contactPersonName,
        _contactPersonNumber = contactPersonNumber,
        _address = address,
        _latitude = latitude,
        _longitude = longitude;

  // Json 으로 객체를 만든 팩토리 생성자
  factory AddressModel.fromJsonByFactoryConstructor(Map<String, dynamic> json) {
    // named constructor 를 사용해도 되는데 이렇게 factory constructor 를 사용하는 이유는 보는 것처럼 객체를 자체 생성하기 때문에 원하는 상위나 하위 객체까지도
    // 마음대로 만들 수 있다. 그리고 static 처럼 사용되기에 this 를 사용할 수 없고, return 값을 사용해야 한다. 그리고 재사용 클래스도 리턴할 수 있다.
    // 나는 결론적으로 봤을 때 factory constructor 가 훌씬 매력적인것 같다.
    // 물론 named constructor 도 간결하게 사용하기 좋지.
    AddressModel addressModel = AddressModel(
        id: json["id"] ?? "",
        addressType: json["address_type"],
        address: json["address"] ?? "",
        contactPersonName: json["contact_person_name"] ?? "",
        contactPersonNumber: json["contact_person_number"] ?? "",
        latitude: json["latitude"] ?? "",
        longitude: json["longitude"] ?? "");
    return addressModel;
  }

  // 위의 factory consturctor 를 named Constructor 로 만들었을 때 (위에거와 같은 기능을 한다.)
  // 사실 훨씬 named constructor 가 훨씬 간단하다.
  AddressModel.fromJsonByNamedConstructor(Map<String, dynamic> json) {
    _id = json["id"];
    _address = json["address"];
    _addressType = json["address_type"];
    _contactPersonNumber = json["contact_person_number"];
    _contactPersonName = json["contact_person_name"];
    _latitude = json["latitude"];
    _longitude = json["longitude"];
  }

  // getter
  String? get address => _address;

  String? get contactPersonNumber => _contactPersonNumber;

  String? get contactPersonName => _contactPersonName;

  String get addressType => _addressType;

  String? get longitude => _longitude;

  String? get latitude => _latitude;

  // AddressModel to jSon
  // 내가 지금 한가지 아주 착각했던게 벌써 그 객체가 존재하고 있는걸 그냥 Json 으로 바꾸는거잖아.. 그러니깐 this 를 이용해서 바꾸어줘야하는거지...
  // 이거 다음에는 틀리지 않도록 정말 조심하도록 하자.
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = _id;
    json["address"] = _address;
    json["address_type"] = _addressType;
    json["contact_person_number"] = _contactPersonNumber;
    json["contact_person_name"] = _contactPersonName;
    json["latitude"] = _latitude;
    json["longitude"] = _longitude;
    return json;

  }
}
