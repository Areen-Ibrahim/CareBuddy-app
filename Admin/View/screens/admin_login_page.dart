import 'package:carebuddy/Core/Components/custom_btn_widgets.dart';
import 'package:carebuddy/Core/Components/txt_field_widget.dart';
import 'package:carebuddy/Core/Constants/constants.dart';
import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Theme/colors.dart';
import 'package:carebuddy/Features/Admin/Controller/admin_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../Core/Constants/translation_keys.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
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
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/images/background_image.png"),fit: BoxFit.cover)
          ),
          child: ListView(
            padding: AppConstants.kScaffoldPadding.copyWith(bottom: 22),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 22),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Image.asset("assets/images/care_buddy.png"),
                    Text(TranslationKeys.loginAsAdmin.tr(context),style: TextStyle(fontSize: 30,color: AppColors.kBlack,fontWeight: FontWeight.w500))
                  ],
                ),
              ),
              EmailTxtFieldWidget(controller: _emailCtr),
              TxtFieldOfPasswordWidget(controller: _passwordCtr,txtInputAction: TextInputAction.done),
              BlocBuilder<AdminCubit,AdminStates>(
                  buildWhen: (past,current)=> current is SignInAsAdminState,
                  builder: (context,state) {
                    return BtnWidget(
                        onTap: (){
                          if( _formKey.currentState!.validate() )
                          {
                            AdminCubit.getInstance(context).signIn(email: _emailCtr.text.trim().toLowerCase(), context: context, password: _passwordCtr.text.trim());
                          }
                        },
                        showLoading: state is SignInAsAdminState && state.status == ApiRequestStatus.Loading,
                        title: TranslationKeys.signIn.tr(context)
                    );
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
