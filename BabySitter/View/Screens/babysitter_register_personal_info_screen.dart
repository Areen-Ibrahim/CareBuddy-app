import 'package:carebuddy/Core/Components/app_scaffold_widget.dart';
import 'package:carebuddy/Features/BabySitter/Controller/Auth/babysitter_auth_cubit.dart';
import 'package:carebuddy/Features/BabySitter/Controller/Auth/babysitter_auth_state.dart';
import 'package:carebuddy/Features/BabySitter/View/Widgets/Register%20Widgets/identification_and_security_column_widget.dart';
import 'package:carebuddy/Features/BabySitter/View/Widgets/Register%20Widgets/personal_info_column_widget.dart';
import 'package:carebuddy/Features/BabySitter/View/Widgets/Register%20Widgets/professional_info_column_widget.dart';
import 'package:carebuddy/Features/BabySitter/View/Widgets/Register%20Widgets/profile_customization_column_widget.dart';
import 'package:carebuddy/Features/BabySitter/View/Widgets/Register%20Widgets/register_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../Core/Constants/constants.dart';

class BabysitterRegisterScreen extends StatefulWidget {
  const BabysitterRegisterScreen({super.key});

  @override
  State<BabysitterRegisterScreen> createState() => _BabysitterRegisterScreenState();
}

class _BabysitterRegisterScreenState extends State<BabysitterRegisterScreen> {
  final GlobalKey<FormState> _personalInfoFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _profileCustomizationFormKey = GlobalKey<FormState>();
  final TextEditingController _fNameCtr = TextEditingController();
  final TextEditingController _lNameCtr = TextEditingController();
  final TextEditingController _emailCtr = TextEditingController();
  final TextEditingController _phoneCtr = TextEditingController();
  final TextEditingController _cityCtr = TextEditingController();
  final TextEditingController _nationalityCtr = TextEditingController();
  final TextEditingController _passwordCtr = TextEditingController();
  final TextEditingController _bioCtr = TextEditingController();

  @override
  void dispose() {
    _fNameCtr.dispose();
    _lNameCtr.dispose();
    _emailCtr.dispose();
    _phoneCtr.dispose();
    _cityCtr.dispose();
    _nationalityCtr.dispose();
    _passwordCtr.dispose();
    _bioCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if( BabysitterAuthCubit.getInstance(context).indexOfRegisterContentShown > 0 )
          {
            BabysitterAuthCubit.getInstance(context).changeIndexOfRegisterContentShown(false);
            return false;
          }
        else
          {
            return true;
          }
      },
      child: AppScaffoldWidget(
        body: Column(
            children: [
              RegisterHeaderWidget(cubit: BabysitterAuthCubit.getInstance(context)),
              Expanded(
                child: SingleChildScrollView(
                  padding: AppConstants.kScaffoldPadding.copyWith(bottom: 22,top: 0),
                  child: BlocBuilder<BabysitterAuthCubit,BabysitterAuthStates>(
                    buildWhen: (past,current) => current is ChangeIndexOfRegisterContentShownState,
                    builder: (context,state){
                      if( BabysitterAuthCubit.getInstance(context).indexOfRegisterContentShown == 0 )
                      {
                        return PersonalInfoColumnWidget(cubit: BabysitterAuthCubit.getInstance(context),personalInfoFormKey: _personalInfoFormKey,fNameCtr: _fNameCtr, lNameCtr: _lNameCtr, emailCtr: _emailCtr, phoneCtr: _phoneCtr, cityCtr: _cityCtr, nationalityCtr: _nationalityCtr, passwordCtr: _passwordCtr);
                      }
                      else if ( BabysitterAuthCubit.getInstance(context).indexOfRegisterContentShown == 1 )
                      {
                        return IdentificationAndSecurityColumnWidget(cubit: BabysitterAuthCubit.getInstance(context));
                      }
                      else if ( BabysitterAuthCubit.getInstance(context).indexOfRegisterContentShown == 2 )
                      {
                        return ProfessionalInfoColumnWidget(cubit: BabysitterAuthCubit.getInstance(context));
                      }
                      else
                      {
                        return ProfileCustomizationColumnWidget(fNameCtr: _fNameCtr, lNameCtr: _lNameCtr, emailCtr: _emailCtr, phoneCtr: _phoneCtr, cityCtr: _cityCtr, nationalityCtr: _nationalityCtr, passwordCtr: _passwordCtr,cubit: BabysitterAuthCubit.getInstance(context),bioCtr: _bioCtr,profileCustomizationFormKey: _profileCustomizationFormKey);
                      }
                    },
                  ),
                ),
              ),
            ]
        )
      ),
    );
  }
}
