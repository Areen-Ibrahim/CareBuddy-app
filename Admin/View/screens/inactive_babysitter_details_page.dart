import 'package:carebuddy/Core/Components/babysitter_data_list_view_widget.dart';
import 'package:carebuddy/Core/Components/custom_btn_widgets.dart';
import 'package:carebuddy/Core/Constants/constants.dart';
import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Constants/images.dart';
import 'package:carebuddy/Core/Theme/colors.dart';
import 'package:carebuddy/Features/Admin/Controller/admin_cubit.dart';
import 'package:carebuddy/Features/BabySitter/Models/baby_sitter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Core/Constants/translation_keys.dart';

class BabysitterDetailsAsAdminPage extends StatelessWidget {
  final Babysitter babySitter;
  final AdminCubit cubit;
  final bool validationNotBlocked;
  const BabysitterDetailsAsAdminPage({super.key, required this.babySitter, required this.cubit, required this.validationNotBlocked});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(TranslationKeys.babysitterDetails.tr(context))),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage(AppImages.kBackgroundImage),fit: BoxFit.cover)
        ),
        child: Padding(
          padding: AppConstants.kScaffoldPadding,
          child: Column(
            children: [
              Expanded(
                child: BabysitterDataListViewWidget(babySitter: babySitter),
              ),
              if( !validationNotBlocked || babySitter.status == ResponseOfInactiveBabysitterRequest.Pending.name || babySitter.status == ResponseOfInactiveBabysitterRequest.Rejected.name )
                BlocBuilder<AdminCubit,AdminStates>(
                  builder: (context,state) {
                    if( !validationNotBlocked )
                      {
                        return Container(
                        margin: const EdgeInsets.only(top: 8),
                        child:  BtnWidget(
                          onTap: ()=> cubit.updateBabysitterStatusAsAdmin(unBlock: true,context: context, babysitter: babySitter, response: ResponseOfInactiveBabysitterRequest.Rejected),
                          showLoading: state is UpdateBabysitterStatusAsAdminState && state.babySitter == babySitter && state.response == ResponseOfInactiveBabysitterRequest.Rejected,
                          title: TranslationKeys.cancelBlock.tr(context),
                        ),
                      );
                      }
                    else
                      {
                        return Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: Row(
                            spacing: 14,
                            children: [
                              Expanded(
                                child: BtnWidget(
                                  onTap: ()=> cubit.updateBabysitterStatusAsAdmin(context: context, babysitter: babySitter, response: ResponseOfInactiveBabysitterRequest.Rejected),
                                  backgroundColor: AppColors.kRed,
                                  showLoading: state is UpdateBabysitterStatusAsAdminState && state.babySitter == babySitter && state.response == ResponseOfInactiveBabysitterRequest.Rejected,
                                  title: TranslationKeys.reject.tr(context),
                                ),
                              ),
                              Expanded(
                                child: BtnWidget(
                                  onTap: ()=> cubit.updateBabysitterStatusAsAdmin(context: context, babysitter: babySitter, response: ResponseOfInactiveBabysitterRequest.Accepted),
                                  backgroundColor: AppColors.kGreen,
                                  showLoading: state is UpdateBabysitterStatusAsAdminState && state.babySitter == babySitter && state.response == ResponseOfInactiveBabysitterRequest.Accepted,
                                  title: TranslationKeys.accept.tr(context),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                  }
                )
            ],
          ),
        ),
      ),
    );
  }
}



