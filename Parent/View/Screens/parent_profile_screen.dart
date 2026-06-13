import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carebuddy/Core/Components/custom_btn_widgets.dart';
import 'package:carebuddy/Core/Components/log_out_column_btn_widget.dart';
import 'package:carebuddy/Core/Components/show_awesome_dialog_widget.dart';
import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Services/localizations.dart';
import 'package:carebuddy/Core/Services/url_launcher_service.dart';
import 'package:carebuddy/Features/Parent/Controller/Layout/parents_cubit.dart';
import 'package:carebuddy/Features/Parent/Controller/Layout/parents_states.dart';
import 'package:carebuddy/Features/Parent/View/Screens/add_new_kid_screen.dart';
import 'package:carebuddy/Features/Parent/View/Screens/parent_edit_profile_screen.dart';
import 'package:carebuddy/Features/Parent/View/Screens/parent_update_profile_image_screen.dart';
import 'package:carebuddy/Features/Parent/View/Screens/view_rates_of_parent_screen.dart';
import 'package:carebuddy/Features/Parent/View/Widgets/Parent%20Profile%20WIdgets/kid_parent_profile_card_widget.dart';
import 'package:carebuddy/Features/Shared/View/Widgets/toggle_language_column_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/Constants/constants.dart';
import '../../../../Core/Constants/images.dart';
import '../../../../Core/Constants/translation_keys.dart';
import '../../../../Core/Services/cache_manager_service.dart';
import '../../../../Core/Theme/colors.dart';

class ParentProfileScreen extends StatelessWidget {
  const ParentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ParentsCubit cubit = ParentsCubit.getInstance(context);
    return BlocBuilder<ParentsCubit,ParentsStates>(
        builder: (context,state) {
          return Padding(
            padding: AppConstants.kContainerPadding.copyWith(top: context.topPaddingOfScreen + 22),
            child: Column(
              children: [
                Stack(
                  alignment: AlignmentDirectional.topStart,
                  children: [
                    Center(
                      child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.withOpacity(0.5),
                                  image: DecorationImage(fit: BoxFit.cover,image: NetworkImage(cubit.myData!.profileImage))
                              ),
                            ),
                            GestureDetector(
                              onTap: ()=> context.push(ParentUpdateProfileImageScreen(cubit: cubit)),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                    color: AppColors.kMain,
                                    shape: BoxShape.circle
                                ),
                                child: Image.asset(AppImages.kEditIcon,color: AppColors.kWhite),
                              ),
                            )
                          ]
                      ),
                    ),
                    LogOutColumnBtnWidget(onTap: ()=> cubit.logOut(context)),
                    const Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: ToggleLanguageColumnWidget(),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration:  BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: const Color(0xffF4F4F4),
                    ),
                    margin: const EdgeInsets.only(top: 22),
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: [
                              Text("${cubit.myData!.fName} ${cubit.myData!.lname}",style: TextStyle(overflow: TextOverflow.ellipsis,fontSize: 18,fontWeight: FontWeight.w600,color: AppColors.kMain),textAlign: TextAlign.center),
                              10.vrSpace,
                              Row(
                                spacing: 14,
                                children: List.generate(2, (index)=> Expanded(
                                  child: Container(
                                    padding: AppConstants.kContainerPadding,
                                    decoration: BoxDecoration(
                                        color: AppColors.kMain,
                                        borderRadius: AppConstants.kMaxRadius
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      spacing: index == 1 ? 10 : 0,
                                      children: [
                                        if( index == 1 )
                                          Icon(cubit.myData!.gender == GenderStatus.Male.name ? Icons.male : Icons.female,color: AppColors.kWhite),
                                        Flexible(child: Text(index == 0 ? cubit.myData!.phone : MyLocalizations.getValueFromLanguage(cubit.myData!.gender.toLowerCase(), CacheManagerService.readCurrentLanguage()),style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: AppColors.kWhite,overflow: TextOverflow.ellipsis))),
                                      ],
                                    ),
                                  ),
                                )),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: GestureDetector(
                                  onTap: ()=> UrlLauncherServices.openUrl(Uri.parse(cubit.myData!.locationUrl)),
                                  child: Container(
                                    padding: AppConstants.kContainerPadding,
                                    decoration: BoxDecoration(
                                        color: const Color(0xffF4F4F4),
                                        borderRadius: AppConstants.kMainRadius,
                                        boxShadow: [BoxShadow(color: AppColors.kBlack.withOpacity(0.1),blurRadius: 10,offset: const Offset(0, 4))]
                                    ),
                                    child: Row(
                                      spacing: 14,
                                      children: [
                                        Icon(Icons.attach_file,color: AppColors.kBlack),
                                        Expanded(
                                          child: Text(cubit.myData!.locationUrl,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: AppColors.kBlack),maxLines: 1,overflow: TextOverflow.ellipsis),
                                        ),
                                        Icon(Icons.location_on,color: AppColors.kMain)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 22,bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(TranslationKeys.kidsCards.tr(context),style: TextStyle(fontSize: 18,color: AppColors.kMain,fontWeight: FontWeight.w600)),
                                    GestureDetector(
                                      onTap: ()=> context.push(AddNewKidScreen(cubit: cubit)),
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                            color: AppColors.kMain,
                                            shape: BoxShape.circle
                                        ),
                                        child: Icon(Icons.add,color: AppColors.kWhite),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Builder(
                                builder: (context){
                                  if( cubit.myData!.kids.isNotEmpty )
                                  {
                                    return SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.zero,
                                      child: Row(
                                        spacing: 14,
                                        children: List.generate(cubit.myData!.kids.length, (index)=> KidParentProfileCardWidget(cubit: cubit,kid: cubit.myData!.kids.reversed.toList()[index])),
                                      ),
                                    );
                                  }
                                  else
                                  {
                                    return Container(
                                      margin: const EdgeInsets.only(top: 14.0),
                                      child: Text(TranslationKeys.noKidsAddedYet.tr(context),textAlign: TextAlign.center,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: AppColors.kBlack)),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        Align(
                            alignment: AlignmentDirectional.topEnd,
                            child: IntrinsicWidth(
                              child: GestureDetector(
                                onTap: ()=> context.push(ParentEditProfileScreen(cubit: cubit)),
                                child: Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: AppConstants.kMainRadius,
                                      color: AppColors.kMain
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    spacing: 8,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(AppImages.kEditIcon,color: AppColors.kWhite,height: 16,width: 16,),
                                      Text(TranslationKeys.edit.tr(context),style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.white),)
                                    ],
                                  ),
                                ),
                              ),
                            )
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 14),
                  alignment: AlignmentDirectional.topStart,
                  child: IntrinsicWidth(
                    child: Row(
                      spacing: 16,
                      children: [
                        BtnWidget(
                          onTap: ()=> context.push(ViewRatesOfParentScreen(cubit: cubit)),
                          title: TranslationKeys.viewRates.tr(context),
                        ),
                        BtnWidget(
                            onTap: (){
                              showAwesomeDialogWidget(title: TranslationKeys.deleteAccount.tr(context),okBtnMethod: ()=> cubit.deleteAccount(context: context), desc: TranslationKeys.deleteAccountAlert.tr(context), context: context, type: DialogType.warning);
                            },
                            title: TranslationKeys.deleteAccount.tr(context)
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }
    );
  }
}
