import 'package:carebuddy/Core/Components/already_have_an_account_row_widget.dart';
import 'package:carebuddy/Core/Components/app_scaffold_widget.dart';
import 'package:carebuddy/Core/Components/custom_btn_widgets.dart';
import 'package:carebuddy/Core/Components/drop_down_widgets.dart';
import 'package:carebuddy/Core/Components/show_snackbar_widget.dart';
import 'package:carebuddy/Core/Constants/constants.dart';
import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Features/Parent/Controller/Auth/parent_auth_state.dart';
import 'package:carebuddy/Features/Shared/View/Screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/Components/txt_field_widget.dart';
import '../../../../Core/Constants/translation_keys.dart';
import '../../../../Core/Theme/colors.dart';
import '../../Controller/Auth/parent_auth_cubit.dart';

class ParentRegisterScreen extends StatefulWidget {
  const ParentRegisterScreen({super.key});

  @override
  State<ParentRegisterScreen> createState() => _ParentRegisterScreenState();
}

class _ParentRegisterScreenState extends State<ParentRegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fNameCtr = TextEditingController();
  final TextEditingController _lNameCtr = TextEditingController();
  final TextEditingController _emailCtr = TextEditingController();
  final TextEditingController _cityCtr = TextEditingController();
  final TextEditingController _phoneCtr = TextEditingController();
  final TextEditingController _passwordCtr = TextEditingController();
  final TextEditingController _locationUrlCtr = TextEditingController();

  @override
  void dispose() {
    _fNameCtr.dispose();
    _lNameCtr.dispose();
    _emailCtr.dispose();
    _cityCtr.dispose();
    _phoneCtr.dispose();
    _locationUrlCtr.dispose();
    _passwordCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      body: BlocBuilder<ParentAuthCubit,ParentAuthStates>(
        builder: (context,state) {
          return Form(
            key: _formKey,
            child: Padding(
              padding: AppConstants.kScaffoldPadding.copyWith(top: context.topPaddingOfScreen + 14),
              child: ListView(
                padding: EdgeInsets.zero.copyWith(bottom: 22),
                children: [
                  Text(TranslationKeys.signUpAsParent.tr(context),textAlign: TextAlign.center,style: TextStyle(fontSize: 30,fontWeight: FontWeight.w400,color: AppColors.kBlack)),
                  22.vrSpace,
                  Center(
                    child: GestureDetector(
                      onTap: ()=> ParentAuthCubit.getInstance(context).getParentProfileImage(),
                      child: Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          Container(
                            height: 110,
                            width: 110,
                            clipBehavior: Clip.hardEdge,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                            ),
                            child: ParentAuthCubit.getInstance(context).parentProfileImage != null ? Image.file(ParentAuthCubit.getInstance(context).parentProfileImage!,fit: BoxFit.cover) : Image.asset("assets/images/account.png",fit: BoxFit.cover),
                          ),
                          Container(
                            height: 30,width: 30,
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.kMain
                            ),
                            child: Image.asset("assets/images/edit.png"),
                          )
                        ],
                      ),
                    ),
                  ),
                  22.vrSpace,
                  Row(
                    spacing: 14,
                    children: [
                      Expanded(
                          child: TextFieldComponentWidget(
                            controller: _fNameCtr,
                            hint: TranslationKeys.firstName.tr(context),
                            maxLength: 50,
                          ),
                      ),
                      Expanded(
                          child: TextFieldComponentWidget(
                            controller: _lNameCtr,
                            hint: TranslationKeys.lastName.tr(context),
                            maxLength: 50,
                          ),
                      ),
                    ],
                  ),
                  EmailTxtFieldWidget(controller: _emailCtr),
                  TxtFieldOfPasswordWidget(controller: _passwordCtr),
                  PhoneTxtFieldWidget(controller: _phoneCtr),
                  StatefulBuilder(
                      builder: (context,setState) {
                        return ChooseCityDropDownWidget(
                          value: _cityCtr.text.isNotEmpty ? _cityCtr.text : null,
                          isRequired: true,
                          onChanged: (String? input){
                            setState((){
                              if( input != null ) {
                                _cityCtr.text = input;
                              }
                            });
                          },
                        );
                      }
                  ),
                  LocationUrlTxtFieldWidget(controller: _locationUrlCtr),
                  Text("${TranslationKeys.gender.tr(context)}* :",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: AppColors.kBlack)),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile.adaptive(
                            value: GenderStatus.Male,
                            contentPadding: EdgeInsets.zero,
                            title: Text(TranslationKeys.male.tr(context)),
                            groupValue: ParentAuthCubit.getInstance(context).genderChosen,
                            activeColor: AppColors.kMain,
                            onChanged: (GenderStatus? value){
                              if( value != null )
                              {
                                ParentAuthCubit.getInstance(context).chooseGender(value);
                              }
                            }
                        ),
                      ),
                      Expanded(
                        child: RadioListTile.adaptive(
                            value: GenderStatus.Female,
                            title: Text(TranslationKeys.female.tr(context)),
                            contentPadding: EdgeInsets.zero,
                            activeColor: AppColors.kMain,
                            groupValue: ParentAuthCubit.getInstance(context).genderChosen,
                            onChanged: (GenderStatus? value){
                              if( value != null )
                                {
                                  ParentAuthCubit.getInstance(context).chooseGender(value);
                                }
                            }
                        ),
                      )
                    ],
                  ),
                  6.vrSpace,
                  BtnWidget(
                      onTap: (){
                        if( _formKey.currentState!.validate() )
                          {
                            if( _cityCtr.text.isNotEmpty) {
                              ParentAuthCubit.getInstance(context).createAccount(city: _cityCtr.text,context: context, email: _emailCtr.text.toLowerCase().trim(), locationUrl: _locationUrlCtr.text.trim(), password: _passwordCtr.text.trim(), fName: _fNameCtr.text.trim(), lname: _lNameCtr.text.trim(), phone: _phoneCtr.text.trim());
                            }
                            else
                              {
                                showSnackBarWidget(message: "${TranslationKeys.pleaseTxt.tr(context)} ${TranslationKeys.chooseYourCity.tr(context)}", successOrNot: false, context: context);
                              }
                          }
                      },
                      showLoading: state is CreateParentAccountState && state.status == ApiRequestStatus.Loading,
                      title: TranslationKeys.register.tr(context)
                  ),
                  AlreadyHaveAnAccountRowWidget(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginScreen(userType: UserType.Parent))))
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
