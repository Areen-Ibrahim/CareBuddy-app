import 'package:carebuddy/Core/Components/failure_widget.dart';
import 'package:carebuddy/Core/Components/loading_widget.dart';
import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Theme/colors.dart';
import 'package:carebuddy/Features/BabySitter/Controller/Layout/babysitter_cubit.dart';
import 'package:carebuddy/Features/BabySitter/Controller/Layout/babysitter_state.dart';
import 'package:carebuddy/Features/Parent/View/Widgets/Parent%20Notifications%20Widgets/parent_notify_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/Constants/constants.dart';
import '../../../../Core/Constants/translation_keys.dart';

class BabysitterNotificationsScreen extends StatefulWidget {
  final BabysitterCubit cubit;
  const BabysitterNotificationsScreen({super.key, required this.cubit});

  @override
  State<BabysitterNotificationsScreen> createState() => _BabysitterNotificationsScreenState();
}

class _BabysitterNotificationsScreenState extends State<BabysitterNotificationsScreen> {
  @override
  void initState() {
    widget.cubit.getNotifications();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(TranslationKeys.notifications.tr(context))),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/images/background_image.png"),fit: BoxFit.cover)
        ),
        child: Padding(
          padding: AppConstants.kScaffoldPadding,
          child: BlocBuilder<BabysitterCubit,BabysitterStates>(
            buildWhen: (past,current)=> current is GetBabySitterNotificationsState,
            builder: (context,state){
              if( state is GetBabySitterNotificationsState && state.status == ApiRequestStatus.Success )
              {
                if( state.notifications.isNotEmpty )
                  {
                    return ListView.separated(
                      padding: AppConstants.kListViewPadding,
                      itemCount: state.notifications.length,
                      separatorBuilder: AppConstants.kSeparatorBuilder(),
                      itemBuilder: (context,index)=> NotifyCardWidget(notify: state.notifications[index]),
                    );
                  }
                else
                  {
                    return Center(child: Text(TranslationKeys.noNotificationsReceivedYet.tr(context),style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: AppColors.kBlack)));
                  }
              }
              else
              {
                if( state is GetBabySitterNotificationsState && state.status == ApiRequestStatus.Failure )
                {
                  return FailureWidget(onTap: ()=> widget.cubit.getNotifications(), message: state.errorMessage!);
                }
                else
                {
                  return const LoadingWidget();
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
