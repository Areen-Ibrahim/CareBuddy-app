import 'package:carebuddy/Core/Components/app_scaffold_widget.dart';
import 'package:carebuddy/Core/Components/failure_widget.dart';
import 'package:carebuddy/Core/Components/loading_widget.dart';
import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Constants/strings.dart';
import 'package:carebuddy/Core/Theme/colors.dart';
import 'package:carebuddy/Features/BabySitter/Models/baby_sitter.dart';
import 'package:carebuddy/Features/Parent/Controller/Layout/parents_cubit.dart';
import 'package:carebuddy/Features/Parent/Controller/Layout/parents_states.dart';
import 'package:carebuddy/Features/Shared/View/Widgets/parent_rate_container_widget_on_babysitter_request_container_widget.dart';
import 'package:carebuddy/Features/Shared/View/Widgets/rate_row_include_num_and_percentage_and_slider_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../Core/Constants/constants.dart';
import '../../../../Core/Constants/images.dart';
import '../../../../Core/Constants/translation_keys.dart';

class ViewRatesOfSpecificBabysitterAsParentScreen extends StatefulWidget {
  final ParentsCubit cubit;
  final Babysitter babysitter;
  const ViewRatesOfSpecificBabysitterAsParentScreen({super.key, required this.cubit, required this.babysitter});

  @override
  State<ViewRatesOfSpecificBabysitterAsParentScreen> createState() => _ViewRatesOfSpecificBabysitterAsParentScreenState();
}

class _ViewRatesOfSpecificBabysitterAsParentScreenState extends State<ViewRatesOfSpecificBabysitterAsParentScreen> {
  @override
  void initState() {
    widget.cubit.getReviewsOfBabysitter(babysitter: widget.babysitter);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appBar: AppBar(title: Text(TranslationKeys.reviews.tr(context)),),
      body: Padding(
        padding: AppConstants.kScaffoldPadding,
        child: BlocBuilder<ParentsCubit,ParentsStates>(
          buildWhen: (past,current)=> current is GetReviewsOfBabysitterState,
          builder: (context,state) {
            if( state is GetReviewsOfBabysitterState && state.status == ApiRequestStatus.Success)
            {
              if( state.requests.isNotEmpty )
              {
                final int averageRating = (state.requests.map((request) => request.rateOfParent!.rate).reduce((a, b) => a + b) / state.requests.length).toInt();
                return ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 10,
                      children: [
                        Row(
                          spacing: 2,
                          children: List.generate(averageRating, (index)=> SvgPicture.asset(AppImages.kStarIcon,height: 16,width: 16,color: AppColors.kYellow)),
                        ),
                        Text("$averageRating ${TranslationKeys.outOf5.tr(context)}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: AppColors.kBlack),textAlign: TextAlign.center,),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      child: Text("${state.requests.length} ${TranslationKeys.rating.tr(context)}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: AppColors.kBlack.withOpacity(0.38),),textAlign: TextAlign.center,),
                    ),
                    Column(
                        spacing: 6,
                        children: List.generate(5, (index)=> RateRowIncludeNumAndPercentageAndSliderWidget(starNum: 5-index, requestsWithReviews: state.requests))
                    ),
                    ListView.separated(
                      padding: const EdgeInsets.only(top: 14),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: AppConstants.kSeparatorBuilder(),
                      itemCount: state.requests.length,
                      itemBuilder: (context,index)=> RatingOverviewContainerWidget(name: "${state.requests[index].parent.fName} ${state.requests[index].parent.lname}", rate: state.requests[index].rateOfParent!.rate, comment: state.requests[index].rateOfParent!.comment),
                    )
                  ],
                );
              }
              else
              {
                return Center(
                  child: Text(TranslationKeys.noRatesAddedYet.tr(context),style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color: AppColors.kBlack),textAlign: TextAlign.center,),
                );
              }
            }
            else
              {
                if( state is GetReviewsOfBabysitterState && state.status == ApiRequestStatus.Failure )
                  {
                    return FailureWidget(onTap: ()=> widget.cubit.getReviewsOfBabysitter(babysitter: widget.babysitter), message: state.errorMessage ?? AppStrings.kSomethingWentWrong);
                  }
                else
                  {
                    return const LoadingWidget();
                  }
              }
          }
        ),
      ),
    );
  }
}
