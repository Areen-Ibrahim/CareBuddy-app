import 'package:carebuddy/Features/BabySitter/Controller/Auth/babysitter_auth_cubit.dart';
import 'package:carebuddy/Core/Components/custom_btn_widgets.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Features/BabySitter/Controller/Auth/babysitter_auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../Core/Components/already_have_an_account_row_widget.dart';
import '../../../../../Core/Components/drop_down_widgets.dart';
import '../../../../../Core/Components/show_snackbar_widget.dart';
import '../../../../../Core/Components/txt_field_widget.dart';
import '../../../../../Core/Constants/enum.dart';
import '../../../../../Core/Constants/translation_keys.dart';
import '../../../../../Core/Theme/colors.dart';
import '../../../../Shared/View/Screens/login_screen.dart';

class PersonalInfoColumnWidget extends StatelessWidget {
  final GlobalKey<FormState> personalInfoFormKey;
  final BabysitterAuthCubit cubit;
  final TextEditingController fNameCtr;
  final TextEditingController lNameCtr;
  final TextEditingController emailCtr;
  final TextEditingController phoneCtr;
  final TextEditingController cityCtr;
  final TextEditingController nationalityCtr;
  final TextEditingController passwordCtr;
  const PersonalInfoColumnWidget({super.key, required this.fNameCtr, required this.lNameCtr, required this.emailCtr, required this.phoneCtr, required this.cityCtr, required this.nationalityCtr, required this.passwordCtr, required this.personalInfoFormKey, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: personalInfoFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(TranslationKeys.personalInformation.tr(context),style: TextStyle(fontSize: 22,color: AppColors.kBlack)),
          14.vrSpace,
          Row(
            children: [
              Expanded(child: TextFieldComponentWidget(controller: fNameCtr, hint: TranslationKeys.firstName.tr(context),maxLength: 50,)),
              14.hrSpace,
              Expanded(child: TextFieldComponentWidget(controller: lNameCtr, hint: TranslationKeys.lastName.tr(context),maxLength: 50,)),
            ],
          ),
          EmailTxtFieldWidget(controller: emailCtr),
          PhoneTxtFieldWidget(controller: phoneCtr),
          StatefulBuilder(
              builder: (context,setState) {
                return ChooseCityDropDownWidget(
                  isRequired: true,
                  value: cityCtr.text.isNotEmpty ? cityCtr.text : null,
                  onChanged: (String? input){
                    setState((){
                      if( input != null ) {
                        cityCtr.text = input;
                      }
                    });
                  },
                );
              }
          ),
          StatefulBuilder(
              builder: (context,setState) {
                return ChooseNationalityDropDownWidget(
                  value: nationalityCtr.text.isNotEmpty ? nationalityCtr.text : null,
                  onChanged: (String? input){
                    setState((){
                      if( input != null ) {
                        nationalityCtr.text = input;
                      }
                    });
                  },
                );
              }
          ),
          TxtFieldOfPasswordWidget(
              controller: passwordCtr,
              txtInputAction: TextInputAction.done
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: BtnWidget(
                onTap: (){
                  if( personalInfoFormKey.currentState?.validate() == true )
                  {
                    if( cityCtr.text.isNotEmpty && nationalityCtr.text.isNotEmpty ) {
                      cubit.changeIndexOfRegisterContentShown(true);
                    }
                    else
                      {
                        showSnackBarWidget(message: "${TranslationKeys.pleaseTxt.tr(context)} ${cityCtr.text.isEmpty ? TranslationKeys.chooseYourCity.tr(context) : TranslationKeys.chooseYourNationality.tr(context)}", successOrNot: false, context: context);
                      }
                  }
                },
                title: TranslationKeys.confirm.tr(context)
            ),
          ),
          AlreadyHaveAnAccountRowWidget(onTap: ()=> Navigator.push(context,MaterialPageRoute(builder: (context)=> const LoginScreen(userType: UserType.Babysitter))))
        ]
      ),
    );
  }
}
