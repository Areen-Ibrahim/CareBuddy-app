import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carebuddy/Core/Components/custom_btn_widgets.dart';
import 'package:carebuddy/Core/Components/show_awesome_dialog_widget.dart';
import 'package:carebuddy/Core/Constants/constants.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Theme/colors.dart';
import 'package:carebuddy/Features/Shared/View/Screens/login_screen.dart';
import 'package:carebuddy/Features/Shared/View/Widgets/toggle_language_column_widget.dart';
import 'package:flutter/material.dart';
import '../../../../Core/Components/app_scaffold_widget.dart';
import '../../../../Core/Constants/enum.dart';
import '../../../../Core/Constants/translation_keys.dart';

class ChooseUserRoleScreen extends StatefulWidget {
  final bool reachCancelRequestsLimit;
  const ChooseUserRoleScreen({super.key,this.reachCancelRequestsLimit = false});

  @override
  State<ChooseUserRoleScreen> createState() => _ChooseUserRoleScreenState();
}

class _ChooseUserRoleScreenState extends State<ChooseUserRoleScreen> {
  @override
  void initState() {
    if( widget.reachCancelRequestsLimit )
      {
        Future.delayed(Duration(seconds: 1),()=> showAwesomeDialogWidget(title: TranslationKeys.accountBlockedTitle.tr(context),type: DialogType.error,desc: TranslationKeys.babysitterBlockedMessage.tr(context), context: context,showOnlyOkBtn: true));
      }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      body: Column(
        spacing: 22,
        children: [
          Expanded(
            child: Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                Center(
                  child: Image.asset("assets/images/care_buddy.png",height: 272,width: 272,),
                ),
                Padding(
                  padding: AppConstants.kContainerPadding,
                  child: const ToggleLanguageColumnWidget(),
                )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 34,vertical: 46),
            decoration: BoxDecoration(
              color: AppColors.kMain.withOpacity(0.5),
              borderRadius: const BorderRadius.only(topRight: Radius.circular(50),topLeft: Radius.circular(50))
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 22,
              children: [
                Text(TranslationKeys.areYouParentOrBabysitterQuestion.tr(context),style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400,color: AppColors.kWhite,shadows: [Shadow(color: AppColors.kBlack.withOpacity(0.25),offset: const Offset(0, 4),blurRadius: 4)]),),
                Row(
                  spacing: 22,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: BtnWidget(onTap: ()=> context.push(const LoginScreen(userType: UserType.Parent)), title: TranslationKeys.parent.tr(context))),
                    Expanded(child: BtnWidget(onTap: ()=> context.push(const LoginScreen(userType: UserType.Babysitter)), title: TranslationKeys.babysitter.tr(context))),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
