import 'package:carebuddy/Core/Components/app_scaffold_widget.dart';
import 'package:carebuddy/Core/Components/data_state_builder_widget.dart';
import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Features/BabySitter/Controller/Layout/babysitter_cubit.dart';
import 'package:carebuddy/Core/Theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/Components/custom_bottom_nav_item_widget.dart';
import '../../../../Core/Constants/translation_keys.dart';
import '../../Controller/Layout/babysitter_state.dart';

class BabysitterLayoutScreen extends StatefulWidget {
  const BabysitterLayoutScreen({super.key});

  @override
  State<BabysitterLayoutScreen> createState() => _BabysitterLayoutScreenState();
}

class _BabysitterLayoutScreenState extends State<BabysitterLayoutScreen> {
  @override
  void initState() {
    BabysitterCubit.getInstance(context).getMyData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final BabysitterCubit cubit = BabysitterCubit.getInstance(context);
    return BlocBuilder<BabysitterCubit,BabysitterStates>(
      builder: (context,state) {
        return AppScaffoldWidget(
          body: DataStateBuilderWidget(
              isLoading: state is GetMyDataState && state.status == ApiRequestStatus.Loading,
              isError: state is GetMyDataState && state.status == ApiRequestStatus.Failure,
              errorTxt: state is GetMyDataState && state.status == ApiRequestStatus.Failure ? state.errorMessage : null,
              isDataFound: cubit.myData != null,
              failureTap: ()=> cubit.getMyData(),
              widget: cubit.layoutPages[BabysitterCubit.getInstance(context).currentIndexOfBottomNavigation]
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: BabysitterCubit.getInstance(context).currentIndexOfBottomNavigation,
            onTap: (index)=> BabysitterCubit.getInstance(context).changeIndexOfBottomNavigation(index),
            selectedItemColor: AppColors.kMain,
            unselectedItemColor: AppColors.kLightGrey,
            items: [
              CustomBottomNavigationItem.show(
                currentIndex: cubit.currentIndexOfBottomNavigation,
                index: 0,
                imageName: "Chat",
                title: TranslationKeys.chat.tr(context),
              ),
              CustomBottomNavigationItem.show(
                currentIndex: cubit.currentIndexOfBottomNavigation,
                index: 1,
                imageName: "Booking",
                title: TranslationKeys.booking.tr(context),
              ),
              CustomBottomNavigationItem.show(
                currentIndex: cubit.currentIndexOfBottomNavigation,
                index: 2,
                imageName: "Profile",
                title: TranslationKeys.profile.tr(context),
              ),
            ],
          ),
        );
      }
    );
  }
}
