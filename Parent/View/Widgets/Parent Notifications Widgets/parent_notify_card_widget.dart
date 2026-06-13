import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Services/cache_manager_service.dart';
import 'package:carebuddy/Core/Theme/colors.dart';
import 'package:carebuddy/Features/Shared/Models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../Core/Constants/constants.dart';

class NotifyCardWidget extends StatelessWidget {
  final NotificationModel notify;
  const NotifyCardWidget({super.key, required this.notify});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppConstants.kContainerPadding,
      decoration: BoxDecoration(
          borderRadius: AppConstants.kMainRadius,
          color: const Color(0xffF4F4F4)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text(CacheManagerService.readCurrentLanguage() == LanguageName.en.name ? notify.enTxt : notify.arTxt,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: AppColors.kBlack)),
          Align(
            alignment: AlignmentDirectional.topEnd,
            child: Text(DateFormat('dd-MM-yyyy').format(notify.sentAt),style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: AppColors.kBlack)),
          )
        ],
      ),
    );
  }
}
