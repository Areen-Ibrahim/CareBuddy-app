import 'package:carebuddy/Core/Components/app_scaffold_widget.dart';
import 'package:carebuddy/Core/Constants/constants.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Constants/images.dart';
import 'package:carebuddy/Core/Theme/colors.dart';
import 'package:carebuddy/Features/Shared/Models/comment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../Core/Constants/translation_keys.dart';

class RateOfRequestViewScreen extends StatelessWidget {
  final CommentModel commentModel;
  const RateOfRequestViewScreen({super.key,required this.commentModel});

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appBar: AppBar(title: Text(TranslationKeys.review.tr(context))),
      body: ListView(
        padding: AppConstants.kScaffoldPadding.copyWith(bottom: 22),
        children: [
          Text("${TranslationKeys.score.tr(context)} :",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: AppColors.kBlack)),
          2.vrSpace,
          SizedBox(
            height: 24,width: 24,
            child: ListView.separated(
              itemCount: 5,
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context,index)=> 6.hrSpace,
              itemBuilder: (context,index)=> SvgPicture.asset(AppImages.kStarIcon,height: 22,width: 22,color: index < commentModel.rate ? AppColors.kYellow : AppColors.kGrey),
            ),
          ),
          14.vrSpace,
          Container(
            padding: AppConstants.kContainerPadding,
            decoration: BoxDecoration(
              borderRadius: AppConstants.kMainRadius,
              color: Colors.grey.shade200,
              border: AppConstants.kMainBorder
            ),
            child: Text(commentModel.comment,style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.kBlack),),
          ),
        ],
      ),
    );
  }
}
