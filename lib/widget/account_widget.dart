import 'package:flutter/material.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widget/app_icon.dart';
import 'package:food_delivery/widget/big_text.dart';

class AccountWidget extends StatelessWidget {
  AppIcon _appIcon;
  BigText _bigText;

  AccountWidget({required AppIcon appIcon, required BigText bigText, Key? key})
      : _appIcon = appIcon,
        _bigText = bigText,
        super(key: key); // 초기화, initialize fields

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(offset: const Offset(0, 5), color: Colors.grey.withOpacity(0.2), blurRadius: 1),
        ],
      ),
      padding: EdgeInsets.only(
        left: Dimensions.edgeInsets20,
        top: Dimensions.edgeInsets10,
      ),
      child: Row(
        children: [
          _appIcon,
          SizedBox(
            width: Dimensions.height20,
          ),
          Flexible(child: _bigText)
        ],
      ),
    );
  }
}
