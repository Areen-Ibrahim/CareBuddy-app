import 'package:carebuddy/Core/Components/app_scaffold_widget.dart';
import 'package:carebuddy/Core/Constants/constants.dart';
import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Theme/colors.dart';
import 'package:carebuddy/Features/Parent/Controller/Layout/parents_cubit.dart';
import 'package:carebuddy/Features/Parent/View/Screens/edit_kid_screen.dart';
import 'package:carebuddy/Features/Shared/Models/kid_model.dart';
import 'package:flutter/material.dart';
import '../../../../Core/Constants/images.dart';
import '../../../../Core/Constants/translation_keys.dart';

class KidDetailsScreen extends StatelessWidget {
  final KidModel kid;
  final bool showEditBtn;
  final ParentsCubit cubit;
  const KidDetailsScreen({super.key, required this.kid, required this.showEditBtn, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appBar: AppBar(title: Text(TranslationKeys.kidDetails.tr(context))),
      body: SingleChildScrollView(
        padding: AppConstants.kScaffoldPadding.copyWith(bottom: 22,left: 30,right: 30,top: 22),
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            borderRadius: AppConstants.kMaxRadius,
            color: AppColors.kMain.withOpacity(0.7)
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 14,
            children: [
              Container(
                height: 110,
                width: 110,
                margin: const EdgeInsets.only(bottom: 8),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.withOpacity(0.5),
                    border: Border.all(color: const Color(0xffB272A4).withOpacity(0.5),width: 4),
                    image: DecorationImage(fit: BoxFit.cover,image: kid.image != null ? NetworkImage(kid.image!) : const AssetImage(AppImages.kAccountIcon))
                ),
              ),
              Text(kid.name,style: TextStyle(fontSize: 18,color: AppColors.kWhite,fontWeight: FontWeight.w400)),
              Text(kid.dateOfBirth,style: TextStyle(fontSize: 18,color: AppColors.kWhite,fontWeight: FontWeight.w400)),
              Text(kid.dietaryRequirements,style: TextStyle(fontSize: 18,color: AppColors.kWhite,fontWeight: FontWeight.w400),textAlign: TextAlign.center),
              Text(kid.notes,style: TextStyle(fontSize: 18,color: AppColors.kWhite,fontWeight: FontWeight.w400),textAlign: TextAlign.center),
              Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(kid.gender == GenderStatus.Male.name ? Icons.male : Icons.female,color: AppColors.kWhite),
                  Text(kid.gender,style: TextStyle(fontSize: 18,color: AppColors.kWhite,fontWeight: FontWeight.w400)),
                ],
              ),
              if( showEditBtn )
                GestureDetector(
                  onTap: ()=> context.push(EditKidScreen(calledFromDetailsScreen: true,cubit: cubit, kid: kid)),
                  child: Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.kMain,
                      borderRadius: AppConstants.kMainRadius
                    ),
                    child: Text(TranslationKeys.edit.tr(context),style: TextStyle(fontSize: 16,fontWeight:FontWeight.w700,color : AppColors.kWhite)),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
