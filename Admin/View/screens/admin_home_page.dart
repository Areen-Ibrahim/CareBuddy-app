import 'package:carebuddy/Core/Components/failure_widget.dart';
import 'package:carebuddy/Core/Components/loading_widget.dart';
import 'package:carebuddy/Core/Constants/constants.dart';
import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Constants/images.dart';
import 'package:carebuddy/Features/Admin/Controller/admin_cubit.dart';
import 'package:carebuddy/Features/Admin/View/Widgets/blocked_babysitter_card_widget.dart';
import 'package:carebuddy/Features/Admin/View/Widgets/inactive_babysitter_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/Constants/translation_keys.dart';
import '../../../../Core/Theme/colors.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminCubit cubit = AdminCubit.getInstance(context)..getInactiveBabysitter()..getBlockedBabysitter();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage(AppImages.kBackgroundImage),fit: BoxFit.cover)
        ),
        child: Padding(
          padding: AppConstants.kScaffoldPadding,
          child: BlocBuilder<AdminCubit,AdminStates>(
            builder: (context,state){
              return Padding(
                padding: EdgeInsets.only(top: context.topPaddingOfScreen),
                child: Column(
                  spacing: 14,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(TranslationKeys.welcomeAdmin.tr(context),style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: AppColors.kBlack)),
                        GestureDetector(
                          onTap: ()=> cubit.logOut(context),
                          child: Column(
                            spacing: 6,
                            children: [
                              Icon(Icons.logout,color: AppColors.kBlack),
                              Text(TranslationKeys.logOut.tr(context),style: TextStyle(fontSize: 16,color: AppColors.kBlack,fontWeight: FontWeight.w400))
                            ],
                          ),
                        )
                      ],
                    ),
                    Row(
                      spacing: 14,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: ()=> cubit.changeTabBarIndex(0),
                            child: Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              padding: AppConstants.kContainerPadding.copyWith(right: 10,left: 10),
                              decoration: BoxDecoration(
                                borderRadius: AppConstants.kMainRadius,
                                border: Border.all(color: AppColors.kMain),
                                color: cubit.currentTabBar == 0 ? AppColors.kMain : Colors.transparent,
                              ),
                              child: Text("Babysitters validation",overflow: TextOverflow.ellipsis,style: TextStyle(color: cubit.currentTabBar != 0 ? AppColors.kMain : Colors.white,fontWeight: FontWeight.w600,fontSize: 16),),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: ()=> cubit.changeTabBarIndex(1),
                            child: Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              padding: AppConstants.kContainerPadding.copyWith(right: 10,left: 10),
                              decoration: BoxDecoration(
                                borderRadius: AppConstants.kMainRadius,
                                border: Border.all(color: AppColors.kMain),
                                color: cubit.currentTabBar == 1 ? AppColors.kMain : Colors.transparent,
                              ),
                              child: Text("Blocked Babysitters",overflow: TextOverflow.ellipsis,style: TextStyle(color: cubit.currentTabBar != 1 ? AppColors.kMain : Colors.white,fontWeight: FontWeight.w600,fontSize: 16),),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Builder(
                        builder: (context)
                        {
                          if( cubit.currentTabBar == 0 )
                          {
                            if( state is GetInactiveBabysittersAsAdminState && state.status == ApiRequestStatus.Loading )
                            {
                              return LoadingWidget();
                            }
                            else
                            {
                              if( state is GetInactiveBabysittersAsAdminState && state.status == ApiRequestStatus.Failure )
                              {
                                return FailureWidget(onTap: ()=> cubit.getInactiveBabysitter(), message: state.errorMessage);
                              }
                              else
                              {
                                if( cubit.inactiveBabysitters.isNotEmpty )
                                {
                                  return ListView.separated(
                                    itemCount: cubit.inactiveBabysitters.length,
                                    padding: EdgeInsets.zero.copyWith(bottom: 22),
                                    separatorBuilder: AppConstants.kSeparatorBuilder(),
                                    itemBuilder: (context,index)=> InactiveBabysitterCardWidget(babySitter: cubit.inactiveBabysitters[index],cubit: cubit),
                                  );
                                }
                                else
                                {
                                  return Center(
                                    child: Text(TranslationKeys.noInactiveBabysitters.tr(context),style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: AppColors.kBlack),),
                                  );
                                }
                              }
                            }
                          }
                          else
                          {
                            if( state is GetBlockedBabysittersAsAdminState && state.status == ApiRequestStatus.Loading )
                              {
                                return LoadingWidget();
                              }
                            else
                              {
                                if( state is GetBlockedBabysittersAsAdminState && state.status == ApiRequestStatus.Failure )
                                  {
                                    return FailureWidget(onTap: ()=> cubit.getBlockedBabysitter(), message: state.errorMessage);
                                  }
                                else
                                  {
                                    if( cubit.blockedBabysitters.isNotEmpty )
                                    {
                                      return ListView.separated(
                                        itemCount: cubit.blockedBabysitters.length,
                                        padding: EdgeInsets.zero.copyWith(bottom: 22),
                                        separatorBuilder: AppConstants.kSeparatorBuilder(),
                                        itemBuilder: (context,index)=> BlockedBabysitterCardWidget(babySitter: cubit.blockedBabysitters[index],cubit: cubit),
                                      );
                                    }
                                    else
                                    {
                                      return Center(
                                        child: Text(TranslationKeys.noBlockedBabysitters.tr(context),style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: AppColors.kBlack),),
                                      );
                                    }
                                  }
                              }
                          }
                        },
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      )
    );
  }
}
