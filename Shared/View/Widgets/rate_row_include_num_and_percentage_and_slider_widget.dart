import 'package:carebuddy/Features/Shared/Models/babysitter_request_model.dart';
import 'package:flutter/material.dart';
import '../../../../Core/Constants/constants.dart';
import '../../../../Core/Theme/colors.dart';

class RateRowIncludeNumAndPercentageAndSliderWidget extends StatelessWidget {
  final List<BabysitterRequestModel> requestsWithReviews;
  final int starNum;
  const RateRowIncludeNumAndPercentageAndSliderWidget({super.key, required this.starNum, required this.requestsWithReviews});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Text("$starNum stars"),
        Expanded(
            child: LayoutBuilder(
              builder: (context,constraints){
                return Stack(
                  alignment: AlignmentDirectional.topStart,
                  clipBehavior: Clip.hardEdge,
                  children: [
                    Container(
                      height: 6,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: AppConstants.kMaxRadius,
                          color: AppColors.kBlack.withOpacity(0.175)
                      ),
                    ),
                    Container(
                      height: 6,
                      width: constraints.maxWidth * ((requestsWithReviews.where((e)=> e.rateOfParent!.rate == starNum).toList().length)/requestsWithReviews.length),
                      decoration: BoxDecoration(
                          borderRadius: AppConstants.kMaxRadius,
                          color: AppColors.kYellow
                      ),
                    )
                  ],
                );
              },
            )
        ),
        Text("${(((requestsWithReviews.where((e)=> e.rateOfParent!.rate == starNum).toList().length)/requestsWithReviews.length)*100).toInt()} %"),
      ],
    );
  }
}
