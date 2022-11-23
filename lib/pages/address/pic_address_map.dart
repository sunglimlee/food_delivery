// 화면을 더 크게해서 보고 싶다.
// 여전히 LocationController 를 통해서 값을 업데이트 하고, repository 를 통해서 sharedPreference 과 ApiClient 의 연결을 하겠지..
// 기억하자. 새로운 페이지가 시작되면 반드시 라우트도 세팅을 해주어야 한다는것..
import 'package:flutter/material.dart';

class PicAddressMap extends StatefulWidget {
  const PicAddressMap({Key? key}) : super(key: key);

  @override
  State<PicAddressMap> createState() => _PicAddressMapState();
}

class _PicAddressMapState extends State<PicAddressMap> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
