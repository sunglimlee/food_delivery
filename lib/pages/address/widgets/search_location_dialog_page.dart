import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:food_delivery/controller/location_controller.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/src/places.dart';

/// 주소 찾기 기능 클래스 아주 강력하고 좋다. 꼭 사용하자.
class LocationDialog extends StatelessWidget {
  final GoogleMapController googleMapController;

  const LocationDialog({Key? key, required this.googleMapController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingController = TextEditingController();
    return Container(
      padding: EdgeInsets.all(Dimensions.edgeInsets10),
      alignment: Alignment.topCenter,
      // 이걸 사용하니깐 비로서 여러가지 suggestion 이 나오기 시작하네..
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius20 / 2),
        ),
        child: SizedBox(
          width: Dimensions.screenWidth,
          child: TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
                controller: textEditingController,
                textInputAction: TextInputAction.search,
                // enum 에서 선택한것이다. 그래서 객체가 들어갈 수 있는거지.. 이처럼 enum 은 바로 넣을 수 있다.
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.streetAddress,
                decoration: InputDecoration(
                  hintText: "Search Location",
                  border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(Dimensions.edgeInsets10),
                      borderSide:
                          const BorderSide(style: BorderStyle.none, width: 0)),
                  hintStyle: Theme.of(context).textTheme.headline2?.copyWith(
                        color: Theme.of(context).disabledColor,
                        fontSize: Dimensions.font16,
                      ),
                )),
            // as we type, it gives us suggestion
            onSuggestionSelected: (Prediction prediction) {
              Get.find<LocationController>()
                  .setLocation(prediction.placeId!,prediction.description!, googleMapController);
              Get.back();

            },
            // suggestions come from google server, 그래서 외부에서 콜백함수가 필요하다.
            suggestionsCallback: (pattern) async {
              List<Prediction> list = await Get.find<LocationController>()
                  .searchLocation(context, pattern);
              return list;
            },
            itemBuilder: (BuildContext context, Prediction suggestion) {
              // 잘봐라. 위의 List<Prediction> 을 통해서 suggestion 이 나오니깐 반복이 되는거지..
              return Padding(
                padding: EdgeInsets.all(Dimensions.edgeInsets10),
                child: Row(
                  children: [
                    const Icon(Icons.location_on),
                    Expanded(
                      child: Text(
                        suggestion.description!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline2?.copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyText1?.color,
                              fontSize: Dimensions.font16,
                            ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
