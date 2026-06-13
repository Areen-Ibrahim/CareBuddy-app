import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carebuddy/Core/Components/custom_btn_widgets.dart';
import 'package:carebuddy/Core/Components/failure_widget.dart';
import 'package:carebuddy/Core/Components/loading_widget.dart';
import 'package:carebuddy/Core/Components/log_out_column_btn_widget.dart';
import 'package:carebuddy/Core/Components/show_awesome_dialog_widget.dart';
import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Constants/strings.dart';
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
import 'package:googleapis/admob/v1.dart';
import '../../../../Core/Constants/constants.dart';
import '../../../../Core/Constants/images.dart';
import '../../../../Core/Constants/translation_keys.dart';
import '../../../../Core/Services/cache_manager_service.dart';
import '../../../../Core/Theme/colors.dart';
import '../../../Shared/View/Widgets/user_flag_column_widget.dart';

class ViewParentDetailsScreen extends StatefulWidget {
  final String id;
  final String requestStatus;
  const ViewParentDetailsScreen({super.key, required this.id, required this.requestStatus});

  @override
  State<ViewParentDetailsScreen> createState() => _ViewParentDetailsScreenState();
}

class _ViewParentDetailsScreenState extends State<ViewParentDetailsScreen> {
  @override
  void initState() {
    ParentsCubit.getInstance(context).getSpecificParentDetails(id: widget.id);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final ParentsCubit cubit = ParentsCubit.getInstance(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Parent Details"),
      ),
      body: BlocBuilder<ParentsCubit,ParentsStates>(
        builder: (context,state) {
          if( state is GetSpecificParentDetailsState && state.status == ApiRequestStatus.Success && state.parent != null )
            {
              return Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage(AppImages.kBackgroundImage),fit: BoxFit.cover)
                ),
                child: Padding(
                  padding: AppConstants.kContainerPadding.copyWith(top: context.topPaddingOfScreen + 22),
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          height: 100,
                          width: 100,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.withOpacity(0.5),
                              image: DecorationImage(fit: BoxFit.cover,image: NetworkImage(state.parent!.profileImage))
                          ),
                        ),
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
                                    Align(
                                      alignment: AlignmentDirectional.topStart,
                                      child: UserFlagColumnWidget(canceledOrdersNum: state.parent!.canceledRequests),
                                    ),
                                    Text("${state.parent!.fName} ${state.parent!.lname}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: AppColors.kMain),textAlign: TextAlign.center),
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
                                            spacing: index == 1 ? 10 : 0,
                                            children: [
                                              if( index == 1 )
                                                Icon(state.parent!.gender == GenderStatus.Male.name ? Icons.male : Icons.female,color: AppColors.kWhite),
                                              Text(index == 0 ? state.parent!.phone : MyLocalizations.getValueFromLanguage(state.parent!.gender.toLowerCase(), CacheManagerService.readCurrentLanguage()),style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: AppColors.kWhite)),
                                            ],
                                          ),
                                        ),
                                      )),
                                    ),
                                    Visibility(
                                      visible: widget.requestStatus == BabysitterRequestStatus.Accepted.name || widget.requestStatus == BabysitterRequestStatus.Paid.name,
                                      child: Container(
                                        margin: EdgeInsets.only(top: 10),
                                        child: GestureDetector(
                                          onTap: ()=> UrlLauncherServices.openUrl(Uri.parse(state.parent!.locationUrl)),
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
                                                  child: Text(state.parent!.locationUrl,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: AppColors.kBlack),maxLines: 1,overflow: TextOverflow.ellipsis),
                                                ),
                                                Icon(Icons.location_on,color: AppColors.kMain)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 10,bottom: 10),
                                      child: Text(TranslationKeys.kidsCards.tr(context),style: TextStyle(fontSize: 18,color: AppColors.kMain,fontWeight: FontWeight.w600)),
                                    ),
                                    Builder(
                                      builder: (context){
                                        if( state.parent!.kids.isNotEmpty )
                                        {
                                          return SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            padding: EdgeInsets.zero,
                                            child: Row(
                                              spacing: 14,
                                              children: List.generate(state.parent!.kids.length, (index)=> KidParentProfileCardWidget(onlyView: true,cubit: cubit,kid: state.parent!.kids.reversed.toList()[index])),
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
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          else if( state is GetSpecificParentDetailsState && state.status == ApiRequestStatus.Failure )
            {
              return FailureWidget(onTap: ()=> cubit.getSpecificParentDetails(id: widget.id), message: state.errorMessage ?? TranslationKeys.somethingWentWrong.tr(context));
            }
          else
            {
              return LoadingWidget();
            }
        }
      ),
    );
  }
}
