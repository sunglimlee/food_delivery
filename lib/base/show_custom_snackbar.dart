import 'package:flutter/material.dart';
import 'package:food_delivery/widget/big_text.dart';
import 'package:get/get.dart';

// 일반함수도 생성자 함수와 마찬가지로 optional 변수들을 설정할 수 있다. 선언부에서 모두 다 선언하고 기본값도 여기서 다 지정해도 된다.
void showCustomSnackBar(String message, {bool isErrors=true, String title = "Error"}) {
  Get.snackbar(title, message,
  titleText: BigText(text: title, color: Colors.white), // 할 필요없지만 좀 더 커스터마이징을 해줄 수 있다.
    messageText: Text(message, style: const TextStyle(color: Colors.white),
    ),
    colorText: Colors.white,
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.redAccent,
  );
}