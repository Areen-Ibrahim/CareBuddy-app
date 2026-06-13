import 'package:carebuddy/Core/Components/app_scaffold_widget.dart';
import 'package:carebuddy/Core/Components/custom_bottom_nav_item_widget.dart';
import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/Components/data_state_builder_widget.dart';
import '../../../../Core/Constants/translation_keys.dart';
import '../../Controller/Layout/parents_cubit.dart';
import '../../Controller/Layout/parents_states.dart';

class ParentLayoutScreen extends StatefulWidget {
  const ParentLayoutScreen({super.key});

  @override
  State<ParentLayoutScreen> createState() => _ParentLayoutScreenState();
}

class _ParentLayoutScreenState extends State<ParentLayoutScreen> {
  @override
  void initState() {
    ParentsCubit.getInstance(context).getMyData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final ParentsCubit cubit = ParentsCubit.getInstance(context);
    return BlocBuilder<ParentsCubit,ParentsStates>(
      builder: (context,state) {
        return AppScaffoldWidget(
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: cubit.currentIndexOfBottomNavigation,
            onTap: (index)=> cubit.changeIndexOfBottomNavigation(index),
            selectedItemColor: AppColors.kMain,
            unselectedItemColor: AppColors.kLightGrey,
            items: [
              CustomBottomNavigationItem.show(
                currentIndex: cubit.currentIndexOfBottomNavigation,
                index: 0,
                imageName: "Home",
                title: TranslationKeys.home.tr(context),
              ),
              CustomBottomNavigationItem.show(
                currentIndex: cubit.currentIndexOfBottomNavigation,
                index: 1,
                imageName: "heart",
                title: TranslationKeys.favorites.tr(context),
              ),
              CustomBottomNavigationItem.show(
                currentIndex: cubit.currentIndexOfBottomNavigation,
                index: 2,
                imageName: "Booking",
                title: TranslationKeys.requests.tr(context),
              ),
              CustomBottomNavigationItem.show(
                currentIndex: cubit.currentIndexOfBottomNavigation,
                index: 3,
                imageName: "Chat",
                title: TranslationKeys.chat.tr(context),
              ),
              CustomBottomNavigationItem.show(
                currentIndex: cubit.currentIndexOfBottomNavigation,
                index: 4,
                imageName: "Profile",
                title: TranslationKeys.profile.tr(context),
              ),
            ],
          ),
          body: DataStateBuilderWidget(
              isLoading: state is GetParentDataState && state.status == ApiRequestStatus.Loading,
              isError: state is GetParentDataState && state.status == ApiRequestStatus.Failure,
              failureTap: ()=> cubit.getMyData(),
              errorTxt: state is GetParentDataState && state.status == ApiRequestStatus.Failure ? state.errorMessage : null,
              isDataFound: cubit.myData != null,
              widget: cubit.layoutPages[cubit.currentIndexOfBottomNavigation]
          ),
        );
      }
    );
  }
}
