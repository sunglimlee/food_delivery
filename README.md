# App Architecture 앱 설계에 관해서

> 전체적인 설계에 관련된 내용

- UI main()
- init() : Dependencies 말그대로
- Controllers: 모든 상태관리를 위해서 존재한다.
- Repository : 데이터를 호출하기만 한다. 왜냐면 여러군데에서 데이터가 오니깐. 표준화, 데이터만 관리하기 위해 컨트롤러에서도 떨어진거지.
- API Client (HTTP Client), FireBase, LocalDatabase
- Data Model : 데이터 모델을 관리한다. 왜냐면 여러군데서 데이터가 날라오니깐 표준화를 시킨거다. (거의 대부분 json 형태, db 에서 바로 올수 도 있슴)
  : 여기서 알아야할게 Nested Json 을 강조하는 이유는 실제 사용하고자 하는 데이터가 Nested 형태로 되어 있기때문에 그 부분을 다루기 위해서 설명했던거다.
- Constant 넣는부분 (token 도 나중에 확인해라.)

# Fonder 만드는 규칙

- controller/popular_product_controller.dart
- data/api/api_client.dart
- data/repository/popular_product_repo.dart
- helper/dependencies.dart (init() 함수부분)
- model/products_model.dart ( Products 와 Product 두개로 나뉘게 된다.)

# Map 과 List 에 관련된 내용
> 항상 컨트롤러에서 Repository 로 함수를 실행하도록 해라.. 두개를 만든것 같지만 항상 그렇게 디자인을 해야한다.
> update() 하는것도 잊지말고
```dart
  var getCartHistoryList = Get.find<CartController>().getCartHistoryList().reversed.toList(); // 최신 날짜순으로 보여주려고 reverse 했다.
  Map<String, int> cartItemsPerOrder = {};
  for (int i = 0; i < getCartHistoryList.length; i++) { // 같은 갯수가 몇개인지 알기 위함.
    if (cartItemsPerOrder.containsKey(getCartHistoryList[i].time)) {
      // key time 의 시간자체를 key 로 만든다는 것.
      cartItemsPerOrder.update(getCartHistoryList[i].time!,(value) => ++value); // 두번째게 돌때 같은 키값이 있는지 확인하고 있으면 해당하는 키값을 1 증가 시키라는 의미
    } else {
      cartItemsPerOrder.putIfAbsent(getCartHistoryList[i].time!, () => 1); // time 안에 들어있는 값을 키로하고 그 키값이 없으면 키 값을 1로 정한다.
    }
  }
  
  // 시간만 쏙 가져온 리스트.. 이걸로 반복할 때 조건을 만들 수 있다.
  List<String> timeValue = cartItemsPerOrder.entries.map((e) => e.key).toList();

  // 전체 수량만 쏙 가져온 리스트... 이걸로 반복할 때 조건을 만들 수 있다.
  List<int> cartItemsPerOrderToList() {
    return cartItemsPerOrder.entries.map((e) => e.value).toList();
  }

  List<String> cartOrderTimeToList() { // 위에거랑 똑같은데???
    return cartItemsPerOrder.entries.map((e) => e.key).toList(); // 이렇게 하면 타임만 나오는 리스트가 만들어진다.
  }

  var listCounter = 0 // 이게 아주 중요한데. 반복문에서 전체를 돌려주기 위해서 사용한다.

  void convert_getCartHistoryList_to_items() { // List<CartModel> -> Map<int, CartModel> 바꾸어야 함
    Map map = {for (var item in getCartHistoryList) '${item.id}' : getCartHistoryList};
    print("변경된 map의 값은 : ${map}");
  }
  //convert_getCartHistoryList_to_items();


  List<String> ordertime = cartOrderTimeToList(); // 지금 리스트뷰 돌아가는 곳의 해당 타임을 가지고 온거다. 이거부터 해야 되는거 맞는데.. 대단하다.
  //print("in cart_history. ordertime  ${ordertime[i]}");
  // 이제 위의 이 리스트가 회전할 때 정해진 타임 ordertime[i] 를 가지고 getCartHistoryList 에서 새로운 맵을 추출한다.
  // 클릭하는 부분이니깐 새롭게 만들어도 괜찮지..
  Map<int, CartModel> moreOrder = {};
  // 기억해라 GestureDector 안에 있는거로 반복문과는 조금밖에 관련없다.
  for (int j=0; j<getCartHistoryList.length; j++) {
    if (getCartHistoryList[j].time == ordertime[i].toString()) { // 위의 반복문의 i
    moreOrder.putIfAbsent(getCartHistoryList[j].id!, () => getCartHistoryList[j]!); // 새로운 Map 을 만들어 값을 넣는걸 putIfAbsent 를 사용한다.
    // CartModel.fromJson(jsonDecode(jsonEncode(getCartHistoryList[j]!))); // 아직도 왜 이렇게 해야하는지 모르겠다.
    print("in cart_history. Product info is ${jsonEncode(getCartHistoryList[j])}");
    }
  }
  Get.find<CartController>().items = moreOrder; // setter 이므로 이렇게 해야한다.
  Get.find<CartController>().addToCartList(); // 카트에다가 추가시켜준다.
  Get.toNamed(RouteHelper.getCartPage());
```

