import 'package:carebuddy/Features/BabySitter/Controller/Auth/babysitter_auth_cubit.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../Core/Constants/translation_keys.dart';
import '../../../Controller/Auth/babysitter_auth_state.dart';
import '../../../../../Core/Components/custom_btn_widgets.dart';
import '../../../../../Core/Components/show_snackbar_widget.dart';
import '../../../../../Core/Theme/colors.dart';
import 'choose_image_widget.dart';

class ProfessionalInfoColumnWidget extends StatelessWidget {
  final BabysitterAuthCubit cubit;
  const ProfessionalInfoColumnWidget({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(TranslationKeys.professionalInformation.tr(context),style: TextStyle(fontSize: 22,color: AppColors.kBlack)),
        14.vrSpace,
        BlocBuilder<BabysitterAuthCubit,BabysitterAuthStates>(
            buildWhen: (past,current) => current is ChangeAvailabilityStatusState,
            builder: (context,state) {
              return SwitchListTile(
                  value: cubit.availabilityStatus,
                  contentPadding: EdgeInsets.zero,
                  activeTrackColor: AppColors.kMain,
                  inactiveTrackColor: AppColors.kGrey,
                  title: Text("${TranslationKeys.availabilityStatus.tr(context)}* ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: AppColors.kBlack)),
                  onChanged: (value) => cubit.changAvailabilityStatus()
              );
            }
        ),
        BlocBuilder<BabysitterAuthCubit,BabysitterAuthStates>(
            buildWhen: (past,current) => current is ChangePricePerHourState,
            builder: (context,state) {
              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${TranslationKeys.pricePerHour.tr(context)}* ${cubit.pricePerHour != 0 ? "(${cubit.pricePerHour} ${TranslationKeys.sar.tr(context)})" : ""}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: AppColors.kBlack)),
                    Slider.adaptive(
                        value: cubit.pricePerHour.toDouble(),
                        max: 200,
                        min: 0,
                        activeColor: AppColors.kMain,
                        onChanged: (value)=> cubit.changePricePerHour(value.toInt())
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("0 ${TranslationKeys.sar.tr(context)}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: AppColors.kBlack)),
                        Text("200 ${TranslationKeys.sar.tr(context)}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: AppColors.kBlack)),
                      ],
                    )
                  ],
                ),
              );
            }
        ),
        BlocBuilder<BabysitterAuthCubit,BabysitterAuthStates>(
            buildWhen: (past,current) => current is GetCertificateMediaState,
            builder: (context,state) {
              return ChooseFileMediaWidget(
                  title: TranslationKeys.additionalCertificates.tr(context),
                  file: cubit.certificateMedia,
                  isOptional: true,
                  onTap: ()=> cubit.getCertificateMedia(),
                  subTitle: TranslationKeys.uploadValidCertificate.tr(context)
              );
            }
        ),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: BtnWidget(
              onTap: (){
                if( cubit.pricePerHour != 0 )
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
