import 'package:carebuddy/Core/Components/custom_btn_widgets.dart';
import 'package:carebuddy/Core/Components/show_snackbar_widget.dart';
import 'package:carebuddy/Core/Constants/constants.dart';
import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Features/Parent/Controller/Layout/parents_cubit.dart';
import 'package:carebuddy/Features/Parent/Controller/Layout/parents_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/Constants/images.dart';
import '../../../../Core/Constants/translation_keys.dart';
import '../../../../Core/Theme/colors.dart';

class ParentUpdateProfileImageScreen extends StatefulWidget {
  final ParentsCubit cubit;
  const ParentUpdateProfileImageScreen({super.key, required this.cubit});

  @override
  State<ParentUpdateProfileImageScreen> createState() => _ParentUpdateProfileImageScreenState();
}

class _ParentUpdateProfileImageScreenState extends State<ParentUpdateProfileImageScreen> {
  @override
  void dispose() {
    widget.cubit.parentImageFile = null;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(TranslationKeys.updateProfileImage.tr(context))),
      body: BlocBuilder<ParentsCubit,ParentsStates>(
          buildWhen: (past,current) => current is EditParentProfileState || current is PickedImageOnParentState,
          builder: (context,state) {
            return Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage(AppImages.kBackgroundImage),fit: BoxFit.cover)
              ),
              child: Padding(
                padding: AppConstants.kScaffoldPadding.copyWith(top: context.topPaddingOfScreen + 14),
                child: ListView(
                  padding: EdgeInsets.zero.copyWith(bottom: 22),
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: ()=> widget.cubit.chooseParentImageFile(),
                        child: Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            Container(
                              height: 110,
                              width: 110,
                              clipBehavior: Clip.hardEdge,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: widget.cubit.parentImageFile != null ? Image.file(widget.cubit.parentImageFile!,fit: BoxFit.cover) : Image.network(widget.cubit.myData!.profileImage,fit: BoxFit.cover),
                            ),
                            Container(
                              height: 30,width: 30,
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.kMain
                              ),
                              child: Image.asset("assets/images/edit.png"),
                            )
                          ],
                        ),
                      ),
                    ),
                    22.vrSpace,
                    BtnWidget(
                        onTap: (){
                          if( widget.cubit.parentImageFile != null )
                          {
                            widget.cubit.editParentProfileImage(context: context);
                          }
                          else
                            {
                              showSnackBarWidget(message: TranslationKeys.chooseAnImageAndTryAgain.tr(context), successOrNot: true, context: context);
                            }
                        },
                        showLoading: state is EditParentProfileState && state.status == ApiRequestStatus.Loading,
                        title: TranslationKeys.update.tr(context)
                    ),
                  ],
                ),
              ),
            );
          }
      ),
    );
  }
}
