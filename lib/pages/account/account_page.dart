import 'package:flutter/material.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widget/account_widget.dart';
import 'package:food_delivery/widget/app_icon.dart';
import 'package:food_delivery/widget/big_text.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 앱바 영역
      appBar: AppBar(
        title: BigText(text: "Profile", size: 24, color: Colors.white),
        backgroundColor: AppColors.mainColor,
      ),
      body: Container(
        width: double.maxFinite, // 최대한 사이즈를 확보해 주는 것.
        margin: EdgeInsets.only(
          top: Dimensions.height20,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 큰 아이콘 부분
              AppIcon(
                icon: Icons.person,
                backgroundColor: AppColors.mainColor,
                iconColor: Colors.white,
                iconSize: Dimensions.height45 + Dimensions.height30,
                size: Dimensions.height15 * 10,
              ),
              // 각 내용
              SizedBox(height: Dimensions.height30,),
              // Profile Icon
              AccountWidget(
                  appIcon: AppIcon(
                    icon: Icons.person,
                    backgroundColor: AppColors.mainColor,
                    iconColor: Colors.white,
                    iconSize: Dimensions.height10*5/2,
                    size: Dimensions.height10 * 5,
                  ),
                  bigText: BigText(text: "Steve",)),
              SizedBox(height: Dimensions.height30,),
              // name
              AccountWidget(
                  appIcon: AppIcon(
                    icon: Icons.person,
                    backgroundColor: AppColors.mainColor,
                    iconColor: Colors.white,
                    iconSize: Dimensions.height10*5/2,
                    size: Dimensions.height10 * 5,
                  ),
                  bigText: BigText(text: "Steve",)),
              SizedBox(height: Dimensions.height30,),
              // phone
              AccountWidget(
                  appIcon: AppIcon(
                    icon: Icons.phone,
                    backgroundColor: AppColors.yellowColor,
                    iconColor: Colors.white,
                    iconSize: Dimensions.height10*5/2,
                    size: Dimensions.height10 * 5,
                  ),
                  bigText: BigText(text: "416-803-7788",)),
              SizedBox(height: Dimensions.height30,),
              // email
              AccountWidget(
                  appIcon: AppIcon(
                    icon: Icons.email,
                    backgroundColor: AppColors.yellowColor,
                    iconColor: Colors.white,
                    iconSize: Dimensions.height10*5/2,
                    size: Dimensions.height10 * 5,
                  ),
                  bigText: BigText(text: "Steve.patriot@gamil.com",)),
              SizedBox(height: Dimensions.height30,),
              // address
              AccountWidget(
                  appIcon: AppIcon(
                    icon: Icons.location_on,
                    backgroundColor: AppColors.mainColor,
                    iconColor: Colors.white,
                    iconSize: Dimensions.height10*5/2,
                    size: Dimensions.height10 * 5,
                  ),
                  bigText: BigText(text: "36 Mayland Trail, Stoney Creek, L8J0G4",)),
              SizedBox(height: Dimensions.height30,),
              // message
              AccountWidget(
                  appIcon: AppIcon(
                    icon: Icons.message_outlined,
                    backgroundColor: Colors.redAccent,
                    iconColor: Colors.white,
                    iconSize: Dimensions.height10*5/2,
                    size: Dimensions.height10 * 5,
                  ),
                  bigText: BigText(text: "Steve",)),
              SizedBox(height: Dimensions.height30,),
            ],
          ),
        ),
      ),
    );
  }
}
