// 화면을 더 크게해서 보고 싶다.
// 여전히 LocationController 를 통해서 값을 업데이트 하고, repository 를 통해서 sharedPreference 과 ApiClient 의 연결을 하겠지..
// 기억하자. 새로운 페이지가 시작되면 반드시 라우트도 세팅을 해주어야 한다는것..
import 'package:flutter/material.dart';
import 'package:food_delivery/base/custom_button.dart';
import 'package:food_delivery/controller/location_controller.dart';
import 'package:food_delivery/pages/address/widgets/search_location_dialog_page.dart';
import 'package:food_delivery/routes/route_helper.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PickAddressMap extends StatefulWidget {
  final bool fromSignup; // 맨처음 사인업 페이지에서 왔는지..
  final bool fromAddress;
  final GoogleMapController? googleMapController;

  const PickAddressMap(
      {Key? key,
      required this.fromSignup,
      required this.fromAddress,
      this.googleMapController})
      : super(key: key);

  @override
  State<PickAddressMap> createState() => _PickAddressMapState();
}

class _PickAddressMapState extends State<PickAddressMap> {
  late LatLng _initialPosition;
  late GoogleMapController _mapController;
  late CameraPosition _cameraPosition;

  @override
  void initState() {
    super.initState();
    // 이전에 유저가 값을 가지고 있는지 확인하고 그값을 여기에다가 넣어 줄거다.
    if (Get.find<LocationController>().addressList.isEmpty) {
      _initialPosition = LatLng(45.521523, -122.677433);
      _cameraPosition = CameraPosition(target: _initialPosition, zoom: 17);
    } else {
      _initialPosition = LatLng(
          double.parse(
              Get.find<LocationController>().getAddress["latitude"].toString()),
          double.parse(Get.find<LocationController>()
              .getAddress["longitude"]
              .toString()));
      _cameraPosition = CameraPosition(target: _initialPosition, zoom: 17);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<LocationController>(
          // 여기보다시피 통째로 GetBuilder 를 해놨는데 이렇게 하면 비효율적이지.. 각각 개별적으로 해주어야지.
          builder: (locationController) {
            return Center(
              child: SizedBox(
                width: double.maxFinite,
                child: Stack(
                  // 이렇게 구글과 position 과 값들을 올려놓으면 구글의 위치가 바뀌면 어떻게 pick 이미지도 같이 변경시키지?
                  children: [
                    GoogleMap(
                      initialCameraPosition:
                          CameraPosition(target: _initialPosition, zoom: 17),
                      zoomControlsEnabled: false,
                      onCameraMove: (cameraposition) {
                        _cameraPosition =
                            cameraposition; // 움직일때마다 이걸로 여기 로컬필드에 저장했다가 다른데 보내준다.
                      },
                      onCameraIdle: () {
                        Get.find<LocationController>()
                            .updatePosition(_cameraPosition, false); // 움직이는걸 멈추자마자 저장을 시작한다.
                      },
                      onMapCreated: (GoogleMapController googleMapController) {
                        _mapController = googleMapController;
                        if (!widget.fromAddress) {
                          // TODO
                        }
                      },
                    ),
                    // stack 을 사용하는 이유가 여기 나오네..
                    // 구글맵이 보여질 때 가장 중간을 기준으로 보여지니깐 여기 stack 에서서도 이렇게 pick 으로 선택할 수 있네..
                    // 그리고 pick 을 옮길 이유가 없네.. 왜냐면 지도를 옮기는 것 자체가 중앙을 선택하겠다는 의미이니깐.. ㅋ
                    Center(
                      child: !locationController.loading
                          ? Image.asset(
                              "assets/image/pick_marker.png",
                              height: Dimensions.height10 * 5,
                              width: Dimensions.height10 * 5,
                            )
                          : CircularProgressIndicator(),
                    ),
                    // 윗쪽의 주소부분 (Showing and selection address)
                    Positioned(
                      top: Dimensions.height45,
                      left: Dimensions.height20,
                      right: Dimensions.height20,
                      child: InkWell(
                        onTap: ()=> Get.dialog(LocationDialog(googleMapController: _mapController)),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.edgeInsets10),
                          height: Dimensions.height10 * 5,
                          decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius:
                                BorderRadius.circular(Dimensions.radius20 / 2),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: Dimensions.edgeInsets5 * 5,
                                color: AppColors.yellowColor,
                              ),
                              Expanded(
                                  child: Text(
                                "${locationController.pickPlacemark.name ?? ''}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  //fontSize: Dimensions.font16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow
                                    .ellipsis, // TextOverflow 자체가 enum 이네. 그래서 ellipsis 를 바로 쓸 수 있구나.
                              )),
                              SizedBox(width: Dimensions.edgeInsets10,),
                              Icon(Icons.search, size: Dimensions.edgeInsets5*5, color: AppColors.yellowColor,),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // 밑의 버턴부분
                    Positioned(
                        bottom: 80,
                        left: Dimensions.edgeInsets20,
                        right: Dimensions.edgeInsets20,
                        child: locationController.isLoading?Center(child: CircularProgressIndicator(),): CustomButton(
                          buttonText: locationController.inZone?widget.fromAddress?'Pick Address':'Pick Location': 'Service not available in the area.',
                          // 나같으면 로딩이 되고 있을 때는 버턴이 안보이도록 하고 로딩이 끝나고 나면 버턴이 보이도록 하겠다.
                          onPressed: (locationController.buttonDisabled || locationController.loading)
                              ? () {
                            print(
                                "LSL : in pick_address_map.dart, >>> Should be null value. <<<)");
                          }
                              : () {
                            // 맵의 값을 받아서 그 값을 저장하는걸 하겠지..
                            if (locationController
                                .pickPosition.latitude !=
                                0 &&
                                locationController.pickPlacemark.name !=
                                    null) {
                              if (widget.fromAddress) {
                                if (widget.googleMapController != null) {
                                  // 점점 짜증나네.. 이건 당연히 null 이 아니지.
                                  print(
                                      "LSL : in pic_address_map.dart, >>> Now you can click on this. <<<");
                                  // 그럼 여기 옮긴 값은 어디에 저장되는거지?
                                  // 그게 아니라 현재 이 페이지에 있는 GoogleMap 은 외부의 googleMapController 와 연결이 되어있지 않고
                                  // 독립적으로 움직이고 있다가 내가 버턴을 누르면 그때에 외부의 googleMapController 에 누른 값을 저장한다는것이다.
                                  // 니가 생각하는것처럼 이 googleMapController 가 여기 GoogleMap 에 바로 연결되어 있지는 않다는 거다.
                                  // 그래서 이 저장한 값은 맨처음에 googleMap 을 생성할 onMapCreate() 할 때 한번만 controller 를 연결해주면
                                  // 그다음부터는 그걸 어디서든지 사용할 수 있다는 것이다.
                                  widget.googleMapController!.moveCamera(
                                      CameraUpdate.newCameraPosition(
                                          CameraPosition(
                                              target: LatLng(
                                                  locationController
                                                      .pickPosition
                                                      .latitude,
                                                  locationController
                                                      .pickPosition
                                                      .longitude))));
                                  locationController.setAddAddressData(); // pick 값들을 address 값으로 Getx field 들을 맞춰준다.
                                }
                                // Get.back(); // 이건 의미없이 앞으로 가는거라서 많은 문제를 유발하게 되지..
                                // list, a value
                                Get.toNamed(RouteHelper.getAddAddressPage());
                              }
                            }
                          },
                        ))
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
