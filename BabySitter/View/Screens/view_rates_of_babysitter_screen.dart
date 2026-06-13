import 'package:carebuddy/Core/Components/app_scaffold_widget.dart';
import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Theme/colors.dart';
import 'package:carebuddy/Features/BabySitter/Controller/Layout/babysitter_cubit.dart';
import 'package:carebuddy/Features/BabySitter/Controller/Layout/babysitter_state.dart';
import 'package:carebuddy/Features/Shared/View/Widgets/parent_rate_container_widget_on_babysitter_request_container_widget.dart';
import 'package:carebuddy/Features/Shared/View/Widgets/rate_row_include_num_and_percentage_and_slider_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../Core/Components/data_state_builder_widget.dart';
import '../../../../Core/Constants/constants.dart';
import '../../../../Core/Constants/images.dart';
import '../../../../Core/Constants/translation_keys.dart';

class ViewRatesOfBabysitterScreen extends StatefulWidget {
  final BabysitterCubit cubit;
  const ViewRatesOfBabysitterScreen({super.key, required this.cubit});

  @override
  State<ViewRatesOfBabysitterScreen> createState() => _ViewRatesOfBabysitterScreenState();
}

class _ViewRatesOfBabysitterScreenState extends State<ViewRatesOfBabysitterScreen> {
  @override
  void initState() {
    if( widget.cubit.requests.isEmpty )
      {
        widget.cubit.getRequests();
      }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appBar: AppBar(title: Text(TranslationKeys.reviews.tr(context)),),
      body: Padding(
        padding: AppConstants.kScaffoldPadding,
        child: BlocBuilder<BabysitterCubit,BabysitterStates>(
          buildWhen: (past,current)=> current is GetBabysitterBookingState,
          builder: (context,state) {
            return DataStateBuilderWidget(
                isLoading: state is GetBabysitterBookingState && state.status == ApiRequestStatus.Loading,
                isError: state is GetBabysitterBookingState && state.status == ApiRequestStatus.Failure,
                emptyTxt: TranslationKeys.noRatesAddedYet.tr(context),
                failureTap: ()=> widget.cubit.getRequests(),
                errorTxt: state is GetBabysitterBookingState && state.status == ApiRequestStatus.Failure ? state.errorMessage : null,
                isDataFound: widget.cubit.requestsWithReviews.isNotEmpty,
                widget: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 10,
                      children: [
                        Row(
                          spacing: 2,
                          children: List.generate(widget.cubit.averageRating, (index)=> SvgPicture.asset(AppImages.kStarIcon,height: 16,width: 16,color: AppColors.kYellow)),
                        ),
                        Text("${widget.cubit.averageRating} ${TranslationKeys.outOf5.tr(context)}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: AppColors.kBlack),textAlign: TextAlign.center,),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      child: Text("${widget.cubit.requestsWithReviews.length} ${TranslationKeys.rating.tr(context)}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: AppColors.kBlack.withOpacity(0.38),),textAlign: TextAlign.center,),
                    ),
                    Column(
                        spacing: 6,
                        children: List.generate(5, (index)=> RateRowIncludeNumAndPercentageAndSliderWidget(starNum: 5-index, requestsWithReviews: widget.cubit.requestsWithReviews))
                    ),
                    ListView.separated(
                      padding: const EdgeInsets.only(top: 14),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: AppConstants.kSeparatorBuilder(),
                      itemCount: widget.cubit.requestsWithReviews.length,
                      itemBuilder: (context,index)=> RatingOverviewContainerWidget(name: "${widget.cubit.requestsWithReviews[index].parent.fName} ${widget.cubit.requestsWithReviews[index].parent.lname}", rate: widget.cubit.requestsWithReviews[index].rateOfParent!.rate, comment: widget.cubit.requestsWithReviews[index].rateOfParent!.comment),
                    )
                  ],
                )
            );
          }
        ),
      ),
    );
  }
}
