import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Constants/translation_keys.dart';
import 'package:carebuddy/Core/Theme/colors.dart';
import 'package:carebuddy/Features/Shared/View/Screens/login_screen.dart';
import 'package:flutter/material.dart';
import '../../../../Core/Constants/images.dart';

class AccountUnderReviewScreen extends StatelessWidget {
  const AccountUnderReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage(AppImages.kBackgroundImage,),fit: BoxFit.cover,)
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 100, 24, 64),
              decoration: BoxDecoration(
                color: AppColors.kMain.withOpacity(0.5),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "${TranslationKeys.yourAccountIs.tr(context)} "
                        ),
                        TextSpan(text: TranslationKeys.currentlyUnderReview.tr(context),style: TextStyle(decoration: TextDecoration.underline,decorationColor: AppColors.kWhite,fontWeight: FontWeight.bold))
                      ]
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color: AppColors.kWhite),
                  ),
                  Text(TranslationKeys.asPartOfOurVerificationProcess.tr(context),style: TextStyle(fontWeight: FontWeight.w400,fontSize: 18,color: AppColors.kWhite),textAlign: TextAlign.center,),
                  14.vrSpace,
                  Text.rich(
                    TextSpan(
                        children: [
                          TextSpan(
                              text: "${TranslationKeys.thankYouForYourPatienceAndWelcome.tr(context)} "
                          ),
                          TextSpan(text: TranslationKeys.carebuddy.tr(context),style: TextStyle(color: AppColors.kMain,fontWeight: FontWeight.bold)),
                          TextSpan(text: TranslationKeys.family.tr(context)),
                        ]
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color: AppColors.kWhite),
                  ),
                  24.vrSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${TranslationKeys.alreadyHaveAnAccount.tr(context)} ",style: TextStyle(fontSize: 16,color: AppColors.kWhite,fontWeight: FontWeight.w500,shadows: [Shadow(color: AppColors.kBlack.withOpacity(0.25),blurRadius: 4,offset: const Offset(0, 4))])),
                      GestureDetector(
                        onTap: ()=> context.push(const LoginScreen(userType: UserType.Babysitter)),
                        child: Text(TranslationKeys.login.tr(context),style: TextStyle(fontSize: 16,color: AppColors.kMain,fontWeight: FontWeight.bold,shadows: [Shadow(color: AppColors.kBlack.withOpacity(0.25),blurRadius: 4,offset: const Offset(0, 4))]),),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
