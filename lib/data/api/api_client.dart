import 'package:food_delivery/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 이 클래스에서 Map 에 값을 넣는 방법 두가지를 잘보도록 하자.
class ApiClient extends GetConnect implements GetxService {
  late String
      token; // HTTP 서버와 통신하기 위해서 반드시 token 이 있어야 한다. 원래는 late 에서 받는건데 그냥 임시로 'token' 이라고 넣는다.
  late Map<String, String>
      _mainHeaders; // HTTP 서버에 필요한 Header 를 저장해서 보내기 위해서 필요하다.
  final String _appBaseUrl;
  late SharedPreferences sharedPreferences;

  ApiClient({required var appBaseUrl, required this.sharedPreferences}) : _appBaseUrl = appBaseUrl {
    baseUrl = _appBaseUrl; // GetConnect 객체에 있는 baseUrl 에 값을 넣어준다.
    timeout =
        const Duration(seconds: 30); // GetConnect 객체에 있고, 통신을 최대한 유지하는 시간을 30초로 설정한다.
    // 내가 생각한대로 ! 를 넣지 않고 "" 를 넣었다. 그래야지.. 비어있는지 어떻게 알고 무조건 ! 를 하니?
    token  = sharedPreferences.getString(AppConstants.TOKEN) ?? "";
    _mainHeaders = {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  // 뭐 getData 로 모든 데이터 다 불러오네.. 가능하게도 URI 만 있으면 서버에서 URI 를 보고 데이터를 취합해서 Response 해주는거네.. 너무 멋진데...
  // 그래서 headers 를 보내면 token 도 같이 보내게 되니깐 자동으로 거기 토큰에 맞는 데이터를 찾아서 보내주게 된다.
  Future<Response> getData(
    String uri, {Map<String, String>? headers}
  ) async {
    try {
      Response response = await get(
          uri, headers: headers ?? _mainHeaders); // GetConnect 에서 사용되어지는 함수, uri 가 데이터 리스트를 받아오는 서버의 주소겠지
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
  // SignUp Page 의 SignUpBody 를 post 하기 위한 함수
  // 그냥 Getx postData 를 사용하기만 하면 모든 데이터를 자동으로 넘겨줄 수 있는거네..
  Future<Response> postData(String uri, dynamic body) async { // 외부에서 post 를 하기위한 uri 를 주입해 주어야 한다. 그리고 body 도 넣어주어야 하고..
    // 넘겨줄 데이터 body 를 쩍는거네..
    print(body.toString());
    try {
      // 기억나지? Getx package 를 사용한다. 그리고 headers 를 사용하는 이유는 JSon 과 Token 을 같이 보내기 위함이다.
      Response response = await post(uri, body, headers: _mainHeaders);
      print(response.toString()); // body.toString() 을 하면 더 좋을 걸 같은데...
      return response;
    } catch (e) {
      print(e.toString());
      // 잘봐라! 여기서도 return 을 넎어 주어야지.. 안그러면 null 을 리턴해야 하는거잖아.. 어떤 결과를 가지고 이후 작업을 하는데 그냥 null 이 나오는건 아니잖아?
      // 그러니깐 결국은 두군데 모두 return 을 넣어주어야 하는거다.
      return Response(statusCode: 1, statusText: e.toString()); // 에러가 생기면 나는 statusCode 로 1을 리턴할거고, 실제 에러문자는 e.toString()
    }
  }

  // Token 이 업데이트 되고 난 후에 다시 Header 를 업데이트 해야지 서버에 올바를 header 를 올릴 수 있다.
  void updateHeader(String token) {
    _mainHeaders["Content-type"] = "application/json; charset=UTF-8";
    _mainHeaders["Authorization"] = "Bearer $token";
  }
}
