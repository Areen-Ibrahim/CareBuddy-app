import 'package:carebuddy/Core/Components/custom_btn_widgets.dart';
import 'package:carebuddy/Core/Components/show_snackbar_widget.dart';
import 'package:carebuddy/Core/Constants/constants.dart';
import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Constants/images.dart';
import 'package:carebuddy/Features/BabySitter/Controller/Layout/babysitter_cubit.dart';
import 'package:carebuddy/Features/BabySitter/Controller/Layout/babysitter_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/Components/app_scaffold_widget.dart';
import '../../../../Core/Constants/translation_keys.dart';
import '../../../../Core/Theme/colors.dart';

class BabysitterAddNewServiceScreen extends StatefulWidget {
  final BabysitterCubit cubit;
  const BabysitterAddNewServiceScreen({super.key, required this.cubit});

  @override
  State<BabysitterAddNewServiceScreen> createState() => _BabysitterAddNewServiceScreenState();
}

class _BabysitterAddNewServiceScreenState extends State<BabysitterAddNewServiceScreen> {
  @override
  void dispose() {
    widget.cubit.selectedService = null;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appBar: AppBar(title: Text(TranslationKeys.addNewService.tr(context)),),
      body: Padding(
        padding: AppConstants.kScaffoldPadding,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: AppConstants.kMainRadius,
                border: AppConstants.kMainBorder
              ),
              child: DropdownButtonHideUnderline(
                child: BlocBuilder<BabysitterCubit,BabysitterStates>(
                    buildWhen: (past,current) => current is ChooseServiceOfBabysitterState,
                    builder: (context,state) {
                      return DropdownButton<String>(
                        hint: Text(
                          TranslationKeys.chooseYourService.tr(context),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.kBlack,
                          ),
                        ),
                        items: {
                          TranslationKeys.academicTutoring,
                          TranslationKeys.languageTutoring,
                          TranslationKeys.schoolAgedChildren,
                          TranslationKeys.toddlers,
                          TranslationKeys.specialNeedsCare,
                          TranslationKeys.mealPreparation
                        }.map(
                              (service) => DropdownMenuItem(
                            value: service, // Store English key
                            child: Text(service.tr(context)), // Show translated text
                          ),
                        )
                            .toList(),
                        padding: EdgeInsets.zero,
                        value: widget.cubit.selectedService, // Ensure this stores an English key
                        isExpanded: true,
                        onChanged: (String? selected) {
                          if (selected != null) {
                            widget.cubit.chooseService(selected); // Store English value in cubit
                          }
                        },
                      );
                    }
                ),
              ),
            ),
            BlocBuilder<BabysitterCubit,BabysitterStates>(
              buildWhen: (past,current)=> current is AddNewServiceState,
              builder: (context,state) {
                return BtnWidget(
                    onTap: (){
                      if( widget.cubit.selectedService != null )
                        {
                          if( widget.cubit.myData!.services.contains(widget.cubit.selectedService) )
                            {
                              showSnackBarWidget(message: TranslationKeys.youHaveAlreadyThisService.tr(context), successOrNot: true, context: context);
                            }
                          else
                            {
                              widget.cubit.addNewService(context: context,service: widget.cubit.selectedService!);
                            }
                        }
                    },
                    showLoading: state is AddNewServiceState && state.status == ApiRequestStatus.Loading,
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
