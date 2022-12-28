import 'package:food_delivery/data/repository/auth_repo.dart';
import 'package:food_delivery/model/response_model.dart';
import 'package:food_delivery/model/signup_body_model.dart';
import 'package:get/get.dart';

// 기억나지? GetxController & GetxService 두개를 상속받아서 처리하고 있다는걸..
class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;

  AuthController(this.authRepo);

  // Model 을 받는 부분, JSon 으로 변환하는 부분, 또 다른 유틸리티 함수
  // 항상 기억하지만 bool 을 이용해서 이상없는지를 확인하도록 한다.
  bool _isLoading = false; // 초기값으로는 항상 false 를 만들어주고.. 맞지?
  bool get isLoading => _isLoading; // 여기서 보듯이 이 컨트롤러가 UI 에 연결되어 있고 UI 에서 필요로 하는걸 줘야 하는 거지.. 그래서 이런 get 함수가 있는거다.

  // registration 을 하는 이유가 뭘까? 이제 통과된 값을 Repository 로 넘겨주는 역할을 하는 거겠지?
  Future<ResponseModel> registration(SignUpBody signUpBody) async {
    _isLoading = true; // 결국은 CircularProgressIndicator 때문에 있는거네.. 처음에 true 로 하고 update() 해주고
    update(); // 여기서 한번 새로고침 해주고
    late ResponseModel responseModel; // 모델을 통해서 데이터를 넘겨주는게 효율적이다. 헷갈리지마라. 이건 받은 결과값을 위한 model 이다.
    // 이렇게 필요한 데이터와 함수를 실행해주는게 AuthController 의 역할이다.
    Response response = await authRepo.registration(signUpBody); // 잘봐라. 여기서 사용할 거니깐 리턴으로 또 넘겨줄 필요가 없이 이제 기다렸다 사용하면 됨.
    if (response.statusCode == 200) { // 성공했다는 뜻
      // 당연히 response.body 안에 token 값이 저장되어 있겠지.. 서버에서 넘어오는 body 가 어떤건지 잘보자.. 이것이 response 객체를 통해서 넘오는 거니깐..
      authRepo.saveUserToken(response.body["token"]);
      // 새로운 Model 을 만들어서 데이터를 리턴해준다. 만약에 Model 을 만들지 않으면 여러조각의 데이터들을 따로 넘겨주어야 하기에 번거롭게 된다.
      responseModel = ResponseModel(true, response.body["token"]); // 아! 여기에다가 토큰을 넣는다....
    } else { // 실패했다는 뜻
      responseModel = ResponseModel(false, response.statusText!); // 아! 여기에다가 토큰을 넣는다....
    }
    // 여기까지 다 통과하면 false 로 해주고 다시 update() 를 해준다는 거지..
    // 이거 뭐 그냥 여기서 두번 update 를 해준거네.. 이렇게 두번씩 update() 를 해주는 테크닉도 사용해야지..
    _isLoading = false;
    update(); // 여기에서 UI 를 업데이트를 해주는구나.
    return responseModel; // 여기봐라. 객체이니깐 헌꺼번에 넘어가잖아!.
  }



  // registration 을 하는 이유가 뭘까? 이제 통과된 값을 Repository 로 넘겨주는 역할을 하는 거겠지?
  Future<ResponseModel> login(String phone, String password) async {
    // 이전에 signUp 을 했으면 Token 이 저장되어 있으니깐 그값을 불러들여서 siggIn 을 하도록 한다.
    // 근데 토큰으로 접근한다는게 조금 이해가 안된다. 토큰이 있어서 뭐가 다르지? 어딘가에 로그인정보가 저장되어 있어서 그걸 사용한다는 개념인가????
    print("LSL: in auth_controller, >>> Getting Token ${authRepo.getUserToken().toString()} <<<");
    authRepo.getUserToken(); // 토큰이 있는지 먼저 확인하고, 여기선 아무런 의미가 없네..
    // 결국은 CircularProgressIndicator 때문에 있는거네.. 처음에 true 로 하고 update() 해주고
    _isLoading = true;
    update(); // 여기서 한번 새로고침 해주고
    // 모델을 통해서 데이터를 넘겨주는게 효율적이다. 헷갈리지마라. 이건 받은 결과값을 위한 model 이다.
    late ResponseModel responseModel;
    // 이렇게 필요한 데이터와 함수를 실행해주는게 AuthController 의 역할이다.
    Response response = await authRepo.login(phone, password); // 잘봐라. 여기서 사용할 거니깐 리턴으로 또 넘겨줄 필요가 없이 이제 기다렸다 사용하면 됨.
    if (response.statusCode == 200) { // 성공했다는 뜻
      // 당연히 response.body 안에 token 값이 저장되어 있겠지.. 서버에서 넘어오는 body 가 어떤건지 잘보자.. 이것이 response 객체를 통해서 넘오는 거니깐..
      authRepo.saveUserToken(response.body["token"]); // 토큰 저장하고
      // 새로운 Model 을 만들어서 데이터를 리턴해준다. 만약에 Model 을 만들지 않으면 여러조각의 데이터들을 따로 넘겨주어야 하기에 번거롭게 된다.
      responseModel = ResponseModel(true, response.body["token"]); // 아! 여기에다가 토큰을 넣는다....
      print("LSL: in auth_controller, >>> Backend Token : ${response.body["token"].toString()} <<<");
    } else { // 실패했다는 뜻
      responseModel = ResponseModel(false, response.statusText!); // 아! 여기에다가 토큰을 넣는다....
    }
    // 여기까지 다 통과하면 false 로 해주고 다시 update() 를 해준다는 거지..
    // 이거 뭐 그냥 여기서 두번 update 를 해준거네.. 이렇게 두번씩 update() 를 해주는 테크닉도 사용해야지..
    _isLoading = false;
    update(); // 여기에서 UI 를 업데이트를 해주는구나.
    return responseModel;
  }

  // signIn 성공한 후에 전화번호와 패스워드를 저장해주는 함수 위의 로그인 함수에서 사용할 예정임
  void saveUserNumberAndPassword(String number, String password) {
    authRepo.saveUserNumberAndPassword(number, password);
  }

  /// 쇼핑하고 결재할 때 이미 login 이 되었는지 확인하는 함수, Token 을 사용하는 거지..
  bool userLoggedIn() {
    return authRepo.userLoggedIn();
  }
  // Profile Page 에서 Logout 할 때
  bool clearSharedData() {
    return authRepo.clearSharedData();
  }

  void updateToken() async {
    await authRepo.updateToken();
  }


}
