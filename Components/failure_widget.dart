import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:flutter/material.dart';
import '../Constants/constants.dart';
import '../Constants/translation_keys.dart';
import '../Theme/colors.dart';
import 'custom_btn_widgets.dart';

class FailureWidget extends StatelessWidget {
  final Function()? onTap;
  final String? message;
  const FailureWidget({super.key,required this.onTap,this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppConstants.kScaffoldPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 14,
          children:
          [
            Icon(Icons.error,color: AppColors.kBlack,size: 36),
            Text(message ?? TranslationKeys.somethingWentWrong.tr(context),style: TextStyle(fontSize: 16,color: AppColors.kBlack,fontWeight: FontWeight.w700)),
            if( onTap != null )
              BtnWidget(
                  onTap: onTap,
                  title: TranslationKeys.tryAgain.tr(context)
              )
          ],
        ),
      ),
    );
  }
}