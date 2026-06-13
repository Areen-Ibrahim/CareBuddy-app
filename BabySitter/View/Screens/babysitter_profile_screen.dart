import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carebuddy/Core/Components/log_out_column_btn_widget.dart';
import 'package:carebuddy/Core/Constants/constants.dart';
import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Theme/colors.dart';
import 'package:carebuddy/Features/BabySitter/Controller/Layout/babysitter_cubit.dart';
import 'package:carebuddy/Features/BabySitter/Controller/Layout/babysitter_state.dart';
import 'package:carebuddy/Features/BabySitter/View/Screens/babysitter_add_new_service_screen.dart';
import 'package:carebuddy/Features/BabySitter/View/Screens/babysitter_edit_profile_screen.dart';
import 'package:carebuddy/Features/BabySitter/View/Screens/babysitter_edit_video_screen.dart';
import 'package:carebuddy/Features/BabySitter/View/Screens/view_rates_of_babysitter_screen.dart';
import 'package:carebuddy/Features/Shared/View/Screens/video_show_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/Components/custom_btn_widgets.dart';
import '../../../../Core/Components/show_awesome_dialog_widget.dart';
import '../../../../Core/Constants/images.dart';
import '../../../../Core/Constants/translation_keys.dart';
import '../../../Shared/View/Widgets/toggle_language_column_widget.dart';

class BabysitterProfileScreen extends StatelessWidget {
  const BabysitterProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BabysitterCubit cubit = BabysitterCubit.getInstance(context);
    return BlocBuilder<BabysitterCubit,BabysitterStates>(
        buildWhen: (_,current)=> current is GetMyDataState && current.status == ApiRequestStatus.Success,
        builder: (context,state) {
          return Padding(
          padding: AppConstants.kContainerPadding,
          child: Column(
            children: [
              Stack(
                alignment: AlignmentDirectional.topStart,
                children: [
                  Center(
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.withOpacity(0.5),
                          image: DecorationImage(
                              image: cubit.myData!.multiMedia.profileImage !=
                                  null
                                  ? NetworkImage(
                                  cubit.myData!.multiMedia.profileImage!)
                                  : const AssetImage(
                                  "assets/images/account.png"),
                              fit: BoxFit.cover)),
                    ),
                  ),
                  LogOutColumnBtnWidget(onTap: () => cubit.logOut(context)),
                  const Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: ToggleLanguageColumnWidget(),
                  ),
                ],
              ),
              10.vrSpace,
              Text("${cubit.myData!.fName} ${cubit.myData!.lname}",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                      color: AppColors.kMain),
                  textAlign: TextAlign.center),
              Expanded(
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: const Color(0xffF4F4F4),
                      borderRadius: BorderRadius.circular(50)
                  ),
                  margin: const EdgeInsets.only(top: 22),
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                spacing: 14,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    padding: AppConstants.kContainerPadding,
                                    decoration: BoxDecoration(
                                      color: AppColors.kMain,
                                      borderRadius: AppConstants.kMaxRadius,
                                    ),
                                    child: Text(
                                      cubit.myData!.phone,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.kWhite,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: AppConstants.kContainerPadding,
                                    decoration: BoxDecoration(
                                      color: AppColors.kWhite,
                                      borderRadius: AppConstants.kMaxRadius,
                                    ),
                                    child: Text(
                                      "${cubit.myData!.pricePerHour}/${TranslationKeys.hour.tr(context)}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.kMain,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: AppConstants.kContainerPadding,
                                    decoration: BoxDecoration(
                                      color: AppColors.kMain,
                                      borderRadius: AppConstants.kMaxRadius,
                                    ),
                                    child: Text(
                                      cubit.myData!.nationality.tr(context),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.kWhite,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: cubit.myData!.bio?.isNotEmpty == true ,
                              child: Container(
                                margin: const EdgeInsets.only(top: 14.0),
                                padding: AppConstants.kContainerPadding,
                                decoration: BoxDecoration(
                                    color: const Color(0xffF4F4F4),
                                    borderRadius: AppConstants.kMainRadius,
                                    boxShadow: [
                                      BoxShadow(
                                          color: AppColors.kBlack.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4))
                                    ]),
                                child: Text("${cubit.myData!.bio}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.kMain,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ),
                            BlocBuilder<BabysitterCubit, BabysitterStates>(
                                buildWhen: (past, current) =>
                                current is AddNewServiceState,
                                builder: (context, state) {
                                  return Container(
                                    margin: const EdgeInsets.only(top: 14),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(TranslationKeys.services.tr(context),
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: AppColors.kMain,
                                                    fontWeight: FontWeight.w600)),
                                            GestureDetector(
                                              onTap: () => context.push(
                                                  BabysitterAddNewServiceScreen(
                                                      cubit: cubit)),
                                              child: Container(
                                                padding: const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                    color: AppColors.kMain,
                                                    shape: BoxShape.circle),
                                                child: Icon(Icons.add,
                                                    color: AppColors.kWhite),
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (cubit.myData!.services.isNotEmpty)
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            padding: const EdgeInsets.only(top: 12),
                                            child: Row(
                                              spacing: 14,
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: List.generate(
                                                  cubit.myData!.services.length,
                                                      (index) => Container(
                                                    alignment: Alignment.center,
                                                    padding: AppConstants
                                                        .kContainerPadding,
                                                    decoration: BoxDecoration(
                                                        color: AppColors.kMain,
                                                        borderRadius: AppConstants
                                                            .kMaxRadius),
                                                    child: Text(
                                                        cubit.myData!
                                                            .services[index]
                                                            .toString().tr(context),
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                            FontWeight.w500,
                                                            color: AppColors
                                                                .kWhite)),
                                                  )),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                }),
                            BlocBuilder<BabysitterCubit, BabysitterStates>(
                                buildWhen: (past, current) =>
                                current is UpdateVideoState &&
                                    current.status == ApiRequestStatus.Success,
                                builder: (context, state) {
                                  return GestureDetector(
                                    onTap: () => context.push(cubit
                                        .myData!.multiMedia.introVideo !=
                                        null
                                        ? VideoPlayerPage(
                                        url: cubit.myData!.multiMedia.introVideo!)
                                        : BabysitterEditVideoScreen(
                                        babySitter: cubit.myData!, cubit: cubit)),
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 14),
                                      child: Row(
                                        spacing: 14,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: AppColors.kWhite,
                                                borderRadius:
                                                AppConstants.kMainRadius),
                                            child: Icon(
                                                cubit.myData!.multiMedia.introVideo !=
                                                    null
                                                    ? Icons.videocam
                                                    : Icons.add),
                                          ),
                                          Expanded(
                                              child: Text(
                                                TranslationKeys.introTxtBehindOfVideo.tr(context),
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors.kMain),
                                              ))
                                        ],
                                      ),
                                    ),
                                  );
                                })
                          ],
                        ),
                      ),
                      Align(
                          alignment: AlignmentDirectional.topEnd,
                          child: IntrinsicWidth(
                            child: GestureDetector(
                              onTap: ()=> context.push(BabysitterEditProfileScreen(cubit: cubit,babySitter: cubit.myData!,)),
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
                        onTap: ()=> context.push(ViewRatesOfBabysitterScreen(cubit: cubit)),
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
