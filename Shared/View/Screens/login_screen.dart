import 'package:carebuddy/Core/Components/already_have_an_account_row_widget.dart';
import 'package:carebuddy/Core/Components/app_scaffold_widget.dart';
import 'package:carebuddy/Core/Components/custom_btn_widgets.dart';
import 'package:carebuddy/Core/Components/txt_field_widget.dart';
import 'package:carebuddy/Core/Constants/constants.dart';
import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Theme/colors.dart';
import 'package:carebuddy/Features/BabySitter/View/Screens/babysitter_register_personal_info_screen.dart';
import 'package:carebuddy/Features/Parent/View/Screens/parent_register_screen.dart';
import 'package:carebuddy/Features/Shared/Controller/shared_cubit.dart';
import 'package:carebuddy/Features/Shared/View/Screens/forget_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Core/Constants/translation_keys.dart';

class LoginScreen extends StatefulWidget {
  final UserType userType;
  const LoginScreen({super.key, required this.userType});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _emailCtr;
  late TextEditingController _passwordCtr;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _emailCtr = TextEditingController();
    _passwordCtr = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailCtr.dispose();
    _passwordCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: AppConstants.kScaffoldPadding.copyWith(bottom: 22),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 22),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Image.asset("assets/images/care_buddy.png"),
                  Text(TranslationKeys.login.tr(context),style: TextStyle(fontSize: 30,color: AppColors.kBlack,fontWeight: FontWeight.w500))
                ],
              ),
            ),
            EmailTxtFieldWidget(
              controller: _emailCtr,
              enableValidation: false,
            ),
            TxtFieldOfPasswordWidget(
                controller: _passwordCtr,
                validator: (input){
                  if( _passwordCtr.text.isNotEmpty && _emailCtr.text.isNotEmpty )
                  {
                    if( !AppConstants.kPasswordRegExp.hasMatch(_passwordCtr.text) && AppConstants.kEmailRegex.hasMatch(_emailCtr.text.trim()) )
                    {
                      return TranslationKeys.passwordNotStrongEnough.tr(context);
                    }
                    else if( AppConstants.kPasswordRegExp.hasMatch(_passwordCtr.text) && !AppConstants.kEmailRegex.hasMatch(_emailCtr.text.trim()) )
                      {
                        return TranslationKeys.enterValidEmail.tr(context);
                      }
                    else if( AppConstants.kPasswordRegExp.hasMatch(_passwordCtr.text) && AppConstants.kEmailRegex.hasMatch(_emailCtr.text.trim()) )
                    {
                      return null;
                    }
                    else
                    {
                      return TranslationKeys.invalidEmailOrPassword.tr(context);
                    }
                  }
                  else
                  {
                    if( _passwordCtr.text.isEmpty )
                      {
                        return "${TranslationKeys.enter.tr(context)} ${TranslationKeys.password.tr(context)}";
                      }
                    else
                      {
                        return TranslationKeys.enterEmail.tr(context);
                      }
                  }
                },
                txtInputAction: TextInputAction.done
            ),
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: GestureDetector(
                onTap: ()=> context.push(const ForgetPasswordScreen()),
                child: Text(TranslationKeys.forgetPassword.tr(context),style: TextStyle(fontSize: 14,color: AppColors.kRed,fontWeight: FontWeight.w500)),
              ),
            ),
            14.vrSpace,
            BlocBuilder<SharedCubit,SharedStates>(
              buildWhen: (past,current)=> current is SignInState,
              builder: (context,state) {
                return BtnWidget(
                    onTap: (){
                      if( _formKey.currentState!.validate() )
                        {
                          SharedCubit.getInstance(context).signIn(email: _emailCtr.text.trim().toLowerCase(), context: context, userType: widget.userType, password: _passwordCtr.text.trim());
                        }
                    },
                    showLoading: state is SignInState && state.status == ApiRequestStatus.Loading,
                    title: TranslationKeys.signIn.tr(context)
                );
              }
            ),
            NeedToCreateAnAccountRowWidget(
              onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> widget.userType == UserType.Parent ? const ParentRegisterScreen() : const BabysitterRegisterScreen())),
            ),
          ],
        ),
      ),
    );
  }
}
