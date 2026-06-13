import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carebuddy/Core/Components/custom_btn_widgets.dart';
import 'package:carebuddy/Core/Constants/constants.dart';
import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Theme/colors.dart';
import 'package:carebuddy/Features/Parent/Controller/Layout/parents_cubit.dart';
import 'package:carebuddy/Features/Parent/Controller/Layout/parents_states.dart';
import 'package:carebuddy/Features/Parent/View/Screens/babysitter_details_as_parent_page.dart';
import 'package:carebuddy/Features/Shared/Models/babysitter_request_model.dart';
import 'package:carebuddy/Features/Shared/View/Screens/view_rating_of_babysitter_request_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../../Core/Components/show_awesome_dialog_widget.dart';
import '../../../../../Core/Constants/translation_keys.dart';
import '../../Screens/rate_babysitter_screen.dart';

class BookWithInteractBtnsAsParentCardWidget extends StatelessWidget {
  final BabysitterRequestModel request;
  final ParentsCubit cubit;
  const BookWithInteractBtnsAsParentCardWidget({super.key, required this.request, required this.cubit});

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
              GestureDetector(
                onTap: ()=> context.push(BabysitterDetailsAsParentPage(babysitter: request.babySitter, cubit: cubit)),
                child: Text("${TranslationKeys.babysitterName.tr(context)} : ${request.babySitter.fName} ${request.babySitter.lname}",style: TextStyle(fontWeight: FontWeight.w500,color: AppColors.kWhite,fontSize: 16),maxLines: 1,overflow: TextOverflow.ellipsis),
              ),
              Text("${TranslationKeys.child.tr(context)} : ${request.childSelected.name}",style: TextStyle(fontWeight: FontWeight.w400,color: AppColors.kWhite,fontSize: 16)),
              if( request.notes != null )
                Text(request.notes!,style: TextStyle(fontWeight: FontWeight.w400,color: AppColors.kWhite,fontSize: 16)),
              Text("${DateFormat("dd-MM-yyyy").format(request.startAt)}. ${request.babySitter.pricePerHour}/${TranslationKeys.hour.tr(context)}",style: TextStyle(fontWeight: FontWeight.w400,color: AppColors.kWhite,fontSize: 16)),
              Text("${TranslationKeys.start.tr(context)} : ${DateFormat("HH:mm").format(request.startAt)}. ${TranslationKeys.end.tr(context)} : ${DateFormat("HH:mm").format(request.endAt)}",style: TextStyle(fontWeight: FontWeight.w400,color: AppColors.kWhite,fontSize: 16)),
              if( request.endAt.isAfter(DateTime.now()) && request.status == BabysitterRequestStatus.Paid.name )
                Text(
                "${TranslationKeys.status.tr(context)} : ${request.status}",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: AppColors.kWhite,
                  fontSize: 16,
                ),
              ),
              if( request.status == BabysitterRequestStatus.Paid.name || (request.endAt.isBefore(DateTime.now()) && request.status == BabysitterRequestStatus.Accepted.name) )
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 10,
                  children: [
                    BtnWidget(
                      title: request.status == BabysitterRequestStatus.Accepted.name ? TranslationKeys.payNow.tr(context) : request.status == BabysitterRequestStatus.Paid.name && request.rateOfParent != null ? TranslationKeys.viewMyRate.tr(context) : TranslationKeys.rateNow.tr(context),
                      onTap: (){
                        if( request.status == BabysitterRequestStatus.Accepted.name )
                        {
                          cubit.payNow(context: context, request: request);
                        }
                        else if ( request.status == BabysitterRequestStatus.Paid.name )
                        {
                          context.push(RateBabysitterScreen(cubit: cubit,request: request));
                        }
                      },
                      txtColor: AppColors.kWhite,
                      showLoading: state is ResponseRequestAsParentState && state.response == BabysitterRequestStatus.Paid && state.request == request && state.status == ApiRequestStatus.Loading,
                      backgroundColor: request.status == BabysitterRequestStatus.Accepted.name ? const Color(0xff79D3A7) : const Color(0xffFFD14C),
                    ),
                    if( request.status == BabysitterRequestStatus.Accepted.name && !request.endAt.isBefore(DateTime.now()) )
                      IntrinsicWidth(
                        child: BtnWidget(
                          onTap: (){
                            showAwesomeDialogWidget(title: TranslationKeys.cancelRequest.tr(context), desc: (request.startAt.difference(DateTime.now()).inHours).abs() > 6 ? TranslationKeys.reallyWantCancelRequest.tr(context) : TranslationKeys.reallyWantCancelRequestWithFee.tr(context),
                              context: context,
                              okBtnText: (request.startAt.difference(DateTime.now()).inHours).abs() > 6 ? TranslationKeys.continueTxt.tr(context) : TranslationKeys.pay.tr(context),
                              type: DialogType.warning,
                              okBtnMethod: () {
                                if( (request.startAt.difference(DateTime.now()).inHours).abs() > 6 )
                                {
                                  cubit.responseRequest(comment: null, context: context, request: request, response: BabysitterRequestStatus.Canceled);
                                }
                                else
                                {
                                  cubit.payNow(context: context, request: request,calledAfterCancelRequest: true);
                                }
                              },
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
                  ],
                )
            ],
          ),
        );
      }
    );
  }
}
