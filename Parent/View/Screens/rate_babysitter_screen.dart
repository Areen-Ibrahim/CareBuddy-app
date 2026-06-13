import 'package:carebuddy/Core/Components/app_scaffold_widget.dart';
import 'package:carebuddy/Core/Components/custom_btn_widgets.dart';
import 'package:carebuddy/Core/Components/show_snackbar_widget.dart';
import 'package:carebuddy/Core/Components/txt_field_widget.dart';
import 'package:carebuddy/Core/Constants/constants.dart';
import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Constants/images.dart';
import 'package:carebuddy/Core/Theme/colors.dart';
import 'package:carebuddy/Features/Parent/Controller/Layout/parents_cubit.dart';
import 'package:carebuddy/Features/Parent/Controller/Layout/parents_states.dart';
import 'package:carebuddy/Features/Shared/Models/babysitter_request_model.dart';
import 'package:carebuddy/Features/Shared/Models/comment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../Core/Constants/translation_keys.dart';

class RateBabysitterScreen extends StatefulWidget {
  final ParentsCubit cubit;
  final BabysitterRequestModel request;
  const RateBabysitterScreen({super.key, required this.cubit, required this.request});

  @override
  State<RateBabysitterScreen> createState() => _RateBabysitterScreenState();
}

class _RateBabysitterScreenState extends State<RateBabysitterScreen> {
  final TextEditingController _reviewCtr = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if( widget.request.rateOfParent != null )
      {
        _reviewCtr.text = widget.request.rateOfParent!.comment;
        widget.cubit.currentRateOfBabysitterRequest = widget.request.rateOfParent!.rate;
      }
    super.initState();
  }

  @override
  void dispose() {
    widget.cubit.currentRateOfBabysitterRequest = null;
    _reviewCtr.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appBar: AppBar(title: Text(TranslationKeys.reviewBabysitter.tr(context))),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: AppConstants.kScaffoldPadding,
          children: [
            Text("${TranslationKeys.score.tr(context)} :",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: AppColors.kBlack)),
            2.vrSpace,
            SizedBox(
              height: 24,width: 24,
              child: ListView.separated(
                itemCount: 5,
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context,index)=> 6.hrSpace,
                itemBuilder: (context,index)=> BlocBuilder<ParentsCubit,ParentsStates>(
                  builder: (context,state)
                  {
                    return GestureDetector(
                      onTap: ()=> widget.cubit.changeRateOfBabysitterRequest(index + 1),
                      child: SvgPicture.asset(AppImages.kStarIcon,height: 22,width: 22,color: widget.cubit.currentRateOfBabysitterRequest == null || ( widget.cubit.currentRateOfBabysitterRequest != null && (index + 1) > widget.cubit.currentRateOfBabysitterRequest! ) ? AppColors.kGrey : AppColors.kYellow),
                    );
                  }
                ),
              ),
            ),
            14.vrSpace,
            TextFieldComponentWidget(controller: _reviewCtr,maxLines: 12,validateTxt: TranslationKeys.yourReview.tr(context),hint: TranslationKeys.typeHereYourReview.tr(context),textInputAction: TextInputAction.done),
            8.vrSpace,
            BlocBuilder<ParentsCubit,ParentsStates>(
                buildWhen: (past,current)=> current is ResponseRequestAsParentState && current.request == widget.request,
                builder: (context,state) {
                return BtnWidget(
                  title: widget.request.rateOfParent != null ? TranslationKeys.update.tr(context) : TranslationKeys.confirm.tr(context),
                  showLoading: state is ResponseRequestAsParentState && state.request == widget.request && state.status == ApiRequestStatus.Loading,
                  onTap: (){
                    if( _formKey.currentState!.validate() )
                      {
                        if( widget.cubit.currentRateOfBabysitterRequest != null )
                          {
                            widget.cubit.responseRequest(context: context, request: widget.request, response: null,comment: CommentModel(rate: widget.cubit.currentRateOfBabysitterRequest!, comment: _reviewCtr.text.trim()));
                          }
                        else
                          {
                            showSnackBarWidget(message: TranslationKeys.giveARateAndTryAgain.tr(context), successOrNot: false, context: context);
                          }
                      }
                  },
                );
              }
            )
          ],
        ),
      ),
    );
  }
}
