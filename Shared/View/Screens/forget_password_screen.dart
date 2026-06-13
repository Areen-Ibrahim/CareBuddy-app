import 'package:carebuddy/Core/Components/app_scaffold_widget.dart';
import 'package:carebuddy/Core/Components/txt_field_widget.dart';
import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Constants/images.dart';
import 'package:carebuddy/Features/Shared/Controller/shared_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/Components/custom_btn_widgets.dart';
import '../../../../Core/Constants/constants.dart';
import '../../../../Core/Constants/translation_keys.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SharedCubit sharedCubit = SharedCubit.getInstance(context);
    return AppScaffoldWidget(
      appBar: AppBar(
        title: const Text("Forget Password"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: AppConstants.kScaffoldPadding.copyWith(bottom: 22),
          children: [
            TextFieldComponentWidget(controller: _emailController, hint: TranslationKeys.email.tr(context)),
            8.vrSpace,
            BlocBuilder<SharedCubit,SharedStates>(
              buildWhen: (past,current) => current is SendPasswordResetEmailState,
              builder: (context,state) => BtnWidget(
                minWidth: double.infinity,
                onTap: ()
                {
                  if( _formKey.currentState!.validate() )
                  {
                    sharedCubit.forgetPassword(email: _emailController.text.toLowerCase().trim(),context: context);
                  }
                },
                showLoading: state is SendPasswordResetEmailState && state.status == ApiRequestStatus.Loading,
                title: TranslationKeys.confirm.tr(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}