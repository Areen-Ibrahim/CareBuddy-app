import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../Core/Constants/constants.dart';
import '../../../../Core/Constants/images.dart';
import '../../../../Core/Theme/colors.dart';

class RatingOverviewContainerWidget extends StatelessWidget {
  final String name;
  final String? image;
  final int rate;
  final String comment;
  final String? nationality;
  const RatingOverviewContainerWidget({super.key, required this.name, required this.rate, required this.comment,this.nationality, this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppConstants.kContainerPadding,
      decoration: BoxDecoration(
          color: AppColors.kMain,
          borderRadius: AppConstants.kMainRadius
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Row(
            spacing: 8,
            children: [
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: image !=
                            null
                            ? NetworkImage(image!)
                            : const AssetImage(
                            "assets/images/account.png"
                        ),
                        fit: BoxFit.cover
                    )
                ),
              ),
              Expanded(
                child: Text.rich(
                  TextSpan(
                      children: [
                        TextSpan(
                            text: "$name "
                        ),
                        if( nationality != null )
                          TextSpan(
                              text: nationality,style: const TextStyle(color: Color(0xffABA0A0))
                          ),
                      ]
                  ),
                  style: TextStyle(fontWeight: FontWeight.w500,color: AppColors.kWhite,fontSize: 14),
                ),
              ),
              Row(
                spacing: 2,
                children: List.generate(5, (index)=> SvgPicture.asset(AppImages.kStarIcon,height: 16,width: 16,color: index < rate ? AppColors.kYellow : AppColors.kGrey)),
              )
            ],
          ),
          Text(comment,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: AppColors.kWhite),)
        ],
      ),
    );
  }
}
