import 'package:flutter/material.dart';
import '../Constants/constants.dart';
import '../../Features/Shared/Models/message_model.dart';
import '../Theme/colors.dart';

class ReceiverMessageContentCardWidget extends StatelessWidget {
  final MessageModel messageEntity;
  final String? receiverProfileImage;
  final String receiverName;
  const ReceiverMessageContentCardWidget({super.key, required this.messageEntity,required this.receiverProfileImage, required this.receiverName});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 14,
      children: [
        Column(
          spacing: 2,
          children: [
            Container(
              height: 38,width: 38,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: receiverProfileImage != null ? DecorationImage(image: NetworkImage(receiverProfileImage!)) : null,
                  color: AppColors.kGrey
              ),
              child: receiverProfileImage != null ? null : Icon(Icons.person,color: AppColors.kWhite),
            ),
            Text(receiverName,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: AppColors.kMain))
          ],
        ),
        Expanded(
          child: Align(
            alignment: AlignmentDirectional.topStart,
            child: Container(
              padding: AppConstants.kContainerPadding,
              decoration: BoxDecoration(
                  color: AppColors.kMain,
                  boxShadow: [BoxShadow(color: const Color(0xff000000).withOpacity(0.25),blurRadius: 4,spreadRadius: 0,offset: const Offset(0, 4))],
                  borderRadius: AppConstants.kMaxRadius.copyWith(topLeft: const Radius.circular(0))
              ),
              child: Text(messageEntity.message,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14,color: AppColors.kWhite)),
            ),
          ),
        ),
      ],
    );
  }
}

class SenderMessageContentCardWidget extends StatelessWidget {
  final MessageModel messageEntity;
  final String? senderProfileImage;
  final String senderName;
  const SenderMessageContentCardWidget({super.key, required this.messageEntity,required this.senderProfileImage, required this.senderName});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      spacing: 14,
      children: [
        Expanded(
          child: Align(
            alignment: AlignmentDirectional.topEnd,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: AppColors.kWhite,
                  boxShadow: [BoxShadow(color: const Color(0xff000000).withOpacity(0.25),blurRadius: 4,spreadRadius: 0,offset: const Offset(0, 4))],
                  borderRadius: AppConstants.kMaxRadius.copyWith(topRight: const Radius.circular(0))
              ),
              child: Text(messageEntity.message,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14,color: AppColors.kMain)),
            ),
          ),
        ),
        Column(
          spacing: 2,
          children: [
            Container(
              height: 38,width: 38,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: senderProfileImage != null ? DecorationImage(image: NetworkImage(senderProfileImage!)) : null,
                color: Colors.grey.withOpacity(0.5),
              ),
              child: senderProfileImage != null ? null : Icon(Icons.person,color: AppColors.kWhite),
            ),
            Text(senderName,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: AppColors.kMain))
          ],
        )
      ],
    );
  }
}