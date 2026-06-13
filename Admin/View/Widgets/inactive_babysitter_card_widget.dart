import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Services/localizations.dart';
import 'package:carebuddy/Features/Admin/Controller/admin_cubit.dart';
import 'package:carebuddy/Features/Admin/View/screens/inactive_babysitter_details_page.dart';
import 'package:carebuddy/Features/BabySitter/Models/baby_sitter.dart';
import 'package:flutter/material.dart';
import '../../../../Core/Constants/constants.dart';
import '../../../../Core/Constants/images.dart';
import '../../../../Core/Services/cache_manager_service.dart';
import '../../../../Core/Theme/colors.dart';

class InactiveBabysitterCardWidget extends StatelessWidget {
  final Babysitter babySitter;
  final AdminCubit cubit;
  const InactiveBabysitterCardWidget({super.key, required this.babySitter, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> context.push(BabysitterDetailsAsAdminPage(validationNotBlocked: true,babySitter: babySitter, cubit: cubit)),
      child: Container(
        padding: AppConstants.kContainerPadding,
        decoration: BoxDecoration(
            color: AppColors.kMain.withOpacity(0.76),
            borderRadius: AppConstants.kMainRadius
        ),
        child: Row(
          spacing: 14,
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              height: 46,width: 46,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.withOpacity(0.5),
                  image: DecorationImage(fit: BoxFit.cover,image: babySitter.multiMedia.profileImage != null ? NetworkImage(babySitter.multiMedia.profileImage!) : AssetImage(AppImages.kAccountIcon))
              ),
              child: babySitter.multiMedia.profileImage != null ? Image.network(babySitter.multiMedia.profileImage!,height: 46,width: 46) : Image.asset(AppImages.kAccountIcon,height: 46,width: 46),
            ),
            Expanded(
              child: Text("${babySitter.fName} ${babySitter.lname}",style: TextStyle(fontSize: 16,color: AppColors.kWhite,fontWeight: FontWeight.w500),),
            ),
            Builder(
              builder: (context){
                if( babySitter.status == ResponseOfInactiveBabysitterRequest.Pending.name )
                  {
                    return Icon(Icons.navigate_next,color: AppColors.kWhite,);
                  }
                else
                  {
                    return Column(
                      spacing: 2,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(babySitter.status == ResponseOfInactiveBabysitterRequest.Accepted.name ? Icons.check_circle : Icons.cancel,color: babySitter.status == ResponseOfInactiveBabysitterRequest.Accepted.name ? AppColors.kGreen : AppColors.kRed,),
                        Text(MyLocalizations.getValueFromLanguage(babySitter.status.toLowerCase(), CacheManagerService.readCurrentLanguage()),style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: babySitter.status == ResponseOfInactiveBabysitterRequest.Accepted.name ? AppColors.kGreen : AppColors.kRed),)
                      ],
                    );
                  }
              },
            ),
          ],
        ),
      ),
    );
  }
}
