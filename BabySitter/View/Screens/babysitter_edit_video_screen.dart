import 'package:carebuddy/Core/Components/app_scaffold_widget.dart';
import 'package:carebuddy/Core/Components/custom_btn_widgets.dart';
import 'package:carebuddy/Core/Constants/constants.dart';
import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Constants/images.dart';
import 'package:carebuddy/Features/BabySitter/Controller/Layout/babysitter_cubit.dart';
import 'package:carebuddy/Features/BabySitter/Controller/Layout/babysitter_state.dart';
import 'package:carebuddy/Features/BabySitter/Models/baby_sitter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/Constants/translation_keys.dart';
import '../../../../Core/Theme/colors.dart';

class BabysitterEditVideoScreen extends StatefulWidget {
  final Babysitter babySitter;
  final BabysitterCubit cubit;
  const BabysitterEditVideoScreen({super.key, required this.babySitter, required this.cubit});

  @override
  State<BabysitterEditVideoScreen> createState() => _BabysitterEditVideoScreenState();
}

class _BabysitterEditVideoScreenState extends State<BabysitterEditVideoScreen> {
  @override
  void dispose() {
    widget.cubit.selectedVideoFile = null;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appBar: AppBar(title: Text(widget.babySitter.multiMedia.introVideo != null ? TranslationKeys.updateVideo.tr(context) : TranslationKeys.addVideo.tr(context)),),
      body: Padding(
        padding: AppConstants.kScaffoldPadding,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            BlocBuilder<BabysitterCubit,BabysitterStates>(
              buildWhen: (past,current)=> current is VideoSelectedSuccessfullyState,
              builder: (context,state) {
                return GestureDetector(
                  onTap: ()=> widget.cubit.chooseVideo(),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 6,
                      children: [
                        Container(
                            padding: AppConstants.kContainerPadding,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: AppColors.kGrey,
                                borderRadius: AppConstants.kMainRadius
                            ),
                            child: Row(
                              spacing: 14,
                              children: [
                                Expanded(child: Text(widget.cubit.selectedVideoFile != null ? widget.cubit.selectedVideoFile!.path : widget.babySitter.multiMedia.introVideo != null ? widget.babySitter.multiMedia.introVideo! : TranslationKeys.clickHereToSelectVideo.tr(context),style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: AppColors.kBlack),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                                Icon(Icons.open_in_browser,color: AppColors.kMain,)
                              ],
                            )
                        )
                      ],
                    ),
                  ),
                );
              }
            ),
            BlocBuilder<BabysitterCubit,BabysitterStates>(
              buildWhen: (past,current)=> current is UpdateVideoState,
              builder: (context,state) {
                return BtnWidget(
                    onTap: (){
                      if( widget.cubit.selectedVideoFile != null )
                        {
                          widget.cubit.updateIntroVideo(context: context,file: widget.cubit.selectedVideoFile!);
                        }
                    },
                    showLoading: state is UpdateVideoState && state.status == ApiRequestStatus.Loading,
                    title: TranslationKeys.confirm.tr(context),
                );
              }
            )
          ],
        ),
      ),
    );
  }
}
