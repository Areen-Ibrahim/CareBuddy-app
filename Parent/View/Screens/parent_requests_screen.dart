import 'package:carebuddy/Core/Components/app_scaffold_widget.dart';
import 'package:carebuddy/Core/Components/data_state_builder_widget.dart';
import 'package:carebuddy/Core/Components/empty_widget.dart';
import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Theme/colors.dart';
import 'package:carebuddy/Features/Parent/View/Widgets/Parent%20Requests%20Widgets/book_with_interact_btns_as_parent_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/Constants/constants.dart';
import '../../../../Core/Constants/translation_keys.dart';
import '../../Controller/Layout/parents_cubit.dart';
import '../../Controller/Layout/parents_states.dart';
import '../Widgets/Parent Requests Widgets/request_without_interact_btns_as_parent_card_widget.dart';

class ParentRequestsScreen extends StatefulWidget {
  const ParentRequestsScreen({super.key});

  @override
  State<ParentRequestsScreen> createState() => _ParentRequestsScreenState();
}

class _ParentRequestsScreenState extends State<ParentRequestsScreen> {
  @override
  void initState() {
    ParentsCubit.getInstance(context).getRequests();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final ParentsCubit cubit = ParentsCubit.getInstance(context);
    return AppScaffoldWidget(
      showBackgroundImage: false,
      appBar: AppBar(title: Text(TranslationKeys.requests.tr(context))),
      body: Padding(
        padding: AppConstants.kScaffoldPadding.copyWith(top: 0),
        child: BlocBuilder<ParentsCubit,ParentsStates>(
          builder: (context,state){
            return DataStateBuilderWidget(
                failureTap: ()=> cubit.getRequests(),
                isLoading: state is GetRequestsState && state.status == ApiRequestStatus.Loading,
                isError: state is GetRequestsState && state.status == ApiRequestStatus.Failure,
                errorTxt: state is GetRequestsState && state.status == ApiRequestStatus.Failure ? state.errorMessage : null,
                emptyTxt: TranslationKeys.noRequestsCreatedYet.tr(context),
                isDataFound: cubit.requests.isNotEmpty,
                widget: Column(
                  spacing: 14,
                  children: [
                    Row(
                      spacing: 14,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: ()=> cubit.changeStatusOfShownRequests(showRequestsNotBookingUpdated : true),
                            child: Container(
                              alignment: AlignmentDirectional.center,
                              padding: AppConstants.kContainerPadding,
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: cubit.showRequestsNotBooking ? AppColors.kMain : Colors.transparent))
                              ),
                              child: Text(TranslationKeys.requests.tr(context),style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: cubit.showRequestsNotBooking ? AppColors.kMain : AppColors.kBlack)),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: ()=> cubit.changeStatusOfShownRequests(showRequestsNotBookingUpdated : false),
                            child: Container(
                              alignment: AlignmentDirectional.center,
                              padding: AppConstants.kContainerPadding,
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: !cubit.showRequestsNotBooking ? AppColors.kMain : Colors.transparent))
                              ),
                              child: Text(TranslationKeys.booking.tr(context),style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: !cubit.showRequestsNotBooking ? AppColors.kMain : AppColors.kBlack)),
                            ),
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: Builder(
                        builder: (context){
                          if( cubit.showRequestsNotBooking )
                          {
                            if( cubit.requests.where((request)=> request.status == BabysitterRequestStatus.Pending.name).toList().isNotEmpty )
                            {
                              return ListView.separated(
                                padding: EdgeInsets.zero.copyWith(bottom: 22),
                                itemCount: cubit.requests.where((request)=> request.status == BabysitterRequestStatus.Pending.name).toList().length,
                                separatorBuilder: AppConstants.kSeparatorBuilder(),
                                itemBuilder: (context,index)=> RequestWithoutInteractBtnsAsParentCardWidget(cubit:cubit,request: cubit.requests.where((request)=> request.status == BabysitterRequestStatus.Pending.name).toList()[index]),
                              );
                            }
                            else
                            {
                              return EmptyWidget(txt: TranslationKeys.noRequestsCreatedYet.tr(context));
                            }
                          }
                          else
                          {
                            if( cubit.requests.where((request)=> request.status == BabysitterRequestStatus.Accepted.name  || request.status == BabysitterRequestStatus.Paid.name ).toList().isNotEmpty )
                            {
                              return ListView.separated(
                                padding: EdgeInsets.zero.copyWith(bottom: 22),
                                itemCount: cubit.requests.where((request)=> request.status == BabysitterRequestStatus.Accepted.name  || request.status == BabysitterRequestStatus.Paid.name ).toList().length,
                                separatorBuilder: AppConstants.kSeparatorBuilder(),
                                itemBuilder: (context,index)=> BookWithInteractBtnsAsParentCardWidget(cubit: cubit,request: cubit.requests.where((request)=> request.status == BabysitterRequestStatus.Accepted.name  || request.status == BabysitterRequestStatus.Paid.name).toList()[index]),
                              );
                            }
                            else
                            {
                              return EmptyWidget(txt: TranslationKeys.noRequestsBookedYet.tr(context));
                            }
                          }
                        },
                      ),
                    )
                  ],
                )
            );
          },
        ),
      ),
    );
  }
}
