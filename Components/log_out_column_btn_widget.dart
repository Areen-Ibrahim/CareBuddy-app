import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carebuddy/Core/Components/show_awesome_dialog_widget.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:flutter/material.dart';
import '../Constants/translation_keys.dart';
import '../Theme/colors.dart';

class LogOutColumnBtnWidget extends StatelessWidget {
  final Function()? onTap;
  const LogOutColumnBtnWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showAwesomeDialogWidget(
        title: TranslationKeys.logOut.tr(context),
        desc: TranslationKeys.areYouWantLogOut.tr(context),
        context: context,
        type: DialogType.warning,
        okBtnMethod: onTap,
      ),
      child: Column(
        spacing: 6,
        children: [
          Icon(Icons.logout, color: AppColors.kBlack),
          Text(
            TranslationKeys.logOut.tr(context),
            style: TextStyle(
              fontSize: 16,
              color: AppColors.kBlack,
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
    );
  }
}