```dart
List<ProductModel> popularProductList;
var popularListIndex = Get.find<PopularProductController>()
    .popularProductList.indexOf(cartController.getItems[index].product!); // 해당 product 의 첫번째 발견되는 인덱스를 리턴한다.
```
```dart
    for (String st in cartHistory) {
      cartListHistory.add(CartModel.fromJson(jsonDecode(st)));
    }
```
```dart
List<String> carts = [];
List<CartModel> cartList = [];
if (shardPreferences.containsKey(AppConstants.CART_LIST)) {
  carts = shardPreferences.getStringList(AppConstants.CART_LIST)!;
}
List<CartModel> cartList = [];
carts.forEach((element) {
  cartList.add(CartModel.fromJson(jsonDecode(element))); // 딱 한가지를 놓쳤다. 무조건 스트링으로 되어 있는걸 jsonDecode 를 통해서 Map 으로 바꾸었고 그걸 다시 fromJson 으로 객체로 바꾸었다.
}
```
```dart
Map<int, CartModel> _items = {};
 _items.remove(key); // 키값을 지운다.
```
```dart
_items.containsKey(product.id!)); // 맵에서 키값이 있는지 확인한다.
```
```dart
_items.update(product.id!, (value) {return CartModel(id:value.id, name:value.name, qty: value.qty+qty};); // 키값에 해당하는 맵의 값을 업데이트한다.
```
```dart
_items.putIfAbsent(product.id!, (){})); // 키값유무로 맵함수에 키값에 따라 값을 추가할 때 주로 사용한다.
```
```dart
    for (int i = 0; i < storageItems.length; i++) {
      _items.putIfAbsent(storageItems[i].product!.id!, () => storageItems[i]);
    }
```
```dart
  List<String> ordertime = cartOrderTimeToList(); // 지금 리스트뷰 돌아가는 곳의 해당 타임을 가지고 온거다. 이거부터 해야 되는거 맞는데.. 대단하다.
  //print("in cart_history. ordertime  ${ordertime[i]}");
  // 이제 위의 이 리스트가 회전할 때 정해진 타임 ordertime[i] 를 가지고 getCartHistoryList 에서 새로운 맵을 추출한다.
  // 클릭하는 부분이니깐 새롭게 만들어도 괜찮지..
  Map<int, CartModel> moreOrder = {};
  // 기억해라 GestureDector 안에 있는거로 반복문과는 조금밖에 관련없다.
  for (int j=0; j<getCartHistoryList.length; j++) {
    if (getCartHistoryList[j].time == ordertime[i].toString()) { //// 위의 반복문의 i
      moreOrder.putIfAbsent(getCartHistoryList[j].id!, () => getCartHistoryList[j]!); // 새로운 Map 을 만들어 값을 넣는걸 putIfAbsent 를 사용한다.
    // CartModel.fromJson(jsonDecode(jsonEncode(getCartHistoryList[j]!))); // 아직도 왜 이렇게 해야하는지 모르겠다.
    print("in cart_history. Product info is ${jsonEncode(getCartHistoryList[j])}");
    }
  }
  Get.find<CartController>().items = moreOrder; // setter 이므로 이렇게 해야한다.
  Get.find<CartController>().addToCartList(); // 카트에다가 추가시켜준다.
  Get.toNamed(RouteHelper.getCartPage());
```
```dart
_items.forEach((key,value) {
  if (key==product.id! {
    qty = value.qty } 
);}); // 전체 맵의 값을 가지고 한번 돌면서 임시값 qty 에 . for 문과 유사. if 와 사용
```
```dart
_items.forEach((key, value) {totalQty += value.quantity!;}); // 전체맵을 돌면서 qty 값을 임시변수 totalQty 에 더한다.
```
```dart
List<CartModel>인 cartModelItems.forEach((element) { temporaryTotal += element.quantity!.toDouble() * element.price!.toDouble();});
```
```dart
List<CartModel> getItems = _items.entries.map((e) {return e.value}).toList(); // 맵의 각 e 값으로 lazy 하게 돌려서 List 를 만든다.
```
```dart
      _popularProductList.addAll(Product.fromJson(response.body).products); // json 을 Model 로 변환해서 넣어주었슴. 잘봐라 프로덕트만 가져온다.

```
```dart
    // 시간 형식을 바꾸기 위해서 사용
    String changeTimeFormat(String time) {
      print("/////////////// ${time}");
      var str = time; //"the quick brown fox jumps over the lazy dog";
      const start = "20";
      const end = ".";

      final startIndex = time.indexOf(start);
      final endIndex = time.indexOf(end, startIndex + start.length);
      //print("endindex 의 값은 ${endIndex.toString()}");
      return time.toString().substring(0, endIndex - 3);
    }
```

```dart
  // immediately invoke function, 위젯안에서 실행할 수 있네.. Grammar 너무 중요한거다.
  // https://medium.com/dartlang/3-cool-dart-patterns-6d8d9d3d8fb8(() {
  var original = DateFormat("yyyy-MM-dd HH:mm:ss").parse(timeValue[i]); // 텍스트를 정해진 형식대로 DateTime 으로변경
  var inputDate = DateTime.parse(original.toString());
  var outputFormat = DateFormat("MM/dd/yyyy hh:mm a"); // 아웃풋 포맷은 이것으로 하기로 하고
  var outputDate = outputFormat.format(inputDate); // 그 아웃풋 형식에 맞게 다른 DateTime 형식을 넣어준다. 그러면 문자열 리턴
  return BigText(text: outputDate); // 그러면 그거 사용
  /*return BigText( // 이건 내가 작업한 거고..
    text: changeTimeFormat();
  */
}()),
```
```dart
// erging widgets into a collection: for ()...[]
children: [
  // Merging Widget into a collection. 모든 갈증이 해결되는 느낌이네... 이렇게 반복문으로 더 많은 내용을 넣을 수 있다.
  for (int i = 0; i < itemsPerOrder.length; i++)...[ // 3. 2. 3 여기서는 3번만 반복된다는걸 반드시 기억하자.
    Container(), // 잘봐라. 여기에는 return 하지 는다. 그냥 계속 추가해 나간다는 의미이므로
  ],
```
```dart
children: // 이자체가 리스트이므로 [] 할필요가 없지
  List.generate(itemsPerOrder[i], (index) {

```


