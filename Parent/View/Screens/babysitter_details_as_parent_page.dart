import 'package:carebuddy/Core/Components/app_scaffold_widget.dart';
import 'package:carebuddy/Core/Components/failure_widget.dart';
import 'package:carebuddy/Core/Components/loading_widget.dart';
import 'package:carebuddy/Core/Constants/constants.dart';
import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Theme/colors.dart';
import 'package:carebuddy/Features/BabySitter/Models/baby_sitter.dart';
import 'package:carebuddy/Features/Parent/Controller/Layout/parents_cubit.dart';
import 'package:carebuddy/Features/Parent/View/Screens/view_rates_of_specific_babysitter_as_parent_screen.dart';
import 'package:carebuddy/Features/Shared/View/Widgets/user_flag_column_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/Components/custom_btn_widgets.dart';
import '../../../../Core/Constants/images.dart';
import '../../../../Core/Constants/translation_keys.dart';
import '../../../Shared/View/Screens/video_show_page.dart';
import '../../Controller/Layout/parents_states.dart';

class BabysitterDetailsAsParentPage extends StatefulWidget {
  final Babysitter babysitter;
  final ParentsCubit cubit;
  const BabysitterDetailsAsParentPage({super.key, required this.babysitter, required this.cubit});

  @override
  State<BabysitterDetailsAsParentPage> createState() => _BabysitterDetailsAsParentPageState();
}

class _BabysitterDetailsAsParentPageState extends State<BabysitterDetailsAsParentPage> {
  @override
  void initState() {
    widget.cubit.getBabysitterDetails(widget.babysitter.id);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appBar: AppBar(title: Text(TranslationKeys.babysitterDetails.tr(context)),),
      body: BlocBuilder<ParentsCubit,ParentsStates>(
        buildWhen: (past,current)=> current is GetDetailsOfSpecificBabysitterState,
        builder: (context,state){
          if( state is GetDetailsOfSpecificBabysitterState && state.status == ApiRequestStatus.Success && state.babysitter != null )
            {
              return Padding(
                padding: AppConstants.kScaffoldPadding,
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.withOpacity(0.5),
                            image: DecorationImage(
                                image: state.babysitter!.multiMedia.profileImage !=
                                    null
                                    ? NetworkImage(
                                    state.babysitter!.multiMedia.profileImage!)
                                    : const AssetImage(
                                    "assets/images/account.png"),
                                fit: BoxFit.cover)),
                      ),
                    ),
                    10.vrSpace,
                    Text("${state.babysitter!.fName} ${state.babysitter!.lname}",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        padding: AppConstants.kContainerPadding,
                                        decoration: BoxDecoration(
                                          color: AppColors.kMain,
                                          borderRadius: AppConstants.kMaxRadius,
                                        ),
                                        child: Text(
                                          state.babysitter!.phone,
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
                                          "${state.babysitter!.pricePerHour}/${TranslationKeys.hour.tr(context)}",
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
                                          state.babysitter!.nationality,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.kWhite,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (state.babysitter!.bio != null && state.babysitter!.bio!.isNotEmpty)
                                    Container(
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
                                      child: Text(state.babysitter!.bio!,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: AppColors.kMain,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  if( state.babysitter!.multiMedia.introVideo != null )
                                    GestureDetector(
                                      onTap: () => context.push(VideoPlayerPage(url: state.babysitter!.multiMedia.introVideo!)),
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
                                              child: const Icon(Icons.videocam),
                                            ),
                                            Expanded(
                                                child: Text(
                                                  TranslationKeys.introTxtBehindOfVideo.tr(context),
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w400,
                                                      color: AppColors.kMain),
                                                )
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(vertical: 10),
                                    child: Text(TranslationKeys.services.tr(context),
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: AppColors.kMain,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  Builder(
                                    builder: (context){
                                      if( state.babysitter!.services.isNotEmpty )
                                        {
                                          return SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            padding: EdgeInsets.zero,
                                            child: Row(
                                              spacing: 14,
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: List.generate(
                                                  state.babysitter!.services.length,
                                                      (index) => Container(
                                                    alignment: Alignment.center,
                                                    padding: AppConstants
                                                        .kContainerPadding,
                                                    decoration: BoxDecoration(
                                                        color: AppColors.kMain,
                                                        borderRadius: AppConstants
                                                            .kMaxRadius),
                                                    child: Text(
                                                        state.babysitter!
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
                                          );
                                        }
                                      else
                                        {
                                          return Center(child: Text(TranslationKeys.notFoundData.tr(context)));
                                        }
                                    },
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      spacing: 14,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: AlignmentDirectional.topStart,
                            child: UserFlagColumnWidget(canceledOrdersNum: widget.babysitter.canceledRequests),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 14),
                          alignment: AlignmentDirectional.topStart,
                          child: BtnWidget(
                            onTap: ()=> context.push(ViewRatesOfSpecificBabysitterAsParentScreen(cubit: widget.cubit, babysitter: state.babysitter!)),
                            title: TranslationKeys.viewRates.tr(context),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            }
          else
            {
              if( state is GetDetailsOfSpecificBabysitterState && state.status == ApiRequestStatus.Failure )
                {
                  return FailureWidget(onTap: ()=> widget.cubit.getBabysitterDetails(widget.babysitter.id), message: state.errorMessage!);
                }
              else
                {
                  return const LoadingWidget();
                }
            }
        },
      ),
    );
  }
}
