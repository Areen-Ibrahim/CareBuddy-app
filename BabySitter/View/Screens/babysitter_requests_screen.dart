import 'package:carebuddy/Core/Components/app_scaffold_widget.dart';
import 'package:carebuddy/Core/Components/empty_widget.dart';
import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Theme/colors.dart';
import 'package:carebuddy/Features/BabySitter/Controller/Layout/babysitter_cubit.dart';
import 'package:carebuddy/Features/BabySitter/Controller/Layout/babysitter_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/Components/data_state_builder_widget.dart';
import '../../../../Core/Constants/constants.dart';
import '../../../../Core/Constants/translation_keys.dart';
import '../Widgets/Babysitter Booking Widgets/book_with_interact_btns_as_babysitter_card_widget.dart';
import '../Widgets/Babysitter Booking Widgets/request_without_interact_btns_as_babysitter_card_widget.dart';

class BabysitterBookingScreen extends StatefulWidget {
  const BabysitterBookingScreen({super.key});

  @override
  State<BabysitterBookingScreen> createState() => _BabysitterBookingScreenState();
}

class _BabysitterBookingScreenState extends State<BabysitterBookingScreen> {
  @override
  void initState() {
    BabysitterCubit.getInstance(context).getRequests();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final BabysitterCubit cubit = BabysitterCubit.getInstance(context);
    return AppScaffoldWidget(
      appBar: AppBar(
          title: Text(TranslationKeys.requests.tr(context)),
      ),
      showBackgroundImage: false,
      body: Padding(
        padding: AppConstants.kScaffoldPadding,
        child: BlocBuilder<BabysitterCubit,BabysitterStates>(
          builder: (context,state){
            return DataStateBuilderWidget(
                isLoading: state is GetBabysitterBookingState && state.status == ApiRequestStatus.Loading,
                emptyTxt: TranslationKeys.noRequestsCreatedYet.tr(context),
                errorTxt: state is GetBabysitterBookingState && state.status == ApiRequestStatus.Failure ? state.errorMessage : null,
                failureTap: ()=> cubit.getRequests(),
                isError: state is GetBabysitterBookingState && state.status == ApiRequestStatus.Failure,
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
                            if( cubit.requests.where((request)=> request.status == BabysitterRequestStatus.Pending.name ).toList().isNotEmpty )
                            {
                              return ListView.separated(
                                padding: EdgeInsets.zero.copyWith(bottom: 22),
                                itemCount: cubit.requests.where((request)=> request.status == BabysitterRequestStatus.Pending.name).toList().length,
                                separatorBuilder: AppConstants.kSeparatorBuilder(),
                                itemBuilder: (context,index)=> BookWithInteractBtnsAsBabysitterCardWidget(cubit: cubit,request: cubit.requests.where((request)=> request.status == BabysitterRequestStatus.Pending.name).toList()[index]),
                              );
                            }
                            else
                            {
                              return EmptyWidget(txt: TranslationKeys.noRequestsCreatedYet.tr(context));
                            }
                          }
                          else
                          {
                            if( cubit.requests.where((request)=> request.status == BabysitterRequestStatus.Accepted.name || request.status == BabysitterRequestStatus.Paid.name ).toList().isNotEmpty )
                            {
                              return ListView.separated(
                                padding: EdgeInsets.zero.copyWith(bottom: 22),
                                itemCount: cubit.requests.where((request)=> request.status == BabysitterRequestStatus.Accepted.name || request.status == BabysitterRequestStatus.Paid.name ).toList().length,
                                separatorBuilder: AppConstants.kSeparatorBuilder(),
                                itemBuilder: (context,index)=> BookedContainerOfBabysitterWidget(cubit: cubit,request: cubit.requests.where((request)=> request.status == BabysitterRequestStatus.Accepted.name || request.status == BabysitterRequestStatus.Paid.name).toList()[index]),
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
