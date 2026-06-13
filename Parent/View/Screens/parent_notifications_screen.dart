import 'package:carebuddy/Core/Components/app_scaffold_widget.dart';
import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/Components/data_state_builder_widget.dart';
import '../../../../Core/Constants/constants.dart';
import '../../../../Core/Constants/translation_keys.dart';
import '../../Controller/Layout/parents_cubit.dart';
import '../../Controller/Layout/parents_states.dart';
import '../Widgets/Parent Notifications Widgets/parent_notify_card_widget.dart';

class ParentNotificationsScreen extends StatefulWidget{
  final ParentsCubit cubit;
  const ParentNotificationsScreen({super.key, required this.cubit});

  @override
  State<ParentNotificationsScreen> createState() => _ParentNotificationsScreenState();
}

class _ParentNotificationsScreenState extends State<ParentNotificationsScreen> {
  @override
  void initState() {
    ParentsCubit.getInstance(context).getNotifications();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final ParentsCubit cubit = ParentsCubit.getInstance(context);
    return AppScaffoldWidget(
      appBar: AppBar(title: Text(TranslationKeys.notifications.tr(context))),
      body: Padding(
        padding: AppConstants.kScaffoldPadding,
        child: BlocBuilder<ParentsCubit,ParentsStates>(
          builder: (context,state){
            return DataStateBuilderWidget(
                emptyTxt: TranslationKeys.noNotificationsReceivedYet.tr(context),
                failureTap: ()=> cubit.getNotifications(),
                isLoading: state is GetNotificationsState && state.status == ApiRequestStatus.Loading,
                isError: state is GetNotificationsState && state.status == ApiRequestStatus.Failure,
                errorTxt: state is GetNotificationsState && state.status == ApiRequestStatus.Failure ? state.errorMessage : null,
                isDataFound: cubit.notifications.isNotEmpty,
                widget: ListView.separated(
                  padding: AppConstants.kListViewPadding,
                  itemCount: cubit.notifications.length,
                  separatorBuilder: AppConstants.kSeparatorBuilder(),
                  itemBuilder: (context,index)=> NotifyCardWidget(notify: cubit.notifications[index]),
                )
            );
          },
        ),
      ),
    );
  }
}
