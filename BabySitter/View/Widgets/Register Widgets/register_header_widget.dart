import 'dart:io';
import 'package:carebuddy/Core/Constants/constants.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../Core/Constants/translation_keys.dart';
import '../../../Controller/Auth/babysitter_auth_cubit.dart';
import '../../../Controller/Auth/babysitter_auth_state.dart';
import '../../../../../Core/Theme/colors.dart';

class RegisterHeaderWidget extends StatelessWidget {
  final BabysitterAuthCubit cubit;
  const RegisterHeaderWidget({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 6),
      child: Column(
        children: [
          Stack(
            children: [
              SizedBox(width: double.infinity,child: Text(TranslationKeys.signUpAsBabysitter.tr(context),textAlign: TextAlign.center,style: TextStyle(fontSize: 30,color: AppColors.kBlack,fontWeight: FontWeight.w400),)),
              BlocBuilder<BabysitterAuthCubit,BabysitterAuthStates>(
                builder: (context,state){
                  if( Platform.isIOS || Platform.isMacOS )
                  {
                    return CupertinoNavigationBarBackButton(color: AppColors.kBlack,onPressed: ()=> cubit.indexOfRegisterContentShown == 0 ? context.pop : cubit.changeIndexOfRegisterContentShown(false));
                  }
                  else
                  {
                    return BackButton(color: AppColors.kBlack,onPressed: ()=> cubit.indexOfRegisterContentShown == 0 ? context.pop : cubit.changeIndexOfRegisterContentShown(false));
                  }
                },
              )
            ],
          ),
          BlocBuilder<BabysitterAuthCubit,BabysitterAuthStates>(
              buildWhen: (past,current) => current is ChangeIndexOfRegisterContentShownState,
              builder: (context,state) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 22),
                  padding: AppConstants.kScaffoldPadding.copyWith(bottom: 0,top: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index)=> index != 4 ? Expanded(
                      child: Row(
                        children: [
                          Expanded(child: Divider(color: index <= cubit.indexOfRegisterContentShown ? AppColors.kMain : const Color(0xffF1A3B6),thickness: 2)),
                          if( index != 4 )
                            Container(
                              height: 30,width: 30,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.kWhite),
                                  color: index <= cubit.indexOfRegisterContentShown ? AppColors.kMain : AppColors.kGrey
                              ),
                            )
                        ],
                      ),
                    ) : SizedBox(width:34,child: Divider(color: index <= cubit.indexOfRegisterContentShown ? AppColors.kMain : const Color(0xffF1A3B6),thickness: 2))),
                  ),
                );
              }
          ),
        ],
      ),
    );
  }
}
