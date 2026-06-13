import 'package:carebuddy/Core/Components/app_scaffold_widget.dart';
import 'package:carebuddy/Core/Components/data_state_builder_widget.dart';
import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Features/Parent/View/Widgets/Parents%20Chats/parent_chat_item_overview_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/Constants/constants.dart';
import '../../../../Core/Constants/translation_keys.dart';
import '../../Controller/Layout/parents_cubit.dart';
import '../../Controller/Layout/parents_states.dart';

class ParentChatScreen extends StatefulWidget {
  const ParentChatScreen({super.key});

  @override
  State<ParentChatScreen> createState() => _ParentChatScreenState();
}

class _ParentChatScreenState extends State<ParentChatScreen> {
  @override
  void initState() {
    ParentsCubit.getInstance(context).getChatsUpdates();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final ParentsCubit cubit = ParentsCubit.getInstance(context);
    return AppScaffoldWidget(
      showBackgroundImage: false,
      appBar: AppBar(title: Text(TranslationKeys.chats.tr(context))),
      body: Padding(
        padding: AppConstants.kScaffoldPadding,
        child: BlocBuilder<ParentsCubit,ParentsStates>(
          buildWhen: (past,current)=> current is GetChatsUpdateState,
          builder: (context,state){
            return DataStateBuilderWidget(
                isLoading: state is GetChatsUpdateState && state.status == ApiRequestStatus.Loading,
                isError: state is GetChatsUpdateState && state.status == ApiRequestStatus.Failure,
                errorTxt: state is GetChatsUpdateState && state.status == ApiRequestStatus.Failure ? state.errorMessage : null,
                isDataFound: cubit.chatsUpdate.isNotEmpty,
                failureTap: ()=> cubit.getChatsUpdates(),
                emptyTxt: TranslationKeys.noChatsCreatedYet.tr(context),
                widget: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: cubit.chatsUpdate.length,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: AppConstants.kSeparatorBuilder(),
                  itemBuilder: (context,index)=> ParentChatItemOverviewCardWidget(updateChatsOverview: true,receiverData: cubit.chatsUpdate[index],parentsCubit: cubit),
                )
            );
          },
        ),
      ),
    );
  }
}
