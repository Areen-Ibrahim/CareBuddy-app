import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carebuddy/Core/Components/custom_btn_widgets.dart';
import 'package:carebuddy/Core/Components/show_awesome_dialog_widget.dart';
import 'package:carebuddy/Core/Constants/constants.dart';
import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Theme/colors.dart';
import 'package:carebuddy/Features/BabySitter/Controller/Layout/babysitter_cubit.dart';
import 'package:carebuddy/Features/BabySitter/Controller/Layout/babysitter_state.dart';
import 'package:carebuddy/Features/BabySitter/View/Screens/rate_parent_request_screen.dart';
import 'package:carebuddy/Features/Shared/Models/babysitter_request_model.dart';
import 'package:carebuddy/Features/Shared/View/Screens/view_rating_of_babysitter_request_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../Core/Constants/translation_keys.dart';
import '../../../../Parent/View/Screens/view_parent_details_screen.dart';

class BookedContainerOfBabysitterWidget extends StatelessWidget {
  final BabysitterRequestModel request;
  final BabysitterCubit cubit;
  const BookedContainerOfBabysitterWidget({
    super.key,
    required this.request,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BabysitterCubit, BabysitterStates>(
      builder: (context,state) {
        return Container(
          padding: AppConstants.kContainerPadding,
          decoration: BoxDecoration(
              color: AppColors.kMain, borderRadius: AppConstants.kMainRadius),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2,
            children: [
              GestureDetector(
                onTap: ()=> context.push(ViewParentDetailsScreen(id: request.parent.id, requestStatus: request.status)),
                child: Text(
                  "${TranslationKeys.parentName.tr(context)} : ${request.parent.fName} ${request.parent.lname}",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.kWhite,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                "${TranslationKeys.child.tr(context)} : ${request.childSelected.name}",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: AppColors.kWhite,
                  fontSize: 16,
                ),
              ),
              if (request.notes != null)
                Text(
                  request.notes!,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: AppColors.kWhite,
                    fontSize: 16,
                  ),
                ),
              Text(
                "${DateFormat("dd-MM-yyyy").format(request.startAt)}. ${request.babySitter.pricePerHour}/${TranslationKeys.hour.tr(context)}",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: AppColors.kWhite,
                  fontSize: 16,
                ),
              ),
              Text(
                "${TranslationKeys.start.tr(context)} : ${DateFormat("HH:mm").format(request.startAt)}. ${TranslationKeys.end.tr(context)} : ${DateFormat("HH:mm").format(request.endAt)}",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: AppColors.kWhite,
                  fontSize: 16,
                ),
              ),
              if (request.rateOfParent == null)
                Text(
                  "${TranslationKeys.status.tr(context)} : ${request.status}",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: AppColors.kWhite,
                    fontSize: 16,
                  ),
                ),
              if ( request.rateOfParent != null || request.rateOfBabysitter == null || request.status == BabysitterRequestStatus.Accepted.name )
                Row(
                  spacing: 12,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if( DateTime.now().isAfter(request.startAt) )
                      BtnWidget(
                        title: request.rateOfBabysitter != null ? TranslationKeys.viewMyRate.tr(context) : TranslationKeys.rateNow.tr(context),
                        onTap: ()=> context.push(RateParentRequestScreen(cubit: cubit, request: request)),
                        txtColor: AppColors.kWhite,
                        backgroundColor: const Color(0xffFF9B58)
                      ),
                    if( request.status == BabysitterRequestStatus.Accepted.name || request.rateOfParent != null )
                      BtnWidget(
                          title: request.rateOfParent != null ? TranslationKeys.viewRate.tr(context) : TranslationKeys.cancel.tr(context),
                          onTap: () {
                            if (request.rateOfParent != null) {
                              context.push(
                                RateOfRequestViewScreen(
                                  commentModel: request.rateOfParent!,
                                ),
                              );
                            } else {
                              showAwesomeDialogWidget(title: TranslationKeys.cancelRequest.tr(context), desc: (request.startAt.difference(DateTime.now()).inHours).abs() > 6 ? TranslationKeys.reallyWantCancelRequest.tr(context) : TranslationKeys.reallyCancelRequestWithAffect.tr(context),
                                context: context,
                                type: DialogType.warning,
                                okBtnMethod: () {
                                  cubit.responseRequest(updateCanceledRequestsOfBabysitter: (request.startAt.difference(DateTime.now()).inHours).abs() > 6 ? null : true, context: context, request: request, status: BabysitterRequestStatus.Canceled);
                                },
                              );
                            }
                          },
                          txtColor: AppColors.kWhite,
                          showLoading: state is ResponseRequestAsBabysitterState &&
                              state.response == BabysitterRequestStatus.Canceled &&
                              state.status == ApiRequestStatus.Loading &&
                              state.request == request,
                          backgroundColor: request.rateOfParent != null
                              ? const Color(0xffFF9B58)
                              : AppColors.kRed,
                        )
                  ],
                )
            ],
          ),
        );
      }
    );
  }
}
