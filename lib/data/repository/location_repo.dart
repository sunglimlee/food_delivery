// repository 는 보통 상속없이 사용
import 'package:food_delivery/data/api/api_client.dart';
import 'package:food_delivery/model/address_model.dart';
import 'package:food_delivery/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationRepo {
  final ApiClient _apiClient;
  final SharedPreferences _sharedPreferences;

  // 테스트 해봤는데 일반함수처럼 초기화가 안되네.. 반드시 생성자처럼 초기화를 해야하는구나.
  LocationRepo(
      {required ApiClient apiClient,
      required SharedPreferences sharedPreferences})
      : _apiClient = apiClient,
        _sharedPreferences = sharedPreferences;

  Future<Response> getAddressfromGeocode(LatLng latLng) async {
    return await _apiClient.getData('${AppConstants.GEOCODE_URI}'
      '?lat=${latLng.latitude}&lng=${latLng.longitude}'
    );
  }

  // 로컬스토리지에서 데이터를 가져오는거네..
  String getUserAddress() {
    // 여기 보다시피 Repository 에서 sharedPreference 를 다루고 있잖아..
    // 그렇다면 여기
    return _sharedPreferences.getString(AppConstants.USER_ADDRESS)??""; // 되도록이면 "" 빈문자열을 리턴해주도록 하자..
  }

  // 서버에 user Address 를 저장하는 함수를 구현하는 부분으로 이미 서버 api 의 주소값을 app_constants.dart 에 저장해 놓은 상태이다.
  Future<Response> addAddress(AddressModel addressModel) async { // 파라미터 보이지? 객체로 넘겨주는거..
    // 꼭 기억하자. addressModel 은 객체이며 그 객체를 toJson 으로 바꾸기에 다시 파라미터로 값을 넘겨줄 필요가 없다. 그러면 두번 작업하는 셈이 되는거다.
    return await _apiClient.postData(AppConstants.ADD_USER_ADDRESS, addressModel.toJson());
  }

  // 간단히 서버에서 주소 리스트를 받아와서 컨트롤러로 중계해주는 함수
  Future<Response> getAllAddress() async {
    return await _apiClient.getData(AppConstants.ADDRESS_LIST_URI);
  }

  Future<bool> saveUserAddress(String userAddress) async {
    // 여기서 추가로 헤더를 업데이틀 해준다. 왜냐면 새로운 유저로 로그인을 하면 새로운 토큰이 생성되고 그래서 토근을 업데이트를 해주어야 한다.
    _apiClient.updateHeader(_sharedPreferences.getString(AppConstants.TOKEN)!);
    return await _sharedPreferences.setString(AppConstants.USER_ADDRESS, userAddress);
  }

  // Http 클라이언트이기때문에 이렇게 get 으로 가져오는 형태가 가능한거지..
  Future<Response> getZone(String lat, String lng) async {
    return await _apiClient.getData('${AppConstants.ZONE_URI}?lat=$lat&lng=$lng');
  }

  // 검색 완성을 위한 메서드 부분
  Future<Response> searchLocation(String text) async {
    return await _apiClient.getData('${AppConstants.SEARCH_LOCATION_URI}?search_text=$text');
  }
  // 주소를 선택하고 서버로 보내는 부분
  /// 서버에 placeID 값을 받아서 보내면 유니크 한 값이니깐 여러가지 정보를 다시 받아올 수 있다. 가령 Latitude & Logitude 같은 것들..
  /// predictions list 에서 description 과 placeId 를 받아올 수 있다.
  Future<Response> setLocation(string, placeID) async {
    return await _apiClient.getData('${AppConstants.PLACE_DETAILS_URI}?placeid=$placeID');
  }
}
