import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Features/Parent/Controller/Layout/parents_cubit.dart';
import 'package:carebuddy/Features/Parent/View/Screens/edit_kid_screen.dart';
import 'package:carebuddy/Features/Shared/Models/kid_model.dart';
import 'package:carebuddy/Features/Shared/View/Screens/view_kid_details_screen.dart';
import 'package:flutter/material.dart';
import '../../../../../Core/Constants/constants.dart';
import '../../../../../Core/Constants/images.dart';
import '../../../../../Core/Theme/colors.dart';

class KidParentProfileCardWidget extends StatelessWidget {
  final KidModel kid;
  final ParentsCubit cubit;
  final bool onlyView;
  const KidParentProfileCardWidget({super.key, required this.kid,this.onlyView = false, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> context.push(KidDetailsScreen(kid: kid,showEditBtn: !onlyView,cubit: cubit)),
      child: Container(
        padding: AppConstants.kContainerPadding,
        width: 158,
        height: 170,
        decoration: BoxDecoration(
            borderRadius: AppConstants.kMainRadius,
            color: AppColors.kMain
        ),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 14,
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        height: 72,width: 72,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(fit: BoxFit.cover,image: kid.image != null ? NetworkImage(kid.image!) : const AssetImage(AppImages.kAccountIcon))
                        ),
                      ),
                      Visibility(
                        visible: !onlyView,
                        child: GestureDetector(
                          onTap: ()=> context.push(EditKidScreen(cubit: cubit, kid: kid, calledFromDetailsScreen: false)),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                color: AppColors.kWhite,
                                shape: BoxShape.circle
                            ),
                            child: Image.asset(AppImages.kEditIcon,color: AppColors.kMain),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Text(kid.name,style: TextStyle(fontSize: 16,color: AppColors.kWhite,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis)
              ],
            ),
            Icon(Icons.fullscreen,color: AppColors.kWhite)
          ],
        ),
      ),
    );
  }
}
