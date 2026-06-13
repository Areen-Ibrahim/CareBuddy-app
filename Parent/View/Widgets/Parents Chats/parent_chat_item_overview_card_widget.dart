import 'package:carebuddy/Features/Parent/View/Screens/parent_chat_details_screen.dart';
import 'package:carebuddy/Features/Shared/Models/chat_overview_model.dart';
import 'package:flutter/material.dart';
import '../../../../../Core/Constants/constants.dart';
import '../../../../../Core/Theme/colors.dart';
import '../../../Controller/Layout/parents_cubit.dart';

class ParentChatItemOverviewCardWidget extends StatelessWidget {
  final BabysitterChatOverviewModel receiverData;
  final ParentsCubit parentsCubit;
  final bool updateChatsOverview;
  const ParentChatItemOverviewCardWidget({super.key, required this.receiverData, required this.parentsCubit, required this.updateChatsOverview});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> ParentChatDetailsScreen(updateChatsOverview: updateChatsOverview,receiverData: receiverData,cubit: parentsCubit))),
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
              backgroundImage: receiverData.babysitterIImage != null ? NetworkImage(receiverData.babysitterIImage!) : null,
              child: receiverData.babysitterIImage == null ? const Icon(Icons.person, size: 30, color: Colors.grey) : null,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 2,
                children: [
                  Text(receiverData.babysitterIName,style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: AppColors.kWhite)),
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
