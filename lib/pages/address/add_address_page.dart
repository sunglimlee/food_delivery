import 'package:flutter/material.dart';
import 'package:food_delivery/controller/auth_controller.dart';
import 'package:food_delivery/controller/location_controller.dart';
import 'package:food_delivery/controller/user_controller.dart';
import 'package:food_delivery/model/address_model.dart';
import 'package:food_delivery/routes/route_helper.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widget/app_icon.dart';
import 'package:food_delivery/widget/app_text_field.dart';
import 'package:food_delivery/widget/big_text.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({Key? key}) : super(key: key);

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  // TextEditController
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactPersonNameController = TextEditingController();
  final TextEditingController _contactPersonNumberController = TextEditingController();

  // 이 필드는 여기에 있는게 아니라 controller 에 있어야 한다고 보는데 여기서도 값을 가지고 있기 위함이라고 생각하지뭐...
  late bool _isLogged;

  // bird view, camera position 이런것도 있구나..
  // 일단은 Lat Lng 를 임의의 값으로 만들어 놓았다. 나중에 controller 에서 값을 받아와야 하는거지..
  CameraPosition _cameraPosition =
  const CameraPosition(target: LatLng(45.51563, -122.677433), zoom: 17);

  // 나중에 lat, lng 필요하기 때문에 필드를 미리 만들어 놓는다. 초기 위치값
  late LatLng? _initialPosition;

  @override // 초기화를 해주어야지..
  void initState() {
    super.initState();
    _isLogged = Get.find<AuthController>().userLoggedIn();
    // logged 는 되었는데 userModel 이 없다면 불러와야 겠지..
    if (_isLogged && Get
        .find<UserController>()
        .userModel == null) {
      // 이 문장을 실행시키면 _userModel 에 값이 들어간다. 즉 서버에서 유저 정보값을 불러온다.
      Get.find<UserController>().getUserInfo();
    }
    // address 가 존재한다는 의미는 유저의 address 가 있다는 의미이고 이걸 바탕으로 latLng 가 다시 설정되어야 한다.
    // user 의 실제 location 이 존재한다는 뜻.
    if (Get
        .find<LocationController>()
        .addressList
        .isNotEmpty) {
      // bug fix
      if (Get.find<LocationController>().getUserAddressFromLocalStorage() == "") {
        Get.find<LocationController>().saveUserAddress(Get.find<LocationController>().addressList.last);
      }

      Get.find<LocationController>().getUserAddress(); // 로컬에서 주소를 받아온다.
      Map address = Get
          .find<LocationController>()
          .getAddress;
      double latitude, longitude;
      latitude = double.parse(address["latitude"]);
      longitude = double.parse(address["longitude"]);
      _cameraPosition = CameraPosition(target: LatLng(latitude, longitude));
      _initialPosition = LatLng(latitude, longitude);
    }
  }

  @override // 마무리도 깔끔하게
  void dispose() {
    //
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Address page"),
      ),
      backgroundColor: AppColors.mainColor,
      bottomNavigationBar: GetBuilder<LocationController>(builder: (locationController) {
        // 기존 PopularProductController 의 대부분 함수가 똑같으므로 그냥 사용하기로 한다.
        return Column(
          mainAxisSize: MainAxisSize.min,
          // 이걸 적용함으로써 Column 의 최소한의 높이를 정한다. 만약 없다면 부모가 Scaffold 이므로 전체를 잡아먹도록 된다.
          children: [
            Container(
              height: Dimensions.height20 * 8,
              padding: EdgeInsets.only(
                  left: Dimensions.edgeInsets20,
                  right: Dimensions.edgeInsets20),
              decoration: BoxDecoration(
                color: Colors.grey[200], // Colors.pink,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimensions.radius20),
                    topRight: Radius.circular(Dimensions.radius20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      // 이제 클릭으로 선택한 이 값을 서버로 보내 저장해 주어야 한다.
                      // AddressModel 객체를 만들어야 한다. 그냥 일반 생성자를 이용해서 만들기로 하자.
                      AddressModel addressModel = AddressModel(
                        // 꼭 기억하자. 아직 id 값을 저장하지 않은 상태로 객체를 만들었다. 나중에 처리해야 할 부분이다. TODO
                        contactPersonName: _contactPersonNameController.text.toString(),
                        contactPersonNumber: _contactPersonNumberController.text.toString(),
                        address: _addressController.text.toString(),
                        latitude: locationController.position.latitude.toString()??"", // 여기 locationController 에 position 에 저장되어 있었지..
                        longitude: locationController.position.longitude.toString()??"",
                        addressType: locationController.addressTypeList[locationController.addressTypeIndex]
                      );
                      // 여기서 await 를 사용할건지 then 을 사용할 건지는 명확하지.. ui 에서는 then 을 사용하는게 좋을 것 같다.
                      locationController.addAddress(addressModel).then((responseModel) {
                        if (responseModel.isSuccess) {
                          // 문제없이 서버에 저장이 되었으니 이제 전 화면으로 돌아가면 된다.
                          Get.toNamed(RouteHelper.getInitial());
                          Get.snackbar("Address", "Added data to the server successfully"); // 스낵바 한번 띄워주고..
                        } else {
                          Get.snackbar("address", "Couldn't save the address to the server");
                        }
                      } );
                    },
                    child: Container(
                      padding: EdgeInsets.all(Dimensions.edgeInsets20),
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(Dimensions.radius20),
                          color: Colors.green[200]),
                      child: Row(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BigText(
                            text: 'Save Address',
                            color: Colors.white,
                            size: Dimensions.edgeInsets20 + Dimensions.edgeInsets5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      }),
      // 여기 보이지? 지금 GetBuilder 를 두개를 중첩하고 있다는것..
      body: GetBuilder<UserController>(builder: (userController) {
        // 중첩했으면 사용해야지.. 일단은 로컬에 들어있는 데이터 값을 불러들여서 사용하고 밑에 드래그를 하면 그 드래그 한부분을 서버에서 받아와서 사용한다.
        if (userController.userModel != null &&
            _contactPersonNameController.text.isEmpty) {
          // userModel 에서 contactPerson 값을 불러오겠다는거네..
          _contactPersonNameController.text =
              userController.userModel.fName.toString();
          _contactPersonNumberController.text =
              userController.userModel.phone.toString();
          // 만약에 이미
          if (Get
              .find<LocationController>()
              .addressList
              .isNotEmpty) {
            _addressController.text = Get
                .find<LocationController>()
                .getUserAddress()
                .address ?? "no address found";
          }
        }
        return GetBuilder<LocationController>(builder: (locationController) {
          // 드레그를 했을 때 이제 값을 구글과 통신해서 받아오고 그 주소를 화면에 나타내준다.
          // 한가지 알아야 할 내용은 문자를 연결할 때 + 사인 없이 계속 '' 로 감싸주면서 나타내면 된다.
          _addressController.text = '${locationController.placemark.name ?? ''}'
              ' ${locationController.placemark.locality ?? ''}' // 도시
              ' ${locationController.placemark.postalCode ?? ''}'
              ' ${locationController.placemark.country ?? ''}';
          print(
              'LSL : in add_addresss_page.dart : Address in my view is >>> ${_addressController
                  .text.toString()} <<<');
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 이곳에 Google Map 을 보여주려고 하잖아!.
                // 뭐가 필요하면 어떻게 하는건지 보자. 뭐. 객체 만들어서 그 객체를 넣어 주겠지.
                Container(
                  height: Dimensions.height20 * 7,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(5), // 이게 named constructor 였어..
                    border:
                    Border.all(width: 2, color: AppColors.mainColor),
                  ),
                  child: Stack(
                    children: [
                      // 이제는 이런것 잘 알겠다. initialCameraPosition CameraPostion 받으니깐, 객체를 던지든지, 새 객체를 만들어서 넣든지 하면 되는거지..
                      // 단 한줄로 구글맵이 나오네... 일단 값이 없으니깐 임시로.. 그리고 심지어 스택안에서 드래그 된다.
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                            target: _initialPosition ??
                                const LatLng(45.51563, -122.677433),
                            zoom: 17),
                        zoomControlsEnabled: false,
                        compassEnabled: false,
                        indoorViewEnabled: true,
                        myLocationEnabled: true, // 내 로케이션을 공유할지를 물어본다.
                        mapToolbarEnabled: false,
                        // 드래그를 마치고 나면 카메라포지션에 저장된 값을 가지고 이 콜백함수가 실행된다.... ㅋ
                        onCameraIdle: () {
                          locationController.updatePosition(
                              _cameraPosition, true);
                        },
                        // 카메라가 움직이고 있을 때는 _cameraPosition 에 값을 계속 저장하고 있고...
                        onCameraMove: (cameraPostion) {
                          _cameraPosition = cameraPostion;
                        },
                        // 이부분은 그냥 한번만 작업해주면 되는부분
                        // 이말은 이제 이 맵이 만들어지고 나면 이맵을 외부에서 사요할 수 있도록 컨트롤러를 가지고 있게 된다는거지..
                        // 그러면 이 googleMapController 를 추후에 사용한다는 거지?? TODO
                        onMapCreated: (googleMapController) {
                          locationController.mapController = googleMapController;
                        },
                      ),
                    ],
                  ),
                ),
                // 윗부분 아이콘 부분
                // https://stackoverflow.com/questions/55716322/flutter-sizedbox-vs-container-why-use-one-instead-of-the-other
                Padding(
                  padding: EdgeInsets.only(left: Dimensions.edgeInsets20, top: Dimensions.edgeInsets20),
                  child: SizedBox(height: 50, // 여기보듯이 높이를 강제하기 위해서 Container 대신 SizedBox 를 사용했다.
                    child: ListView.builder(
                        itemCount: locationController.addressTypeList.length,
                        shrinkWrap: true, // 이건 별로 의미가 없는것 같은데..
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, itemIndex) {
                      return InkWell(onTap: () {
                        locationController.setAddressTypeIndex(itemIndex);
                      },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.edgeInsets20, vertical: Dimensions.edgeInsets20),
                          margin: EdgeInsets.only(right: Dimensions.edgeInsets10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radius20/4),
                            color: Theme.of(context).cardColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[200]!,
                                spreadRadius: 1,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Icon(
                              (itemIndex == 0) ? Icons.home_filled: (itemIndex == 1) ? Icons.work : Icons.location_on,
                            color: (locationController.addressTypeIndex == itemIndex) ? AppColors.mainColor : Theme.of(context).disabledColor,
                          ),
                        ),
                      );
                    }),),
                ),
                SizedBox(height: Dimensions.height20,),
                Padding(
                  padding: EdgeInsets.only(left: Dimensions.edgeInsets20),
                  child: BigText(text: "Delivery address"),
                ),
                SizedBox(height: Dimensions.height10,),
                AppTextField(hintText: "Your Address",
                    textEditingController: _addressController,
                    iconData: Icons.map),
                SizedBox(height: Dimensions.height20,),
                Padding(
                  padding: EdgeInsets.only(left: Dimensions.edgeInsets20),
                  child: BigText(text: "Contact name"),
                ),
                SizedBox(height: Dimensions.height10,),
                AppTextField(hintText: "Your Name",
                    textEditingController: _contactPersonNameController,
                    iconData: Icons.person),
                SizedBox(height: Dimensions.height20,),
                Padding(
                  padding: EdgeInsets.only(left: Dimensions.edgeInsets20),
                  child: BigText(text: "Delivery phone number"),
                ),
                SizedBox(height: Dimensions.height10,),
                AppTextField(hintText: "Your Number",
                    textEditingController: _contactPersonNumberController,
                    iconData: Icons.phone),
              ],
            ),
          );
        },);
      },),
    );
  }
}