> PageView 가 화면이 에니메이션처럼 작아졌다 커졌다 하는 기능
```dart
import 'package:flutter/material.dart';
import 'package:food_delivery/controller/popular_product_controller.dart';
import 'package:food_delivery/model/products_model.dart';
import 'package:food_delivery/pages/food/popular_food_detail.dart';
import 'package:food_delivery/pages/home/main_food_page.dart';
import 'package:food_delivery/routes/route_helper.dart';
import 'package:food_delivery/utils/app_constants.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widget/App_Column.dart';
import 'package:food_delivery/widget/big_text.dart';
import 'package:food_delivery/widget/icon_and_text.dart';
import 'package:food_delivery/widget/small_text.dart';
import 'package:get/get.dart';
import 'package:transparent_image/transparent_image.dart';

/*
/// 페이지뷰를 이렇게 독립적으로 만들어서 나중에 끼워 넣는 방식으로 사용한다.
/// 아주 좋은 방법인것 같다.
 */
typedef double2VoidFunc = void Function(); // 이렇게 콜백함수의 형정의를 해주고..

class FoodPageBody extends StatefulWidget {
  final double2VoidFunc callbackForCurrPageValue;
  final PagesValuesToShare pagesValuesToShare; // 이것도 외부에서 이미 만들어진 객체의 포인터를 가지고 온것.. 여기서 바꾸면 외부도 바뀐다.

  const FoodPageBody(
      {Key? key,
      required this.pagesValuesToShare,
      required this.callbackForCurrPageValue})
      : super(key: key);

  @override
  State<FoodPageBody> createState() => _FoodPageBodyState();
}

class _FoodPageBodyState extends State<FoodPageBody> {
  PageController pageController = PageController(viewportFraction: 0.85);
  final double _scaleFactor = 0.8;
  final double _height = Dimensions.pageViewContainer;

  @override
  void initState() {
    super.initState();
    // 내가 PageController 가 움직일때 값을 받아오기 위해서 Listener 를 연결해주어야 한다.
    pageController.addListener(() { // 움직일때마다 setState 가 작동되게 했네.. // 나중에 반드시 dispose() 를 해주어라.
      setState(() {
        widget.pagesValuesToShare.currPageValue =
            pageController.page!; // 숫자가 0.0 - 1.0 까지 값이 변경되고 있네. page 값으로.. !!!
        widget.callbackForCurrPageValue(); // 그래서 아주 조금씩 움직이는데도 인디케이터도 조금씩 따라서 움직이는거다.
        print(
            'Current value is ${widget.pagesValuesToShare.currPageValue.toString()}');
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PopularProductController>(
      builder: (popularProductController) {
        // update() 로 변경이 일어날때 마다 GetBuilder 가 실행되고 동시에 변경이 일어난 컨트롤러를 사용할 수 있게 된다.
        // dot indicator 에 값을 넣어주는 부분, class 객체로 데이터를 공유하고 있다.
        widget.pagesValuesToShare.pagesTotalValue =
            popularProductController.popularProductList.length;
        return Container(
          height: Dimensions.pageView,
          child: PageView.builder(
              controller: pageController,
              itemCount: popularProductController.popularProductList.length,
              itemBuilder: (context, position) {
                return _PageViewBuilderItem(
                    position, popularProductController.popularProductList[position]);
              }),
        );
      },
    );
  }

  Widget _PageViewBuilderItem(int position, ProductModel popularProduct) {
    Matrix4 matrix4 = Matrix4.identity();
    if (position == widget.pagesValuesToShare.currPageValue.floor()) {
      var currScale = 1 -
          (widget.pagesValuesToShare.currPageValue - position) *
              (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix4 = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (position ==
        widget.pagesValuesToShare.currPageValue.floor() + 1) {
      var currScale = _scaleFactor +
          (widget.pagesValuesToShare.currPageValue - position + 1) *
              (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix4 = Matrix4.diagonal3Values(1, currScale, 1);
      matrix4 = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (position ==
        widget.pagesValuesToShare.currPageValue.floor() - 1) {
      var currScale = 1 -
          (widget.pagesValuesToShare.currPageValue - position) *
              (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix4 = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else {
      // 3번째 것
      var currScale = 0.8;
      matrix4 = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, _height * (1 - _scaleFactor) / 2, 1);
    }
    return Transform( // 이렇게 감싸주면 바뀌는구나.
      transform: matrix4,
      child: GestureDetector(
        onTap: () {
          print('popular food 로 전달된 pageId 값은 $position 입니다.');
          Get.toNamed(
            RouteHelper.getPopularFood(position, RouteHelper.initial),
          ); // 디테일 페이지로 이동
        },
        child: Stack(
          children: [
            _mainBody(position, popularProduct),
            _subBody(popularProduct),
          ],
        ),
      ),
    );
  }

  Widget _subBody(ProductModel popularProduct) {
    // 옆에 패딩을 넣어주기 위해서 Container 를 또 넣어주기로 했지..
    return Align(
      alignment: Alignment.bottomCenter, // 이부분때문에 밑으로 내려가는거다.
      child: Container(
        height: Dimensions.pageViewTextContainer,
        margin: EdgeInsets.only(
            left: Dimensions.edgeInsets30,
            right: Dimensions.edgeInsets30,
            bottom: Dimensions.edgeInsets30),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radius30),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Color(0xFFe8e8e8),
                blurRadius: 5.0,
                offset: Offset(0, 5),
              ),
              BoxShadow(
                color: Colors.white,
                offset: Offset(-5, 0),
              ),
              BoxShadow(
                color: Colors.white,
                offset: Offset(5, 0),
              ),
            ]),
        child: AppColumn(title: popularProduct.name!),
      ),
    );
  }

  Widget _mainBody(int position, ProductModel popularProduct) {
    return Container(
      height: _height,
      margin: EdgeInsets.only(
          left: Dimensions.edgeInsets10, right: Dimensions.edgeInsets10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius30),
        //color: position.isEven ? Colors.green : Colors.pink,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: FadeInImage.memoryNetwork( // 이것도 해보려고 했는데 잘 안되더라..
            placeholder: kTransparentImage,
            //const AssetImage('assets/images/loading.png'),
            image:
                '${AppConstants.BASE_URL}${AppConstants.UPLOAD_URL}${popularProduct.img}',
          ).image,
        ),
      ),
    );
  }
}

/*
Widget _mainBody(int position, ProductModel popularProduct) {
  return Container(
      height: _height,
      margin: EdgeInsets.only(
          left: Dimensions.edgeInsets10, right: Dimensions.edgeInsets10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius30),
        //color: position.isEven ? Colors.green : Colors.pink,
        image: DecorationImage(
            image:NetworkImage(
                AppConstants.BASE_URL + '/uploads/' + popularProduct.img.toString()),
            fit: BoxFit.cover),
      ));
}
*/

```

//////////////////////////////////////////////////////////////////////////////////

# GetX 란?

> GetX 는 미니 프레임 워크이다. 생산성, 성능, 조직화(MVC, MVVM 즉 Clean Code)

