import 'package:carebuddy/Features/BabySitter/Controller/Layout/babysitter_cubit.dart';
import 'package:carebuddy/Features/Shared/Models/chat_overview_model.dart';
import 'package:flutter/material.dart';
import '../../../../../Core/Constants/constants.dart';
import '../../../../../Core/Theme/colors.dart';
import '../../Screens/babysitter_chat_details_screen.dart';

class BabysitterChatItemOverviewCardWidget extends StatelessWidget {
  final ParentChatOverviewModel receiverData;
  final BabysitterCubit cubit;
  final bool updateChatsOverview;
  const BabysitterChatItemOverviewCardWidget({super.key, required this.receiverData, required this.cubit, required this.updateChatsOverview});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> BabysitterChatDetailsScreen(updateChatsOverview: updateChatsOverview,receiverData: receiverData,cubit: cubit))),
      child: Container(
        padding: AppConstants.kContainerPadding,
        decoration: BoxDecoration(
            borderRadius: AppConstants.kMaxRadius,
            color: AppColors.kMain
        ),
        child: Row(
          spacing: 14,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey.shade300,
              radius: 30,
              backgroundImage: receiverData.parentImage != null ? NetworkImage(receiverData.parentImage!) : null,
              child: receiverData.parentImage == null ? const Icon(Icons.person, size: 30, color: Colors.grey) : null,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 2,
                children: [
                  Text(receiverData.parentName,style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: AppColors.kWhite)),
                  Text(receiverData.lastMessage,style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,color: AppColors.kWhite),maxLines: 1,overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            Icon(Icons.navigate_next,color: AppColors.kWhite),
          ],
        ),
      ),
    );
  }
}
