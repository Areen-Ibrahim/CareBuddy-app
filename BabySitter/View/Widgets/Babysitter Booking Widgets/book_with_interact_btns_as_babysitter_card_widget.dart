import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carebuddy/Core/Components/custom_btn_widgets.dart';
import 'package:carebuddy/Core/Components/show_awesome_dialog_widget.dart';
import 'package:carebuddy/Core/Constants/constants.dart';
import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Theme/colors.dart';
import 'package:carebuddy/Features/BabySitter/Controller/Layout/babysitter_cubit.dart';
import 'package:carebuddy/Features/BabySitter/Controller/Layout/babysitter_state.dart';
import 'package:carebuddy/Features/Parent/View/Screens/view_parent_details_screen.dart';
import 'package:carebuddy/Features/Shared/Models/babysitter_request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../Core/Constants/translation_keys.dart';

class BookWithInteractBtnsAsBabysitterCardWidget extends StatelessWidget {
  final BabysitterRequestModel request;
  final BabysitterCubit cubit;
  const BookWithInteractBtnsAsBabysitterCardWidget({super.key, required this.request, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppConstants.kContainerPadding,
      decoration: BoxDecoration(
          color: AppColors.kMain,
          borderRadius: AppConstants.kMainRadius
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 2,
        children: [
          GestureDetector(
            onTap: ()=> context.push(ViewParentDetailsScreen(id: request.parent.id, requestStatus: request.status)),
            child: Text("${TranslationKeys.parentName.tr(context)} : ${request.parent.fName} ${request.parent.lname}",style: TextStyle(fontWeight: FontWeight.w500,color: AppColors.kWhite,fontSize: 16),maxLines: 1,overflow: TextOverflow.ellipsis),
          ),
          Text("${TranslationKeys.child.tr(context)} : ${request.childSelected.name}",style: TextStyle(fontWeight: FontWeight.w400,color: AppColors.kWhite,fontSize: 16)),
          if( request.notes != null )
            Text(request.notes!,style: TextStyle(fontWeight: FontWeight.w400,color: AppColors.kWhite,fontSize: 16)),
          Text("${DateFormat("dd-MM-yyyy").format(request.startAt)}. ${request.babySitter.pricePerHour}/${TranslationKeys.hour.tr(context)}",style: TextStyle(fontWeight: FontWeight.w400,color: AppColors.kWhite,fontSize: 16)),
          Text("${TranslationKeys.start.tr(context)} : ${DateFormat("HH:mm").format(request.startAt)}. ${TranslationKeys.end.tr(context)} : ${DateFormat("HH:mm").format(request.endAt)}",style: TextStyle(fontWeight: FontWeight.w400,color: AppColors.kWhite,fontSize: 16)),
          BlocBuilder<BabysitterCubit,BabysitterStates>(
            buildWhen: (past,current)=> current is ResponseRequestAsBabysitterState && current.request == request,
            builder: (context,state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: 14,
                children: [
                  BtnWidget(
                      onTap: ()=> showAwesomeDialogWidget(title: TranslationKeys.accept.tr(context), desc: TranslationKeys.acceptRequestConfirmation.tr(context), context: context, type: DialogType.warning,okBtnMethod: ()=> cubit.responseRequest(context: context,status: BabysitterRequestStatus.Accepted,request: request)),
                      title: TranslationKeys.accept.tr(context),
                      showLoading: state is ResponseRequestAsBabysitterState && state.response == BabysitterRequestStatus.Accepted && state.status == ApiRequestStatus.Loading && state.request == request,
                      backgroundColor: AppColors.kGreen
                  ),
                  BtnWidget(
                    onTap: ()=> showAwesomeDialogWidget(title: TranslationKeys.reject.tr(context), desc: TranslationKeys.rejectRequestConfirmation.tr(context), context: context, type: DialogType.warning,okBtnMethod: ()=> cubit.responseRequest(context: context,status: BabysitterRequestStatus.Rejected,request: request)),
                    title: TranslationKeys.reject.tr(context),
                    showLoading: state is ResponseRequestAsBabysitterState && state.response == BabysitterRequestStatus.Rejected && state.status == ApiRequestStatus.Loading && state.request == request,
                    backgroundColor: AppColors.kRed,
                  ),
                ],
              );
            }
          )
        ],
      ),
    );
  }
}
