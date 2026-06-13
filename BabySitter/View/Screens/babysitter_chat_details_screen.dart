import 'package:carebuddy/Core/Components/app_scaffold_widget.dart';
import 'package:carebuddy/Core/Components/failure_widget.dart';
import 'package:carebuddy/Core/Components/loading_widget.dart';
import 'package:carebuddy/Core/Constants/constants.dart';
import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Constants/images.dart';
import 'package:carebuddy/Core/Theme/colors.dart';
import 'package:carebuddy/Features/BabySitter/Controller/Layout/babysitter_cubit.dart';
import 'package:carebuddy/Features/BabySitter/Controller/Layout/babysitter_state.dart';
import 'package:carebuddy/Features/Parent/View/Screens/view_parent_details_screen.dart';
import 'package:carebuddy/Features/Shared/Models/chat_overview_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/Components/message_content_card_widget.dart';

class BabysitterChatDetailsScreen extends StatefulWidget {
  final ParentChatOverviewModel receiverData;
  // TODO: In Case Open From ChatsOverview Call It.
  final bool updateChatsOverview;
  final BabysitterCubit cubit;
  const BabysitterChatDetailsScreen(
      {super.key,
      required this.receiverData,
      required this.cubit,
      required this.updateChatsOverview});

  @override
  State<BabysitterChatDetailsScreen> createState() =>
      _BabysitterChatDetailsScreenState();
}

class _BabysitterChatDetailsScreenState
    extends State<BabysitterChatDetailsScreen> {
  late TextEditingController _messageCtr;
  late ScrollController _scrollCtr;

  @override
  void initState() {
    _messageCtr = TextEditingController();
    _scrollCtr = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _messageCtr.dispose();
    _scrollCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
        appBar: AppBar(
          title: GestureDetector(
            onTap: ()=> context.push(ViewParentDetailsScreen(id: widget.receiverData.parentID, requestStatus: BabysitterRequestStatus.Pending.name)),
            child: Row(
              spacing: 14,
              children: [
                Container(
                  height: 46,
                  width: 46,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withOpacity(0.5),
                      image: DecorationImage(
                        image: widget.receiverData.parentImage != null
                            ? NetworkImage(widget.receiverData.parentImage!)
                            : const AssetImage(AppImages.kAccountIcon),
                        fit: BoxFit.cover,
                      )),
                ),
                Text(widget.receiverData.parentName)
              ],
            ),
          ),
        ),
        body: FutureBuilder(
            future: widget.cubit.getMessages(parentID: widget.receiverData.parentID, scrollCtr: _scrollCtr),
            builder: (context, _) {
              return BlocBuilder<BabysitterCubit, BabysitterStates>(
                  buildWhen: (past, current) => current is GetBabySitterMessagesState,
                  builder: (context, state) {
                    if (state is GetBabySitterMessagesState && state.status == ApiRequestStatus.Success) {
                      return Padding(
                        padding: AppConstants.kScaffoldPadding,
                        child: Column(
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  Builder(
                                    builder: (context) {
                                      if (state.messages != null &&
                                          state.messages!.isNotEmpty) {
                                        return ListView.separated(
                                          shrinkWrap: true,
                                          controller: _scrollCtr,
                                          padding: EdgeInsets.zero
                                              .copyWith(bottom: 22),
                                          itemBuilder: (context, index) => state
                                                      .messages![index]
                                                      .senderID ==
                                                  widget.cubit.myData!.id
                                              ? SenderMessageContentCardWidget(
                                                  messageEntity:
                                                      state.messages![index],
                                                  senderName: widget
                                                      .cubit.myData!.fName,
                                                  senderProfileImage: widget
                                                      .cubit
                                                      .myData!
                                                      .multiMedia
                                                      .profileImage)
                                              : ReceiverMessageContentCardWidget(
                                                  messageEntity:
                                                      state.messages![index],
                                                  receiverName: widget
                                                      .receiverData.parentName,
                                                  receiverProfileImage: widget
                                                      .receiverData
                                                      .parentImage),
                                          separatorBuilder: (context, index) =>
                                              18.vrSpace,
                                          itemCount: state.messages!.length,
                                        );
                                      } else {
                                        return const SizedBox();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            TextField(
                              controller: _messageCtr,
                              onSubmitted: (value) {
                                if (_messageCtr.text.isNotEmpty) {
                                  widget.cubit.sendMessage(
                                      messageCtr: _messageCtr,
                                      scrollCtr: _scrollCtr,
                                      updateChatsOverview:
                                          widget.updateChatsOverview,
                                      receiverData: widget.receiverData,
                                      message: _messageCtr.text.trim(),
                                      context: context);
                                }
                              },
                              decoration: InputDecoration(
                                  fillColor: AppColors.kWhite,
                                  filled: true,
                                  suffixIcon: GestureDetector(
                                    child: const Icon(Icons.send,
                                        color: Color(0xffA8A8AA)),
                                    onTap: () {
                                      if (_messageCtr.text.isNotEmpty) {
                                        widget.cubit.sendMessage(
                                            messageCtr: _messageCtr,
                                            scrollCtr: _scrollCtr,
                                            updateChatsOverview:
                                                widget.updateChatsOverview,
                                            receiverData: widget.receiverData,
                                            message: _messageCtr.text.trim(),
                                            context: context);
                                      }
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: AppConstants.kMaxRadius,
                                      borderSide: const BorderSide(
                                          color: Color(0xffA8A8AA)))),
                            )
                          ],
                        ),
                      );
                    } else {
                      if (state is GetBabySitterMessagesState &&
                          state.status == ApiRequestStatus.Failure) {
                        return FailureWidget(
                            onTap: () => widget.cubit.getMessages(
                                scrollCtr: _scrollCtr,
                                parentID: widget.receiverData.parentID),
                            message: state.errorMessage!);
                      } else {
                        return const LoadingWidget();
                      }
                    }
                  });
            }));
  }
}
