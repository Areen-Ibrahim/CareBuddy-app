import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import '../Constants/translation_keys.dart';

void showAwesomeDialogWidget({Widget? btnOk,Color? btnOkColor,String? okBtnText,String? cancelBtnText,required String title,required String desc,required BuildContext context,required DialogType type,bool? showOnlyOkBtn,Function()? okBtnMethod}){
  AwesomeDialog(
    context: context,
    dialogType: type,
    animType: AnimType.bottomSlide,
    title: title,
    desc: desc,
    btnOkColor: btnOkColor,
    buttonsBorderRadius: BorderRadius.circular(6),
    dialogBorderRadius: BorderRadius.circular(6),
    transitionAnimationDuration: const Duration(milliseconds: 400),
    padding: const EdgeInsets.symmetric(horizontal: 14),
    btnOkText: okBtnText ?? TranslationKeys.confirm.tr(context),
    btnOk: btnOk,
    reverseBtnOrder: true,
    titleTextStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: AppColors.kMain,height: 1.6),
    descTextStyle: TextStyle(fontSize: 14,height: 1.6,fontWeight: FontWeight.w400,color: AppColors.kBlack),
    btnCancelText: showOnlyOkBtn == null ? cancelBtnText ?? TranslationKeys.cancel.tr(context) : null,
    btnCancelOnPress: showOnlyOkBtn == null ? () => Navigator.canPop(context) : null,
    btnOkOnPress: ()
    {
      okBtnMethod != null ? okBtnMethod() : Navigator.canPop(context);
    },
  ).show();
}