import 'package:food_delivery/data/repository/popular_product_repo.dart';
import 'package:food_delivery/model/products_model.dart';
import 'package:get/get.dart';

class PopularProductController extends GetxController {
  final PopularProductRepo popularProductRepo;

  List<ProductModel> get popularProductList => _popularProductList;

  PopularProductController({required this.popularProductRepo});

  List<ProductModel> _popularProductList = []; // 리스트 초기화를 시켰다.

  // 이미지 loading 대기 서클 넣기 위해서
  bool _isLoaded = false; // private 으로 만들고
  bool get isLoaded => _isLoaded;

  Future<void> getPopularProductList() async {
    Response response = await popularProductRepo.getPopularProductList();
    if (response.statusCode == 200) {
      // 성공했다면 successful
      print('데이터 가져오기 성공했슴. [in popular Controller]');
      _popularProductList =
          []; // 실행할 때마다 초기화를 시켜주어야 한다. 그래야 데이터가 반복해서 들어가는걸 방지할 수 있다. 상태가 유지되고 있으므로
      // 잘기억해라.. 이제 여기서 데이터를 실제로 사용할 거기 때문에 모델로 바꾸어주어야 한다는거지..
      // 인터넷에서 받은 json 데이터를 Map 과의 연관성은 어떻게 되냐는거지?????

      //
      _popularProductList.addAll(Product.fromJson(response.body)
          .products); // json 을 Model 로 변환해서 넣어주었슴.
      print("$_popularProductList in popular Controller");
      _isLoaded = true;
      update(); // setState 를 실행시킨다.
    } else {
      print('popularProductController  데이터 가져오기 실패했슴 ${response.statusCode}');
    }
  }
}
