import 'package:carebuddy/Features/BabySitter/Controller/Auth/babysitter_auth_cubit.dart';
import 'package:carebuddy/Features/BabySitter/Controller/Auth/babysitter_auth_state.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Features/BabySitter/View/Widgets/Register%20Widgets/choose_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../Core/Components/custom_btn_widgets.dart';
import '../../../../../Core/Components/show_snackbar_widget.dart';
import '../../../../../Core/Constants/translation_keys.dart';
import '../../../../../Core/Theme/colors.dart';

class IdentificationAndSecurityColumnWidget extends StatelessWidget {
  final BabysitterAuthCubit cubit;
  const IdentificationAndSecurityColumnWidget({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(TranslationKeys.identificationAndSecurity.tr(context),style: TextStyle(fontSize: 22,color: AppColors.kBlack)),
        14.vrSpace,
        BlocBuilder<BabysitterAuthCubit,BabysitterAuthStates>(
          buildWhen: (past,current) => current is GetIdentificationImageState,
          builder: (context,state) {
            return ChooseImageWidget(
                title: TranslationKeys.identification.tr(context) + "*",
                file: cubit.identificationImage,
                onTap: ()=> cubit.getIdentificationImage(),
                subTitle: TranslationKeys.uploadIdDocument.tr(context)
            );
          }
        ),
        BlocBuilder<BabysitterAuthCubit,BabysitterAuthStates>(
          buildWhen: (past,current) => current is GetSecurityClearanceMediaState,
          builder: (context,state){
            return ChooseFileMediaWidget(
                title: TranslationKeys.securityClearance.tr(context) + "*",
                file: cubit.securityClearanceMedia,
                onTap: ()=> cubit.getSecurityClearanceMedia(),
                subTitle: TranslationKeys.uploadSafetyCertification.tr(context)
            );
          }
        ),
        BlocBuilder<BabysitterAuthCubit,BabysitterAuthStates>(
            buildWhen: (past,current) => current is GetMedicalHistoryMediaState,
            builder: (context,state) {
              return ChooseFileMediaWidget(
                  title: TranslationKeys.medicalHistory.tr(context) + "*",
                  file: cubit.medicalHistoryMedia,
                  onTap: ()=> cubit.getMedicalHistoryMedia(),
                  subTitle: TranslationKeys.uploadMedicalVerification.tr(context)
              );
            }
        ),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: BtnWidget(
              onTap: (){
                if( cubit.identificationImage != null && cubit.securityClearanceMedia != null && cubit.medicalHistoryMedia != null )
                {
                  cubit.changeIndexOfRegisterContentShown(true);
                }
                else
                {
                  showSnackBarWidget(message: TranslationKeys.completeDataToContinue.tr(context), successOrNot: false, context: context);
                }
              },
              title: TranslationKeys.confirm.tr(context)
          ),
        )
      ],
    );
  }
}