- [Get X Official Link](https://chornthorn.github.io/getx-docs/route-management/index)
- 라우트 관리
- 상태관리, State Management
- 종속성 관리, Dependency Injection (Get.to 할 때)
- 종속성 관리, Binding (라우트 설정부분에서도 할 수 있다. 똑같다. 단지 Route 에 해준다는것)
- GetX Service
- Nested Navigation
- 기타 유용한 기능

## 설정방법

###### pubspec.yaml 에서

dependencies :
get: ^3.24.0

###### main.dart 에서

```dart
void main() => runApp(GetMaterialApp(home: Home())); // 상태관리만 사용한다면 GetMaterialApp 을 사용하지 않아도 된다.
```

# 라우트 관리

- 기본 페이지 라우팅(기존 Navigator 와 GetX route 차이)
- Named 페이지 라우팅 (기존 Navigator 와 GetX route 차이)
- 페이지 전화 효과 적용 (Transition)
- arguments 전달 (데이터를 전달할 때)
- parameters 동적 링크 적용 (페이지에 해당하는 값을 전달할 때)

## 기본 페이지 라우팅

###### 기존 Navigator

```dart
  Navigator.of(context).
push
(
MaterialPageRoute
(
builder: (
_) =>
FirstPage
(
)));
Navigator.of(context).

pop(); // 뒤로가기

Navigator.of(context).
pushAndRemoveUntil
(
MaterialPageRoute
(
builder: (
_) =>
Home
(
)),
(
route)=>
false;
```

###### GetX route

```dart
  Get.to(FirstPage
(
));
Get.back(); // 뒤로가기
Get.offAll(Home
(
)); // 이게 문제가 뭐냐면 Home() 이 새롭게 생성된다는 점이다. NamedTo 를 사용하면 그럴일이 없지.
```

###### Named 페이지 라우팅

- 기존 방식 GetMaterialApp at main.dart

```dart
  // initialRoute: "/" 밑에서 route 에서 "/" 를 정의하면 이부분은 필요없슴
route: {
"/" : (context)=> Home(),
"/FirstNamedPage" : (context) => FirstNamedPage(),
"/SecondNamedPage" : (context)
=>
SecondNamedPage
(
)
,
```

- 파일에서 사용할 때

```dart
  Navigator.of(context).
pushNamed
("/FirstNamedPage
"
);
```

- GetX in GetMaterialApp at main.dart

```dart
  getPages: [
GetPage
(
name: "
/
"
,
page: (
)
=>
Home
(
)),
GetPage
(
name: "
/
FirstNamePage",
page: (
)
=>
FirstNamedPage
(
)),
GetPage
(
name: "
/
SecondNamePage",
page: (
)
=>
SecondNamedPage
(
)),
]
,
```

- 파일에서 사용할 때

```dart
  Get.toNamed("
/
FirstNamedPage");
Get.offNamed("
/
SecondNamedPage"); // 현재 페이지를 없애고 두번째 페이지로 가자.
Get.offAllNamed("
/
"
);
```

## 페이지 전화 효과 적용 (Transition)

- GetMaterialApp 에서

```dart
  GetPage
(
name: "
/
"
,
page: (
)
=>
Home
(
), transition: Transition.zoom), // 여러가지가 있다.
```

## argument 전달

- 보내는곳에서

```dart
  Get.toNamed("
/
next",
arguments: "
개
남
"
);
Get.toNamed("
/
next",
arguments: 3
);
Get.toNamed("
/
NextNamedPage",
arguments: ["개남", "스티브"], )
,
Get.toNamed("
/
NextNamedPage",
arguments: [ {"name": "개남", "age": 52} ]
,
)
, // 맵을 보낼 때
onPressed: (
)
=>
Get.toNamed("
/
NextNamedPage",
arguments: [
User
(
name: "
스
티
브
"
,
age: 52
)
]
,
)
, // User class 보낼 때
```

- 받는곳에서

```dart
  ${Get.arguments}Text
("전달받은 데이터는 : 
${Get.arguments[0
]
.
toString
(
)}"
)
,
Text
("전달받은 데이터는 : 
${Get.arguments[0]["age"]}"), // 맵을 보냈을 때 받는법
Text
("전달받은 데이터는 : 
${
(
Get.arguments

as User
)
    .
age}"
)
, // User class 받을 때, 새로 시작해라. 안그러면 오류나더라.
Text
("전달받은 데이터는 : 
${
(
Get.arguments[0
]

as User
)
    .
name}"
)
, // User class 리스트로 받을 때, 새로 시작해라. 안그러면 오류나더라.
```

## url parameter 전달

- 먼저 이렇게 세팅하고

```dart
  GetPage
(
name: "
/
UserNamedPage/:
uid",
page: (
)
=>
UserNamedPage
(
)), // 파라미터 넘길때, 웹페이지처럼 UserId 를 넘길 때
```

- 보내는곳에서

```dart
  onPressed: (
)
=>
Get.toNamed("
/
UserNamedPage/28357
"
)
,
```

- 받는곳에서

```dart
  Text
("${
Get.parameters['
uid']
}
"
)
,
```

- 보내는곳에서

```dart
  onPressed: (
)
=>
Get.toNamed("
/
UserNamedPage/28357
?
name=개
남
&
age=22
"
)
,
```

- 받는곳에서

```dart
  Text
("${
Get.parameters['
uid']
}
"
)
,
Text
("${
Get.parameters['
name'
]
}
님 안녕하세요.
"
)
,
Text
("${
Get.parameters['
age'
]
}
살 이시군요.
"
)
,
```

# 상태관리 (기본적으로 Model, View, Controller 방식으로 따라가도록 하자.)

- 단순 상태관리
- 단순 상태관리 ID 넣어주는 방식 (각각의 버턴들과 값변경부분들을 id 로 정해줄 수 있다는것)
- 반응형 상태관리
- 이벤트 트리거
- Rx type

## 단순 상태관리 (값이 변화할 때마다 계속 화면 업데이트가 일어난다. 별로 않좋다.)

###### 기존 provider 방식

- 전역으로 설정할건지 지역적으로 설정할 건지 정해놓고

```dart
return ChangeNotifierProvider<CountControllerWithProvider>(
create: (context) => CountControllerWithProvider(),
child: GetMaterialApp(),);
```

- 컨트롤러부분

```dart
class CountControllerWithProvider extends ChangeNotifier {
  // controller 를 ChangeNotifier 에서 확장하도록 한다.
  int _count = 0; // 초기화를 안해주었구나. 항상 초기화를 해주도록 하자. 되도록이면 초기화 해주면 null 에 대한 문제가 없잖아.
  int get count => _count;

  increment() {
    _count++;
    notifyListeners(); // 값이 변경되었을 때 notifyListeners() 꼭 해주도록
  }
}
```

- view 부분에서 변경되는부분

```dart
Consumer<CountControllerWithProvider>
( // Consumer 가 Widget 을 리턴하기 때문에 child 를 사용할 필요가 지금은 없다.
builder: (
context, value, child) {
return Text(value.count.toString(), style: TextStyle(fontSize: 20, color: Colors.red));
})
,
```

- view 부분에서 변경시키는부분

```dart
countControllerWithProvider = Provider.of<CountControllerWithProvider>(context, listen: false
); // 기억하자 listen : false 중요하다.
onPressed: () {countControllerWithProvider.increment();},
```

###### GetX 방식

- 전역으로 설정할건지 지역적으로 설정할 건지 정해놓고

```dart
    Get.put(CountControllerWithGetX
(
)); // 이게 다야???? 둘러싸주고 뭐 그런것도 없다.
```

- 컨트롤러 부분에서

```dart
class CountControllerWithGetX extends GetxController {
  int _count = 0;

  void increment() {
    _count++;
    update();
  }
```

- view 부분에서 변경되는부분

```dart
GetBuilder<CountControllerWithGetX>
(
builder: (
controller) { // 이게 마치 Consumer 를 사용한 것 같은 느낌.
return Text(controller.count.toString(), style: TextStyle(fontSize: 20, color:
Colors
.
red
)
,
);
```

- view 부분에서 변경시키는부분

```dart
onPressed: () { // 여기도 여전히 listen : false 기능이 들어가야 되는거 아냐???????
Get.find<CountControllerWithGetX>().increment(); },
```

## 단순상태관리 with ID

- 컨트롤러 부분에서

```dart
class CountControllerWithGetX extends GetxController {
  int _count = 0; // 이게 값을 공유하는 것 까지 되네.. 만약 새로운 변수를 만들면 내가 따로 쓸 수 있겠네..
  void increment({whichOne = null}) {
    _count++;
    if (whichOne == null) {
      update();
    } else {
      update([whichOne]);
    }
  }

  int get count => _count;
}
```

- view 부분에서 변경되는부분

```dart
GetBuilder<CountControllerWithGetX>
(
id: "
second",
builder: (
controller) { // 이게 마치 Consumer 를 사용한 것 같은 느낌.
return Text(controller.count.toString(), style: TextStyle(fontSize: 20, color:
Colors
.
red
)
,
);
```

- view 부분에서 변경시키는부분

```dart
onPressed: () { // 여기도 여전히 listen : false 기능이 들어가야 되는거 아냐???????
Get.find<CountControllerWithGetX>().increment(whichOne: "second"); }, //기억나지? 만약에 위에서 바로 Get.put 을 사용하고 변수에 등록하면 find 사용할 필요없다는것.
```

## 반응형 상태관리 (값이 변화할 때만 화면 업데이트가 일어난다.)

###### obx, GetX 둘다 사용방법

- 전역으로 설정할건지 지역적으로 설정할 건지 정해놓고

```dart
    Get.put(CountControllerWithReactiveGetX
(
));
```

- 컨트롤러 부분에서

```dart
class CountControllerWithReactiveGetX extends GetxController {
  // 이 클래스 스스로가 반응형 상태관리가 되는거다. GetxController 안넣어도된다.
  RxInt _count = 0.obs; // obs 옵져버블로 등록하고 대신 RxInt 로 등록해준다. 끝.
  void increment() {
    _count++; // update() 도 필요없다.
  }

  RxInt get count => _count;
}
```

- view 부분에서 변경되는 부분 (obx 를 사용할 때)

```dart
Obx
(()
=>
Text
("${
Get.find<CountControllerWithReactiveGetX>()
.
count.value.toString()
}
"
,
style: TextStyle
(
fontSize: 30
)
,
)
)
, 
```

- view 부분에서 변경되는 부분 (GetX 를 사용할 때)

```dart
GetX
(
builder: (
_) { return Text( // 이건 마치 Consumer 처럼 반응하는거네.. GetBuilder 사용이랑 비슷하긴한데.. obx 라고 한다는 거지.
"${Get.find<CountControllerWithReactiveGetX>().count.value}",
style: TextStyle(fontSize: 50.0)); },
)
,
```

- view 부분에서 변경시키는 부분

```dart
ElevatedButton
(
onPressed: () {
Get.find<CountControllerWithReactiveGetX>().increment(); // 메모리에서 모든 컨트롤러를 다지워버린다.
},
child: Text
(""
)
)
,       
```

- [그렇다면 언제 GetBuilder, GetX, Obx 를 사용할까?](https://softwarezay.com/notes/462_flutter-getx-getbuilder-getx-obx-which-one-to-choose)

###### 값이 변화할 때만 화면이 업데이트가 된다. 5를 넣어서 테스트해보자.

- 컨트롤러 부분에서 (값이 변화할 때만 화면 업데이트가 일어난다.)

```dart
class CountControllerWithReactiveGetX extends GetxController {
  // 이 클래스 스스로가 반응형 상태관리가 되는거다. GetxController 안넣어도된다.
  RxInt _count = 0.obs; // obs 옵져버블로 등록하고 대신 RxInt 로 등록해준다. 끝.
  void putNumber(int value) {
    _count(value); // 이렇게 괄호안에 넣어야 하는구나. 5로 바꾸라고 했는데... // 숫자 5로 바뀔때 한번만 호출하고 그다음부터는 호출하지 않는다.
  }
}
```

- view 부분에서 변경시키는 부분

```dart
ElevatedButton
( // id 를 부여해서 버턴을 다로 연결하는게 가능해진다.
child: const Text("
5
로
변
경
"
,
style: TextStyle
(
fontSize: 30
,
color: Colors.red),
)
,
onPressed: () { // 여기도 여전히 listen : false 기능이 들어가야 되는거 아냐???????
Get.find<CountControllerWithReactiveGetX>().putNumber(5); //기억나지? 만약에 위에서 바로 Get.put 을 사용하고 변수에 등록하면 find 사용할 필요없다는것.
},
)
,
```

- Rx 데이터 업데이트할 때 하는 방법

```dart

final isOpen = false.obs;

// NOTHING will happen... same value.
void onButtonTap() => isOpen.value = false; // 이게 생각보다 아주 중용하다. value 사용한 것 봐라.
```

## 이벤트 트리거

###### 반응형일 때 이벤트에 따라 여러가지 기능을 구현할 수 있다. GetxController 를 상속받아야 한다.

```dart
class CountControllerWithReactiveGetX
    extends GetxController // 상속을 받게되면 GetxController 에는 라이프 사이클이 있다.

RxInt _count = 0.obs;

void increment() {}

onInit() {
  // 기억하자 obx 일때만 가능하다. 그리고 값이 변했을 때만 반응한다.
  ever(_count, (_) => print("매번호출")); // 잘봐라. _count 가 매번 바뀔때마다 이 함수가 실행된다.
  once(_count, (_) => print("한번만호출")); // 최초 한번만 변경되었을 때만 호출되고 그다음부터는 호출 안된다.
  // 검색할 때 키를 입력받고 있을 때 가만히 있다가 잠깐 텀을 주었을 때 데이터를 받아와서 리스트를 보여주고자 할 때 디바운스를 사용한다.
  debounce(_count, (_) => print("마지막 변경에 한번만 호출"),
      time: Duration(seconds: 1)); // 변경없다가 멈추고 1초이후에 마지막에 한번 호출
  interval(_count, (_) => print("변경될 동안 1초마다 호출"))
  , time: Duration(second: 1));
  super
  .
  onInit
  (
  );
}

onClose() {}

onDelete() {}
```

###### Rx Type

> null 로 객체를 초기화를 시킬때 사용하는 너무나도 중요한 부분이다.
> 되도록이면 _ 프라이빗으로 사용하지 마라. value 값을 사용하는데 문제가 된다.

```dart

Rx<AssetEntity?> selectedImage = (null as AssetEntity?).obs; // 이부분을 찾기 위해서 일주일을 허비했다.
var imageList = <AssetEntity>[].obs;
List<AssetPathEntity> _albums = <AssetPathEntity>[].obs;
var headerTitle = ''.obs;
```

```dart
enum NUM { FIRST, SECOND }

class User {
  String name;
  int age;

  User({this.name, this.age});
}

class CountControllerWithReactiveGetx extends GetxController

RxInt _count = 0.obs;
RxDouble double = 0.0.obs;
RxString string = "".obs; // 모든 타입이 다 있다.
Rx<NUM> nums = NUM.FIRST.obs; // enum type
Rx<User> user = User(name: "개남", age: 25).obs; // 데이터 클래스 타입
RxList<String> list = [""].obs; // 또는 <String>[].obs;
final items = <String>[].obs;
final myMap = <String, int>{}.obs;

void increment() {
  count++;
  _double++;
  _double(424);
  nums(NUM.SECOND); // enum type 변경할 때
  user(user());
  user.update((_user) {
    _user.name = "스티브";
  }); // 이렇게 update 를 사용할 수 있고, 함수로 데이터를 업데이트한다.
  list.addAll();
  list.add();
  list.addIf(user.vale.name == "스티브", "okay"); // 리스트는 자봐라.
}

// 이렇게 Rx<> Generics 으로 사용할 수도 있다.
final name = Rx<String>('');
final isLogged = Rx<Bool>(false);
final count = Rx<Int>(0);
final balance = Rx<Double>(0.0);
final number = Rx<Num>(0);
final items = Rx<List<String>>([]);
final myMap = Rx<Map<String, int>>({});
// Custom classes - it can be any class, literally
final user = Rx<User>();
final name = ''.obs;
final isLogged = false.obs;
final count = 0.obs;
final balance = 0.0.obs;
final number = 0.obs;
final items = <String>[].obs;
final myMap = <String, int>{}.obs;

// Custom classes - it can be any class, literally
final user = User().obs;
// 항상 기억하자. 되도록이면 초기화를 꼭 해주도록 하자.
// As we know, Dart is now heading towards null safety. To be prepared, from now on, you should always start your Rx variables with an initial value.
// You will literally add a " .obs " to the end of your variable, and that’s it, you’ve made it observable, and its .value , well, will be the initial value).
```

```dart
name.value = '
Hey';

// All Rx properties are "callable" and returns the new value.
// but this approach does not accepts `null`, the UI will not rebuild.
name
('Hello
'
);

final flag = false.obs;

// switches the value between true/false
flag.toggle();

// Sets the `value` to null.
flag.nil();

```

```dart
// 두번째 예제들
// controller file
final count1 = 0.obs;
final count2 = 0.obs;

int get sum => count1.value + count2.value; // 항상 value 를 사용한다.

GetX<Controller>
(
builder: (
controller) {
print("count 2 rebuild");
return Text('${controller.count2.value}'); },
)
,
GetX<Controller>
(
builder: (
controller) {
print("count 3 rebuild");
return Text('${controller.sum}');},
)
,

```

```dart
class RxUser {
  final name = "Camila".obs;
  final age = 18.obs;
}

class User {
  User({String name, int age});

  var name;
  var age;
}

// when instantianting:
final user = User(name: "Camila", age: 18).obs;
```

```dart
// On the controller
final String title = 'User Info:'.obs

final list = List<User>().obs;

// on the view
Text
(
controller.title.value), // String need to have .value in front of it
ListView.builder ( // 리스트는 .value 사용할 필요가 없다.
itemCount: controller.list.length // lists don't need it
)
```

```dart
class User() {
User({this.name = '', this.age = 0});
String name;
int age;
}

// on the controller file
final user = User().obs;
// when you need to update the user variable:
user.update( (
user) { // this parameter is the class itself that you want to update
user.name = 'Jonny';
user.age = 18;
});
// an alternative way of update the user variable:
user
(
User
(
name: '
João',
age: 35
)
);

// on view:
Obx
(()
=>
Text
("Name 
${user.value.name}:
Age:${user.value.age}"
)
)
// you can also access the model values without the .value:
user
(
).name; // notice that is the user variable, not the class (variable has lowercase u)
```

# 종속성 관리 (Defendency Injection)

> 알다시피 메모리 절감을 위해서 사용하는 차원이고 계속 끌고가고 싶으면 GetxService 를 사용하도록 하자.
> 총 5가지의 방법이 있다.

1. 원래 방법대로 Get.put 을 이용해서 어디든지 넣어주는 방법 ( 이 말뜻 그대로 Get.put 을 쓰면 전체 App 에서 사용할 수 있다.)
2. Get.to 페이지 전환하면서 binding 속성안에 Get.put 으로 넣어주는 방법
3. Get.to 페이지 전환하면서 binding 속성안에 Get.lazyPut 으로 넣어주는 방법
4. Get.to 페이지 전환하면서 binding 속성안에 Get.putAsync 으로 넣어주는 방법
5. Get.to 페이지 전환하면서 binding 속성안에 Get.create 으로 넣어주는방법 (인스턴스가 계속 생성된다. 위에거는 전부 싱글톤이지만 이건 아님.)

## 2. Get.to 페이지 전환하면서 binding 속성안에 Get.put 으로 넣어주는 방법

```dart
onPressed: () { // page mount 단계에서 할 수 있다. GetX 가 자동으로 생성과 파괴를 해준다.
Get.to(GetPut(), binding: BindingsBuilder((){Get.put(DependencyController());}));
}
```

## 3. Get.to 페이지 전환하면서 binding 속성안에 Get.lazyPut 으로 넣어주는 방법

```dart
onPressed: () { // page mount 단계에서 할 수 있다. GetX 가 자동으로 생성과 파괴를 해준다.
// GetLazyPut() 에서 Controller 에 접근하려고 할 때 메모리에 올리게 된다.
Get.to(GetLazyPut(), binding: BindingsBuilder((){ Get.lazyPut<DependencyController>(()=>DependencyController() ) }));
}
```

## 4. Get.to 페이지 전환하면서 binding 속성안에 Get.putAsync 으로 넣어주는 방법

```dart
onPressed: () { // page mount 단계에서 할 수 있다. GetX 가 자동으로 생성과 파괴를 해준다.
// 비동기 방식, 뭔가 비동기 처리이후에 controller 에 접근하도록 할 때 사용한다
Get.to(GetPut(), binding: BindingsBuilder((){ Get.putAsync<DependencyController>(() async {
await Future.delayed(Duration(seconds: 5));
return DependencyController();} ) })); // 5초 이후에 컨트롤러가 생성된다.
}
```

## 5. Get.to 페이지 전환하면서 binding 속성안에 Get.create 으로 넣어주는방법 (인스턴스가 계속 생성된다. 위에거는 전부 싱글톤이지만 이건 아님.)

```dart
// 비동기 방식, 뭔가 비동기 처리이후에 controller 에 접근하도록 할 때 사용한다
Get.to(GetPut
(
), binding: BindingsBuilder
((){ Get.create<DependencyController>(() {
// 이것도 GetPut() 페이지에서 Controller 에 접근할 때 비로서 생성된다. 단 계속 새롭게 생성한다는 것
return DependencyController();} ) })
); // 5초 이후에 컨트롤러가 생성된다.
}
```

```dart
onPressed: () {
print(Get.find<DependencyController>().hashCode); //*****
Get.find<DependencyController>().increment();
}
```

# 종속성 관리 - Binding (라우트 설정부분에서도 할 수 있다.)

1. GetmaterialApp 내에서 getPages 안에 binding 하는 방법
2. Bindings 클래스를 상속받아서 getPages 안에 binding 하는 방법
3. Bindings 클래스를 상속받아서 GetxMaterialApp() 안에 'initBinding : InitBinding()',

## 1. GetmaterialApp 내에서 getPages 안에 binding 하는 방법

```dart
getPages: [
GetPage
(
name: "
/
binding",
page: (
)
=>
BindingPage
(
),
// 완전히 똑같다. 생성될때 Controller 가 같이 생성되고 
// 페이지에서 빠져 나올 때 Controller 가 자동 삭제된다.
binding : bindingBuilder
(() { Get.put(CountControllerWithGetX()) })
)
,
//binding: BindingBuilder( () { Get.lazyPut<CountControllerWithGetX>(()=> CountControllerWithGetX()); })),
]
,
```

## 2. Binding 클래스를 상속받아서 getPages 안에 binding 하는 방법

```dart
class BindingpageBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(CountControllerWithGetX());
  }
}
```

```dart
getPages: [
GetPage
(
name: "
/
binding",
page: (
)
=>
BindingPage
(
),
// 완전히 똑같다. 생성될때 Controller 가 같이 생성되고 
// 페이지에서 빠져 나올 때 Controller 가 자동 삭제된다.
binding : BindingPageBindings
(
)),
//binding: BindingBuilder( () { Get.lazyPut<CountControllerWithGetX>(()=> CountControllerWithGetX()); })),
]
,
```

## 3. Binding 클래스를 상속받아서 GetMaterialApp() 안에 'initialBinding : CountControllerWithGetX()',

> 한꺼번에 Get.put 을 하는데 유용하다. ⭐⭐⭐⭐⭐

- [Binding 에 대한 링크 예제](https://chornthorn.github.io/getx-docs/dependency-management/binding/)

```dart
class UsingBindingsClass extends Bindings {
  @override
  void dependencies() {
    Get.put(BottomNavController(), permanant: true,
        tag: "some unique string"); // permanant 로 인해서 계속 살아있게 된다. // 태그로 같은 클래스의 여러개의 인스턴스 구별때 사용한다.
    // 그말은 여기에 계속 추가해서 넣어줄 수 있다는 건가??? 한번보자.
  }
}
```

```dart
// 이거 왜 쓰는데? 전체에게 적용되는 Binding 을 적욛할 때 사용해준다.
initialBinding: UsingBindingsClass
(
), // GetMaterialApp() 안에서 
// initialBinding: BindingsBuilder(() {Get.put(BottomNavController() }), // BottomNavController() 가 Bindings 상속받지 않았을 때
```

# GetxService

> 컨트롤러를 사용해서 최상단에 Get.put 을 사용해서 controller 의 지속성을 유지시켜 줄 수 있는데 GetxService 를 사용하면 clear() 하기전까지 안죽고 계속 유지되게 할 수 있다.

```dart
void initService() {
  Get.put(GetxControllerTest(), permanent: true); // permananent 를 꼭 해주어야 한다.
}
```

> 그런데 controller 가 GetxService 를 상속받게 되면 그때부터는 지속성을 유지시켜 줄 수 있게 된다.

```dart
// 단지 GetxService 를 상속받았을 뿐인데 메모리에 계속 살아있게 된다.
// Get.reset() 를 하면 메모리에 살아있는 모든 controller 를 지우게 된다.
class GetxServiceTest extends GetxService {
  void increment() {
    _count++;
  }
}
```

# Nested Navigation

```dart
  // 라우트가 안에 있고, 안에서 페이지 생성하는 방법
Widget settingNavigator1() {
  return Navigator(
      key: Get.nestedKey(1), // create a key by index
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return GetPageRoute(
            page: () =>
                Scaffold(
                  appBar: AppBar(
                    title: Text("Main"),
                  ),
                  body: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed(
                            '/SettingDetailPage', id: 1); // navigate by your nested route by index
                      },
                      child: Text("Go to Setting Detail Page"),
                    ),
                  ),
                ),
          );
        } else if (settings.name == '/SettingDetailPage') {
          return GetPageRoute(
            page: () =>
                Center(
                  child: Scaffold(
                    appBar: AppBar(
                      title: Text("Main"),
                    ),
                    body: Center(
                        child: Text("Setting Detail Page")
                    ),
                  ),
                ),
          );
        }
      }
  );
}
// 라우트가 안에 있고, 밖의 페이지를 생성하는 방법
Widget settingNavigator2() {
  return Navigator(
      key: Get.nestedKey(1), // create a key by index, 이 자체가 Global Key 이구나.
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return GetPageRoute(
            page: () => Setting(),
          );
        } else if (settings.name == '/SettingDetailPage') {
          return GetPageRoute(
            page: () =>
                Center(
                  child: SettingDetail(),
                ),
          );
        }
      }
  );
}
// Navigator 로 감싼 방식
Widget settingNavigator3() {
  return Navigator(
    key: Get.nestedKey(1),
    onGenerateRoute: (settings) {
      return GetPageRoute(
        page: () => Setting(),
      );
    },
  );
}
// 라우터를 밖에 만들고
// Map 을 사용한 방식
Widget settingNavigator4() {
  return const SettingNavigator();
}

```

# 기타 유용한 기능

1. `Get.find<CountControllerwithGetX>().increment();` static 사용하기
2. Stateless 위젯대신 GetView<CountControllerWithGetX> 로 확장하기
3. context 필요한? `Get.context!` ㅋㅋㅋ
4. navigator instead of using Navigator
5. Get.snackbar
6. Get.dialog
7. Get.bottomSheet
8. is Email validate? GetUtils.isEmail('steve.patriot@gmail.com') ? validate() : errorMessage();
9. MediaQuery and Screen
10. Get.defaultDialog

## 1. controller 클래스에서 static 사용하기

> 이렇게 find 로 접근해서 값을 증가시켰는데 controller 객체에서 static 을 사용하면 훨씬 쉽게 사용할 수 있다.

```dart
class CountControllerWithGetX extends GetxController {
  static CountControllerWithGetX get to => Get.find<CountControllerWithGetX>();
  RxInt _count = 0.obs;
}
```

```dart
onPressed: () {
CountControllerWithGetX.to.increment();
// Get.find<CountControllerWithGetX>().increment();
}
```

## 2. Stateless 위젯대신 GetView<CountControllerWithGetX> 로 확장하기

```dart
class BindingPage extends GetView<CountControllerWithGetX> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        GetBuildr<CountControllerWithGetX>(builder: (_) {})
    );

// 이제부터는 controller 를 사욯해서 쓸 수 있다.
    onPressed:
        () {
      controller.increment(); // 이렇게 바로 접근가능하다. }
    }
  }
```

## 3. context 필요하니? `Get.context!` ㅋㅋㅋ

> context 값 `Get.context!;`
> with 값 `Get.width * 0.7;`

## 4. navigator instead of using Navigator

```dart
        GestureDetector
(
onTap: () {
RootController.to.setCategoryPage(true);
// GetX 를 사용하면 Navigator 도 이렇게 navigator 로 사용하며, context 가 필요없다.
navigator?.push( // 봐라.. 이미 nested Navigator 안에 들어와 있다.
MaterialPageRoute(
builder: (context) => const ExploreDetailPage()));
},
child: Container
(
margin: const EdgeInsets.all(8
)
,
```

## 5. Get.snackbar

```dart
Get.snackbar("

Hey i
'

m a

Get SnackBar
!
"
, // title
"
It's unbelievable! I
'

m using

SnackBar without
context,

without boilerplate, without
Scaffold, it is

something truly
amazing!"
, // message
icon: Icon
(
Icons.alarm),
shouldIconPulse: true
,
onTap:(){},
barBlur: 20
,
isDismissible: true
,
duration: Duration
(
seconds: 3
)
,
);
```

```dart
// check if snackbar is open
Get.isSnackbarOpen

// check if dialog is open
Get.isDialogOpen

// check if bottomsheet is open
Get.isBottomSheetOpen

```

## 6. Get.dialog

```dart
Get.dialog(YourDialogWidget
(
));
```

```dart
Get.defaultDialog(onConfirm: (
)
=>
print
("Ok
"
)
,
middleText: "

Dialog made
in
3

lines of
code");
```

## 7. Get.bottomSheet

```dart
Get.bottomSheet(Container
(
child: Wrap
(
children: <
Widget>[
ListTile
(
leading: Icon
(
Icons.music_note),
title: Text
('Music
'
)
,
onTap: () {})
,
ListTile
(
leading: Icon
(
Icons.videocam),
title: Text
('Video
'
)
,
onTap: () {},),
],),
)
);
```

## 8. is Email validate?

```dart
GetUtils.isEmail('
steve.patriot
@gmail.com')
?
validate
(
) :

errorMessage();
```

## 9. MediaQuery and Screen

```dart
//Check in what platform the app is running
GetPlatform.isAndroid
GetPlatform.isIOS
GetPlatform.isMacOS
GetPlatform.isWindows
GetPlatform.isLinux
GetPlatform.isFuchsia

//Check the device type
GetPlatform.isMobile
GetPlatform.isDesktop
//All platforms are supported independently in web!
//You can tell if you are running inside a browser
//on Windows, iOS, OSX, Android, etc.
GetPlatform.isWeb


// Equivalent to : MediaQuery.of(context).size.height,
// but immutable.
Get.height
Get.width

// Gives the current context of the Navigator.
Get.context

// Gives the context of the snackbar/dialog/bottomsheet in the foreground, anywhere in your code.
Get.contextOverlay

// Note: the following methods are extensions on context. Since you
// have access to context in any place of your UI, you can use it anywhere in the UI code

// If you need a changeable height/width (like Desktop or browser windows that can be scaled) you will need to use context.
context.width
context.height

// Gives you the power to define half the screen, a third of it and so on.
// Useful for responsive applications.
// param dividedBy (double) optional - default: 1
// param reducedBy (double) optional - default: 0
context.heightTransformer()
context.widthTransformer()

/// Similar to MediaQuery.of(context).size
context.mediaQuerySize()

/// Similar to MediaQuery.of(context).padding
context.mediaQueryPadding()

/// Similar to MediaQuery.of(context).viewPadding
context.mediaQueryViewPadding()

/// Similar to MediaQuery.of(context).viewInsets;
context.mediaQueryViewInsets()

/// Similar to MediaQuery.of(context).orientation;
context.orientation()

/// Check if device is on landscape mode
context.isLandscape()

/// Check if device is on portrait mode
context.isPortrait()

/// Similar to MediaQuery.of(context).devicePixelRatio;
context.devicePixelRatio()

/// Similar to MediaQuery.of(context).textScaleFactor;
context.textScaleFactor()

/// Get the shortestSide from screen
context.mediaQueryShortestSide()

/// True if width be larger than 800
context.showNavbar()

/// True if the shortestSide is smaller than 600p
context.isPhone()

/// True if the shortestSide is largest than 600p
context.isSmallTablet()

/// True if the shortestSide is largest than 720p
context.isLargeTablet()

/// True if the current device is Tablet
context.isTablet()

/// Returns a value<T> according to the screen size
/// can give value for:
/// watch: if the shortestSide is smaller than 300
/// mobile: if the shortestSide is smaller than 600
/// tablet: if the shortestSide is smaller than 1200
/// desktop: if width is largest than 1200
context.responsiveValue<T>()
```

## 10. Get.defaultDialog

```dart
  Future<bool> willPopAction() async {
  //https://stackoverflow.com/questions/45109557/flutter-how-to-programmatically-exit-the-app
  if (bottomHistory.length == 1) {
    if (Platform.isAndroid || Platform.isIOS) {
      Get.defaultDialog(title: 'close',
          content: Text('Do you want to close?'),
          textConfirm: "Close",
          textCancel: "Cancel",
          onConfirm: () {
            if (Platform.isAndroid) {
              SystemNavigator.pop();
            } else if (Platform.isIOS) {
              exit(
                  0); // or use pub.dev/packages/minimize_app   MinimizeApp.minimizeApp();
            }
          },
          onCancel: () => Get.back());
      return true;
    } else {
      return false;
    }
  } else {
    print('goto before page!'); // 현재는 아무것도 움직이지 않잖아????
    bottomHistory.removeLast(); // 마지막걸 지우고..
    print(bottomHistory);
    var index = bottomHistory.last;
    changeBottomNav(index, isTapped: false); // 여기 보이나? 탭으로 바꿔주고 있다는 걸... 결국 이게 맞네.. 내가 한게 맞았네..
    return false;
  }
}

```

![This is an image](https://myoctocat.com/assets/images/base-octocat.svg)

- [Markdown CheetSheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)
- [other markdown Tools](https://github.com/adam-p/markdown-here/wiki/Other-Markdown-Tools)

# The largest heading

## The second largest heading

###### The smallest heading

1. First list item
    - First nested list item
        - Second nested list item

> Text that is a quote

**This is bold text**
*This text is italicized*
~~This was mistaken text~~
**This text is _extremely_ important**
***All this text is important***
<sub>This is a subscript text</sub>  
<sup>This is a superscript text</sup>

Use `git status` to list all new or modified files that haven't yet been committed. // Quoting Code

Some basic Git commands are:

``` 
git status
git add
git commit
```

```markdown
Here is a simple footnote[^1].

A footnote can also have multiple lines[^2].

You can also use words, to fit your writing style more closely[^note].

[^1]: My reference.
[^2]: Every new line should be prefixed with 2 spaces.  
This allows you to have a footnote with multiple lines.
[^note]:
Named footnotes will still render with numbers instead of the text but allow easier identification
and linking.  
This footnote also has been made with a different syntax using 4 spaces for new lines.
```

```markdown
Colons can be used to align columns.

| Tables        | Are           | Cool  |
| ------------- |:-------------:| -----:|
| col 3 is      | right-aligned | $1600 |
| col 2 is      | centered      |   $12 |
| zebra stripes | are neat      |    $1 |

There must be at least 3 dashes separating each header cell. The outer pipes (|) are optional, and
you don't need to make the raw Markdown line up prettily. You can also use inline Markdown.

Markdown | Less | Pretty
--- | --- | ---
*Still* | `renders` | **nicely**
1 | 2 | 3
```

```markdown
> Blockquotes are very handy in email to emulate reply text.
> This line is part of the same quote.

Quote break.

> This is a very long line that will still be quoted properly when it wraps. Oh boy let's keep writing to make sure this is long enough to actually wrap for everyone. Oh, you can *put* **Markdown** into a blockquote. 
```

#### inline HTML

```markdown
<dl>
  <dt>Definition list</dt>
  <dd>Is something people use sometimes.</dd>

  <dt>Markdown in HTML</dt>
  <dd>Does *not* work **very** well. Use HTML <em>tags</em>.</dd>
</dl>
```

#### Horizontal Rule

```markdown
Three or more...

---

Hyphens

***

Asterisks

___

Underscores
```

#### YoutTube Videos

```markdown
<a href="http://www.youtube.com/watch?feature=player_embedded&v=YOUTUBE_VIDEO_ID_HERE
" target="_blank"><img src="http://img.youtube.com/vi/YOUTUBE_VIDEO_ID_HERE/0.jpg"
alt="IMAGE ALT TEXT HERE" width="240" height="180" border="10" /></a>
```

#### mailto link

[example@gitlab.com](mailto:example@gitlab.com)

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials, samples, guidance on
mobile development, and a full API reference.
