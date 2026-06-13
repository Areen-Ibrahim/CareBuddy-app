import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:flutter/material.dart';
import '../Constants/translation_keys.dart';
import '../Theme/colors.dart';

class AlreadyHaveAnAccountRowWidget extends StatelessWidget {
  final Function()? onTap;
  const AlreadyHaveAnAccountRowWidget({super.key,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("${TranslationKeys.alreadyHaveAnAccount.tr(context)} ",style: TextStyle(fontSize: 16,color: AppColors.kBlack,fontWeight: FontWeight.w400)),
          GestureDetector(
            onTap: onTap,
            child: Text(TranslationKeys.clickHere.tr(context),style: TextStyle(fontSize: 16,color: AppColors.kMain,fontWeight: FontWeight.w500),),
          )
        ],
      ),
    );
  }
}

class NeedToCreateAnAccountRowWidget extends StatelessWidget {
  final Function()? onTap;
  const NeedToCreateAnAccountRowWidget({super.key,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("${TranslationKeys.doNotHaveAccount.tr(context)} ",style: TextStyle(fontSize: 16,color: AppColors.kBlack,fontWeight: FontWeight.w400)),
          GestureDetector(
            onTap: onTap,
            child: Text(TranslationKeys.clickHere.tr(context),style: TextStyle(fontSize: 16,color: AppColors.kMain,fontWeight: FontWeight.w500),),
          )
        ],
      ),
    );
  }
}

