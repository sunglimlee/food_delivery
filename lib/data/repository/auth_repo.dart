import 'package:food_delivery/data/api/api_client.dart';
import 'package:food_delivery/model/signup_body_model.dart';
import 'package:food_delivery/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 이건 아무것도 상속받지 않네..
class AuthRepo {
  final ApiClient apiClient; // 실제 뎇이터를 연결하기 위한 객체
  // 보이지 Repository 에서 어디로 저장할 지 여러 경로로 나뉘어 진다. 여기서 벌써 두군데가 존재하잖아.
  final SharedPreferences sharedPreferences;

  AuthRepo(this.apiClient, this.sharedPreferences);

  // signUp 을 하기 위해 AuthController 에 대응하는 함수 registration
  Future<Response> registration(SignUpBody signUpBody) async {
  //uri 는 어떤것으로 정해도 되과, body 는 JSon 으로 변경되어서 넘어가야 하는데?
  return await apiClient.postData(AppConstants.REGSTRATION_URI, signUpBody.toJson());
  }
  /* 맨처음에 UserData 를 전송하고 나서 데이터가 정상적으로 올라가고 나면 서버에서 특별한 코드인 Token 을 보내주는데 이 Token 을 로컬에다가 저장해 놓았다가
    다음에 다시 로그인을 할 때는 Token 을 이용하여 로그인을 하도록 해야 한다. 아마도 Token 을 저장하는 곳은 SharedPreference 가 되겠지.
   */
  saveUserToken(String token) async {
    // 이미 ApiClient 에 Token 에 대한 값이 저장되어 있다.
    apiClient.token = token; // 로컬에 저장되어 있는 값을 불러들여서 apiClient 에서 사용하도록 저장해준다.
    // 저장하고 나면 이 데이터를 Header 에 저장해 주어야 한다.
    apiClient.updateHeader(token); // 여기 두번씩이나 token 을 업데이틀 하는 이유가 뭘까??????????? TODO
    // return 을 했는데도 이 함수는 아무것도 리턴하지 않느구나.. 그래도 괜찮은거네.. 하기야 return 문으로 함수를 빠져나가기도 하닌깐..
    // 결국 값을 sharedPreferences 에 저장해라는 뜻이네...
    return await sharedPreferences.setString(AppConstants.TOKEN, token);
  }
}
