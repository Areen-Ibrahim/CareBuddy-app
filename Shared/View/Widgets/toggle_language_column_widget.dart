import 'package:carebuddy/Core/Components/custom_btn_widgets.dart';
import 'package:carebuddy/Core/Constants/constants.dart';
import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Constants/translation_keys.dart';
import 'package:carebuddy/Core/Theme/colors.dart';
import 'package:carebuddy/Features/Shared/Controller/shared_cubit.dart';
import 'package:flutter/material.dart';

class ToggleLanguageColumnWidget extends StatelessWidget {
  const ToggleLanguageColumnWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        showModalBottomSheet(
            context: context,
            builder: (context)=> BottomSheet(
                onClosing: (){},
                builder: (context)=> Padding(
                  padding: AppConstants.kContainerPadding.copyWith(top: 24,bottom: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 14,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(TranslationKeys.language.tr(context),textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w700,color: AppColors.kBlack,fontSize: 20),),
                      BtnWidget(
                        title: TranslationKeys.arabic.tr(context),
                        onTap: (){
                          context.pop;
                          SharedCubit.getInstance(context).toggleLanguage(lang: LanguageName.ar);
                        },
                      ),
                      BtnWidget(
                        title: TranslationKeys.english.tr(context),
                        backgroundColor: Colors.transparent,
                        txtColor: AppColors.kBlack,
                        borderColor: AppColors.kMain,
                        onTap: (){
                          context.pop;
                          SharedCubit.getInstance(context).toggleLanguage(lang: LanguageName.en);
                        },
                      ),
                    ],
                  ),
                )
            )
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 4,
        children: [
          const Icon(Icons.language),
          Text(TranslationKeys.language.tr(context))
        ],
      ),
    );
  }
}
