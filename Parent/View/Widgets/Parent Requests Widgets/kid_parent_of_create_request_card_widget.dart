import 'package:carebuddy/Features/Parent/Controller/Layout/parents_cubit.dart';
import 'package:carebuddy/Features/Shared/Models/kid_model.dart';
import 'package:flutter/material.dart';
import '../../../../../Core/Constants/constants.dart';
import '../../../../../Core/Constants/images.dart';
import '../../../../../Core/Theme/colors.dart';

class KidParentOfCreateRequestCardWidget extends StatelessWidget {
  final KidModel kid;
  final ParentsCubit cubit;
  const KidParentOfCreateRequestCardWidget({super.key, required this.kid, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> cubit.selectKidOnCreateRequestBabysitter(kid),
      child: Container(
        width: 120,
        child: Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            Container(
              padding: AppConstants.kContainerPadding,
              decoration: BoxDecoration(
                  borderRadius: AppConstants.kMainRadius,
                  border: Border.all(color: AppColors.kBlack.withOpacity(0.1)),
                  color: cubit.selectedKidOnCreateRequestBabysitter != null && cubit.selectedKidOnCreateRequestBabysitter!.id == kid.id ? AppColors.kMain : const Color(0xffF4F4F4)
              ),
              child: Center(
                child: Column(
                  spacing: 14,
                  children: [
                    Container(
                      height: 72,
                      width: 72,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: cubit.selectedKidOnCreateRequestBabysitter != null && cubit.selectedKidOnCreateRequestBabysitter!.id == kid.id ? Colors.transparent : const Color(0xffB272A4).withOpacity(0.5),width: cubit.selectedKidOnCreateRequestBabysitter != null && cubit.selectedKidOnCreateRequestBabysitter!.id == kid.id ? 0 : 4),
                          image: DecorationImage(fit: BoxFit.cover,image: kid.image != null ? NetworkImage(kid.image!) : const AssetImage(AppImages.kAccountIcon))
                      ),
                    ),
                    Text(kid.name,textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color: cubit.selectedKidOnCreateRequestBabysitter != null && cubit.selectedKidOnCreateRequestBabysitter!.id == kid.id ? AppColors.kWhite : AppColors.kMain,fontWeight: FontWeight.bold),maxLines: 1,overflow: TextOverflow.ellipsis)
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Icon(cubit.selectedKidOnCreateRequestBabysitter != null && cubit.selectedKidOnCreateRequestBabysitter!.id == kid.id ? Icons.check_box : Icons.check_box_outline_blank,color: cubit.selectedKidOnCreateRequestBabysitter != null && cubit.selectedKidOnCreateRequestBabysitter!.id == kid.id ? AppColors.kWhite : AppColors.kMain),
            )
          ],
        ),
      ),
    );
  }
}
