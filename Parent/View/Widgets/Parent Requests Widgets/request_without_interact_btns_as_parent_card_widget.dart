import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carebuddy/Core/Components/custom_btn_widgets.dart';
import 'package:carebuddy/Core/Constants/constants.dart';
import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Theme/colors.dart';
import 'package:carebuddy/Features/Parent/Controller/Layout/parents_cubit.dart';
import 'package:carebuddy/Features/Parent/Controller/Layout/parents_states.dart';
import 'package:carebuddy/Features/Shared/Models/babysitter_request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../../Core/Components/show_awesome_dialog_widget.dart';
import '../../../../../Core/Constants/translation_keys.dart';

class RequestWithoutInteractBtnsAsParentCardWidget extends StatelessWidget {
  final BabysitterRequestModel request;
  final ParentsCubit cubit;
  const RequestWithoutInteractBtnsAsParentCardWidget({super.key, required this.request, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParentsCubit,ParentsStates>(
      builder: (context,state) {
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
              Text("${TranslationKeys.babysitterName.tr(context)} : ${request.babySitter.fName} ${request.babySitter.lname}",style: TextStyle(fontWeight: FontWeight.w500,color: AppColors.kWhite,fontSize: 16),maxLines: 1,overflow: TextOverflow.ellipsis),
              Text("${TranslationKeys.child.tr(context)} : ${request.childSelected.name}",style: TextStyle(fontWeight: FontWeight.w400,color: AppColors.kWhite,fontSize: 16)),
              if( request.notes != null )
                Text(request.notes!,style: TextStyle(fontWeight: FontWeight.w400,color: AppColors.kWhite,fontSize: 16)),
              Text("${DateFormat("dd-MM-yyyy").format(request.startAt)}. ${request.babySitter.pricePerHour}/${TranslationKeys.hour.tr(context)}",style: TextStyle(fontWeight: FontWeight.w400,color: AppColors.kWhite,fontSize: 16)),
              Text("${TranslationKeys.start.tr(context)} : ${DateFormat("HH:mm").format(request.startAt)}. ${TranslationKeys.end.tr(context)} : ${DateFormat("HH:mm").format(request.endAt)}",style: TextStyle(fontWeight: FontWeight.w400,color: AppColors.kWhite,fontSize: 16)),
              Text(
                "${TranslationKeys.status.tr(context)} : ${request.status}",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: AppColors.kWhite,
                  fontSize: 16,
                ),
              ),
              if( request.status == BabysitterRequestStatus.Pending.name )
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: IntrinsicWidth(
                    child: BtnWidget(
                      onTap: (){
                        showAwesomeDialogWidget(title: TranslationKeys.cancelRequest.tr(context), desc: TranslationKeys.reallyWantCancelRequest.tr(context),
                          context: context,
                          okBtnText: TranslationKeys.continueTxt.tr(context),
                          type: DialogType.warning,
                          okBtnMethod: ()=> cubit.responseRequest(comment: null, context: context, request: request, response: BabysitterRequestStatus.Canceled),
                        );
                      },
                      showLoading: state is ResponseRequestAsParentState &&
                          state.response == BabysitterRequestStatus.Canceled &&
                          state.status == ApiRequestStatus.Loading &&
                          state.request == request,
                      backgroundColor: AppColors.kRed,
                      title: TranslationKeys.cancel.tr(context),
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
