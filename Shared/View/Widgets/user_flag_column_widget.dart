import 'package:carebuddy/Core/Components/custom_btn_widgets.dart';
import 'package:carebuddy/Core/Constants/constants.dart';
import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Constants/translation_keys.dart';
import 'package:carebuddy/Core/Theme/colors.dart';
import 'package:carebuddy/Features/BabySitter/Models/baby_sitter.dart';
import 'package:carebuddy/Features/Shared/Controller/shared_cubit.dart';
import 'package:flutter/material.dart';

class UserFlagColumnWidget extends StatelessWidget {
  final int canceledOrdersNum;
  const UserFlagColumnWidget({super.key, required this.canceledOrdersNum});

  @override
  Widget build(BuildContext context) {
    if( canceledOrdersNum > 5 )
    {
      return Container(
        margin: EdgeInsets.only(bottom: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 4,
          children: [
            Icon(Icons.flag,color: AppColors.kRed,),
            Text(TranslationKeys.manyOrdersCanceled.tr(context),style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: AppColors.kBlack),)
          ],
        ),
      );
    }
    else
      {
        return const SizedBox();
      }
  }
}
