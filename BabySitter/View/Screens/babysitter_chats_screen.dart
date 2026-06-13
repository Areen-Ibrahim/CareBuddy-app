import 'package:carebuddy/Core/Components/app_scaffold_widget.dart';
import 'package:carebuddy/Core/Components/data_state_builder_widget.dart';
import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Theme/colors.dart';
import 'package:carebuddy/Features/BabySitter/Controller/Layout/babysitter_cubit.dart';
import 'package:carebuddy/Features/BabySitter/Controller/Layout/babysitter_state.dart';
import 'package:carebuddy/Features/BabySitter/View/Screens/babysitter_notifications_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/Constants/constants.dart';
import '../../../../Core/Constants/translation_keys.dart';
import '../Widgets/Chat Widgets/babysitter_chat_item_overview_card_widget.dart';

class BabysitterChatsScreen extends StatefulWidget {
  const BabysitterChatsScreen({super.key});

  @override
  State<BabysitterChatsScreen> createState() => _BabysitterChatsScreenState();
}

class _BabysitterChatsScreenState extends State<BabysitterChatsScreen> {
  @override
  void initState() {
    BabysitterCubit.getInstance(context).getChatsUpdates();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final BabysitterCubit cubit = BabysitterCubit.getInstance(context);
    return AppScaffoldWidget(
      appBar: AppBar(
          title: Text(TranslationKeys.chats.tr(context)),
        actions: [
          Padding(
            padding: AppConstants.kScaffoldPadding,
            child: GestureDetector(
              onTap: () => context.push(
                BabysitterNotificationsScreen(cubit: cubit),
              ),
              child: Icon(
                Icons.notifications,
                color: AppColors.kMain,
                size: 30,
              ),
            ),
          )
        ],
      ),
      showBackgroundImage: false,
      body: Padding(
        padding: AppConstants.kScaffoldPadding,
        child: BlocBuilder<BabysitterCubit,BabysitterStates>(
          builder: (context,state){
            return DataStateBuilderWidget(
                isLoading: state is GetChatsUpdateForBabysitterState && state.status == ApiRequestStatus.Loading,
                emptyTxt: TranslationKeys.noChatsCreatedYet.tr(context),
                errorTxt: state is GetChatsUpdateForBabysitterState && state.status == ApiRequestStatus.Failure ? state.errorMessage : null,
                failureTap: ()=> cubit.getChatsUpdates(),
                isError: state is GetChatsUpdateForBabysitterState && state.status == ApiRequestStatus.Failure,
                isDataFound: cubit.chatsUpdate.isNotEmpty,
                widget: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: cubit.chatsUpdate.length,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: AppConstants.kSeparatorBuilder(),
                  itemBuilder: (context,index)=> BabysitterChatItemOverviewCardWidget(updateChatsOverview: true,receiverData: cubit.chatsUpdate[index],cubit: cubit),
                )
            );
          },
        ),
      ),
    );
  }
}
