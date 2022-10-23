import 'package:get/get.dart';

class ApiClient extends GetConnect implements GetxService {
  late String token =
      ''; // HTTP 서버와 통신하기 위해서 반드시 token 이 있어야 한다. 원래는 late 에서 받는건데 그냥 임시로 'token' 이라고 넣는다.
  late Map<String, String>
      _mainHeaders; // HTTP 서버에 필요한 Header 를 저장해서 보내기 위해서 필요하다.
  final String _appBaseUrl;

  ApiClient({required var appBaseUrl}) : _appBaseUrl = appBaseUrl {
    baseUrl = _appBaseUrl; // GetConnect 객체에 있는 baseUrl 에 값을 넣어준다.
    timeout =
        Duration(seconds: 30); // GetConnect 객체에 있고, 통신을 최대한 유지하는 시간을 30초로 설정한다.
    _mainHeaders = {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Response> getData(
    String uri,
  ) async {
    try {
      Response response = await get(
          uri); // GetConnect 에서 사용되어지는 함수, uri 가 데이터 리스트를 받아오는 서버의 주소겠지
      print("baseUrl 은 $baseUrl 입니다.");
      print("uri 의 값은 $uri 입니다.");
      print(" api_client 에서 돌아오는 값은 ${response.body} 입니다.");
      print(" response.status code is ${response.statusCode} 입니다.");
      return response;
    } catch (e) {
      return Response(
          statusCode: 1, statusText: e.toString()); // 에러가 나면 이렇게 보내준다.
    }
  }
}
