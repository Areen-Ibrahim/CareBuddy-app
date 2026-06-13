import 'package:flutter/material.dart';
import '../../../../Core/Constants/constants.dart';
import '../../../../Core/Theme/colors.dart';

class TxtFieldOfInactiveBabysitterWidget extends StatelessWidget {
  final String hint;
  final String txt;
  final Function()? onTap;
  const TxtFieldOfInactiveBabysitterWidget({super.key, required this.txt, required this.hint, this.onTap,});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 6,
          children: [
            Text(hint,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: AppColors.kBlack),),
            Container(
              padding: AppConstants.kContainerPadding,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppColors.kGrey,
                  borderRadius: AppConstants.kMainRadius
              ),
              child: Row(
                spacing: 14,
                children: [
                  Expanded(child: Text(txt,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: AppColors.kBlack),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                  if( onTap != null )
                    Icon(Icons.open_in_browser,color: AppColors.kMain,)
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}