import 'dart:convert';

import 'package:food_delivery/data/repository/location_repo.dart';
import 'package:food_delivery/model/address_model.dart';
import 'package:food_delivery/model/response_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class LocationController extends GetxController implements GetxService {
  final LocationRepo _locationRepo;
  LocationController({required LocationRepo locationRepo}) : _locationRepo = locationRepo;

  // 로딩하고 있는지 확인하는 필드
  bool _loading = false;

  // geoLocator 에 있는 현재 위치의 값..
  late Position _position;

  // geoLocator 에 있는 선택한 위치의 값
  late Position _pickPosition;

  // GoogleMapController
  late GoogleMapController _mapController;


  // Google map 에 place 를 선택할 수 있다. 이거 괭장히 강력한 컴포넌트이다. 구글맵에서 반드시 사용해야 하는 컴포넌트이다.
  Placemark _placemark = Placemark();

  Placemark _pickPlacemark = Placemark();

  // address 를 보관하기 위한 List
  List<AddressModel> _addressList = [];
  late List<AddressModel> _allAddressList;

  // address type 을 보관하기 위한  List
  // 아직 이 type 이 어떤 역할을 할지는 모르지만 추후에 어떤 기능을 실행하겠네.. TODO
  final List<String> _addressTypeList = ["home", "office", "other"];
  int _addressTypeIndex = 0;

  // 아직 address 를 받기 위한 함수느 없지만 그래도 address 필드는 만들어 놔야지..
  // address 를 맵으로 받고 있네.. 여러개가 있을 수 있다는 건가?
  late Map<String, dynamic> _getAddress;

  // 주소가 업데이트가 되었는지 확인하는 필드
  bool _updateAddressData = true;

  // 주소가 바뀌었는지 확인하는 필드
  bool _changeAddress = true;

  // Getters
  Map get getAddress => _getAddress;
  GoogleMapController get mapController => _mapController;
  bool get loading => _loading;
  Position get pickPosition => _pickPosition;
  Position get position => _position;
  Placemark get placemark => _placemark;
  Placemark get pickPlacemark => _pickPlacemark;
  List<String> get addressTypeList => _addressTypeList;
  int get addressTypeIndex => _addressTypeIndex;
  // 아직 헷갈리는게 왜 2개의 addressList 가 있어야 하는가이다. TODO
  List<AddressModel> get addressList => _addressList;
  List<AddressModel> get allAddressList => _allAddressList;

  // Setters
  set pickPlacemark(Placemark value) {
    _pickPlacemark = value;
  }
  set placemark(Placemark value) {
    _placemark = value;
  }
  set mapController(GoogleMapController mapController) {
    _mapController = mapController;
  }

  // 외부에서 포지션 바꾸는걸 멈추는 순간 포지션 업데이트가 일어난다.
  void updatePosition(CameraPosition cameraPosition, bool fromAddress) async {
    // 주소가 업데이트가 되었으면 이제 그 주소를 이용해서 Position 을 업데이트 할 수 있는거지
    // 여기 cameraPosition 객체가 외부에서 들어오네.. 이것도 업데이트를 시켜줄까? 이론적으로 업데이트 할 수 있지.
    if (_updateAddressData) {
      _loading = true;
      update();
      try {
        if (fromAddress) {
          // 이 포지션은 드레그했을 때의 포지션 업데이트를 애기하는 것이고
          _position = Position(
            latitude: cameraPosition.target.latitude, longitude: cameraPosition.target.longitude,
            timestamp: DateTime.now(), heading: 1, accuracy: 1, altitude: 1, speed: 1, speedAccuracy: 1
          );
        } else {
          // 여기 포지션은 클릭을 해서 선택(pick) 한 포지션 업데이터를 애기하는 것이다.
          _pickPosition = Position(
              latitude: cameraPosition.target.latitude, longitude: cameraPosition.target.longitude,
              timestamp: DateTime.now(), heading: 1, accuracy: 1, altitude: 1, speed: 1, speedAccuracy: 1
          );
        }
        if (_changeAddress) {
          // 여기가 서버와 통신하고 싶은 부분이다.
          // 일단 나의 서버로 보내고 > 다음 구글 서버로 보내고 > 다시 구글서버가 나에게 스트링을 보낸다.
          // 이제는 Future 를 이해할 수 있지? 여기서 값의 결과가 나올 때까지 기다리고 있다. 그러고 싶지 않으면 then 을 사용하든가...
          // 왜냐면 이걸 포함하는 함수가 Future 를 리턴하지 않으니깐.. 여기가 종결지점이라는 거지..
          String _address = await getAddressfromGeocode(LatLng(cameraPosition.target.latitude, cameraPosition.target.longitude));
          // 이제 어느페이지에서 왔는지 확인하고 각각의 placeMark 에 이름을 넣어주었다.
          fromAddress?_placemark=Placemark(name: _address): _pickPlacemark=Placemark(name: _address);
          print('${_placemark.name}');
        }
      }catch (e) {
        print(e);
      }
    }
  }

  // 결국 이 함수가 repo > apiClient > googleServer > 값을 받아오는 거네..
  Future<String> getAddressfromGeocode(LatLng latLng) async {
    String _address = "unknown location Found";
    Response response = await _locationRepo.getAddressfromGeocode(latLng);
    if (response.body["status"] == 'OK') {
      // response.body 가 Json 이라는건 알고 있었지?
      // [0] 냐면 여러개의 주소가 있을 수 있기 때문에 맨 처음걸로 하자는 거지..
      _address = response.body["result"][0]['formatted_address'].toString();
      print("your loacation is : ${_address}");
    } else {
      print("Error getting the google api");
    }
    update(); // ui 갱신해주어야 한다.
    return _address;
  }

  // 로컬에서 데이터를 받아와서 AddressModel 을 리턴해준다.
  AddressModel getUserAddress() {
    late AddressModel addressModel;
    // converting to map using jsonDecode
    _getAddress = jsonDecode(_locationRepo.getUserAddress());
    try {
      // 그래서 map 객체를 addressModel 객체로 변환해주었다.
      addressModel = AddressModel.fromJsonByFactoryConstructor(_getAddress);

    } catch (e){
      print(e);
    }
    return addressModel;
  }

  //
  void setAddressTypeIndex(int index) {
    _addressTypeIndex = index;
    update(); // 화면을 고치고

  }

  // 함수는 두가지를 생가하자. 1. 어떤 값을 집어넣어줄건지 정하는것과, 2. 어떤 결과값을 기대하고 있는지를...
  // 외부에서 객체 값이 들어오는것.. 맞네..
  Future<ResponseModel> addAddress(AddressModel addressModel) async {
    _loading = true; // 새로운 값이 들어간다.
    update(); // UI 를 고치고
    Response response = await _locationRepo.addAddress(addressModel);
    // 값을 전달해줄 때에도 ResponseModel 로 전달해주면 좋지..
    ResponseModel responseModel;
    // 여기에서 값이 이상 없는지 확인해 주어야 하네.. repository 는 그냥 중계기 역할만 하는거고..
    if (response.statusCode == 200) { // passed, 서버에 저장이 완료되었는데..
      await getAddressList(); // 잘기억하자. 이런함수는 값이 나오지는 않지만 내 필드에 저장된다.
      String message = response.body["message"]; // 기억하자. body 는 json 타입이다.
      responseModel = ResponseModel(true, message);
      // 여기서 뭘 또 save 를 한다는거지? 혹시 로컬에다가?
      await saveUserAddress(addressModel);
  } else {
      responseModel = ResponseModel(false, response.statusText!);
      print("LSL : in location_controller.dart : >>> could\'t save the address");
    }
    update(); // 바뀐 값으로 다시 업데이트
    return responseModel;
  }

  // 이 함수는 void 를 리턴하며 이 함수에서 모든걸 처리한다.
  Future<void> getAddressList() async {
    // 서버에서 모든 주소를 받아온다는 거네..
    Response response = await _locationRepo.getAllAddress();
    if (response.statusCode == 200) {
      // 일단 나의 필드를 초기화 해주고
      _addressList = [];
      _allAddressList = [];
      // 기억하자. Json 형태의 Map 이라면 forEach 를 사용할 수 있다.
      response.body.forEach((address) {
        _addressList.add(AddressModel.fromJsonByNamedConstructor(address));
        _allAddressList.add(AddressModel.fromJsonByNamedConstructor(address));
      });
    } else {
      // 일단 나의 필드를 초기화 해주고
      _addressList = [];
      _allAddressList = [];
      // 아무것도 없잖아...
    }
    update(); // ui 업데이를 한다.
  }

  // 로컬에 저장하기 위한 함수, 여기의 리턴값을 사용하지 않을거라서 Future<void> 를 사용해도 되지만 그냥 repository 에서 리턴되어 오는기본값을 가지고 있는거다.
  Future<bool> saveUserAddress(AddressModel addressModel) async {
    // 스트링으로 저장할거잖아. 잘봐라..
    // 항상 스트링으로 sharedPreference 에 저장할 때는 jsonEncode 를 사용하도록 하자.
    String userAddress = jsonEncode(addressModel.toJson());
    return await _locationRepo.saveUserAddress(userAddress);
  }

  // 주소를 다지우는것
  void clearAddressList() {
    _addressList = [];
    _allAddressList = [];
    update();
  }

  getUserAddressFromLocalStorage() {
    return _locationRepo.getUserAddress();
  }
}

