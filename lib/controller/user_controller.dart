import 'package:food_delivery/data/repository/user_repo.dart';
import 'package:food_delivery/model/response_model.dart';
import 'package:food_delivery/model/user_model.dart';
import 'package:get/get.dart';

class UserController extends GetxController implements GetxService {
  final UserRepo userRepo;

  UserController(this.userRepo);

  // Model 을 받는 부분, JSon 으로 변환하는 부분, 또 다른 유틸리티 함수
  // 항상 기억하지만 bool 을 이용해서 이상없는지를 확인하도록 한다.
  bool _isLoading = false; // 초기값으로는 항상 false 를 만들어주고.. 맞지?
  bool get isLoading => _isLoading; // 여기서 보듯이 이 컨트롤러가 UI 에 연결되어 있고 UI 에서 필요로 하는걸 줘야 하는 거지.. 그래서 이런 get 함수가 있는거다.
  late UserModel _userModel;
  UserModel get userModel => _userModel;

  // registration 을 하는 이유가 뭘까? 이제 통과된 값을 Repository 로 넘겨주는 역할을 하는 거겠지?
  // UserModel 을 가지고 온다. 리턴을 할 필요가 없네..
  getUserInfo() async {
    // 이렇게 필요한 데이터와 함수를 실행해주는게 AuthController 의 역할이다.
    Response response = await userRepo.getUserInfo(); // 잘봐라. 여기서 사용할 거니깐 리턴으로 또 넘겨줄 필요가 없이 이제 기다렸다 사용하면 됨.
    late ResponseModel responseModel; // 모델을 통해서 데이터를 넘겨주는게 효율적이다. 헷갈리지마라. 이건 받은 결과값을 위한 model 이다.
    if (response.statusCode == 200) { // 성공했다는 뜻
      _isLoading = true;
      // 데이터가 정상적으로 왔으면 그 온 데이터를 이용해서 객체를 만들어 주어야 한다.
      // 실수했다. factory 생성자 실컷 만들어 놓고 안쓰고 일반 생성자 쓴다.. 이러지 말자... 팩토리 생성자 열심히 사용하자.
      // response.body 자체가 Json 이다. 꼭 기억하자. <<<<<<<<<<<<<<<<<<<<<<<<<<<<
      _userModel = UserModel.fromJson(response.body);
      // 새로운 Model 을 만들어서 데이터를 리턴해준다. 만약에 Model 을 만들지 않으면 여러조각의 데이터들을 따로 넘겨주어야 하기에 번거롭게 된다.
      responseModel = ResponseModel(true, "successfully"); // 아! 여기에다가 토큰을 넣는다....
    } else { // 실패했다는 뜻
      responseModel = ResponseModel(false, response.statusText!); // 아! 여기에다가 토큰을 넣는다....
    }
    // 여기까지 다 통과하면 false 로 해주고 다시 update() 를 해준다는 거지..
    // 이거 뭐 그냥 여기서 두번 update 를 해준거네.. 이렇게 두번씩 update() 를 해주는 테크닉도 사용해야지..
    update(); // 여기에서 UI 를 업데이트를 해주는구나.
  }




}