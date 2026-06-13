import 'package:carebuddy/Core/Components/app_scaffold_widget.dart';
import 'package:carebuddy/Core/Components/custom_btn_widgets.dart';
import 'package:carebuddy/Core/Constants/constants.dart';
import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Features/Parent/Controller/Layout/parents_cubit.dart';
import 'package:carebuddy/Features/Parent/Controller/Layout/parents_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/Components/drop_down_widgets.dart';
import '../../../../Core/Components/show_snackbar_widget.dart';
import '../../../../Core/Components/txt_field_widget.dart';
import '../../../../Core/Constants/translation_keys.dart';
import '../../../../Core/Theme/colors.dart';

class ParentEditProfileScreen extends StatefulWidget {
  final ParentsCubit cubit;
  const ParentEditProfileScreen({super.key, required this.cubit});

  @override
  State<ParentEditProfileScreen> createState() => _ParentEditProfileScreenState();
}

class _ParentEditProfileScreenState extends State<ParentEditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fNameCtr = TextEditingController();
  final TextEditingController _lNameCtr = TextEditingController();
  final TextEditingController _phoneCtr = TextEditingController();
  final TextEditingController _cityCtr = TextEditingController();
  final TextEditingController _locationUrlCtr = TextEditingController();

  @override
  void initState() {
    widget.cubit.parentImageFile = null;
    _phoneCtr.text = widget.cubit.myData!.phone;
    _fNameCtr.text = widget.cubit.myData!.fName;
    _lNameCtr.text = widget.cubit.myData!.lname;
    _cityCtr.text = widget.cubit.myData!.city;
    _locationUrlCtr.text = widget.cubit.myData!.locationUrl;
    super.initState();
  }

  @override
  void dispose() {
    _fNameCtr.dispose();
    _lNameCtr.dispose();
    _phoneCtr.dispose();
    _cityCtr.dispose();
    _locationUrlCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appBar: AppBar(title: Text(TranslationKeys.updateProfile.tr(context))),
      body: BlocBuilder<ParentsCubit,ParentsStates>(
        builder: (context,state) {
          return Form(
            key: _formKey,
            child: Padding(
              padding: AppConstants.kScaffoldPadding.copyWith(top: context.topPaddingOfScreen + 14),
              child: ListView(
                padding: EdgeInsets.zero.copyWith(bottom: 22),
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: ()=> widget.cubit.chooseParentImageFile(),
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
                            child: widget.cubit.parentImageFile != null ? Image.file(widget.cubit.parentImageFile!,fit: BoxFit.cover) : Image.network(widget.cubit.myData!.profileImage,fit: BoxFit.cover),
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
                      Expanded(child: TextFieldComponentWidget(controller: _fNameCtr, hint: TranslationKeys.firstName.tr(context),maxLength: 50,)),
                      Expanded(child: TextFieldComponentWidget(controller: _lNameCtr, hint: TranslationKeys.lastName.tr(context),maxLength: 50,)),
                    ],
                  ),
                  PhoneTxtFieldWidget(controller: _phoneCtr),
                  StatefulBuilder(
                    builder: (context,setState) {
                      return ChooseCityDropDownWidget(
                        isRequired: true,
                        value: _cityCtr.text.isNotEmpty ? _cityCtr.text : null,
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
                  14.vrSpace,
                  BtnWidget(
                      onTap: (){
                        if( _formKey.currentState!.validate() )
                          {
                            if( _cityCtr.text.isNotEmpty )
                              {
                                widget.cubit.editParentData(context: context, locationUrl: _locationUrlCtr.text.trim(),fName: _fNameCtr.text.trim(), lname: _lNameCtr.text.trim(), phone: _phoneCtr.text.trim(), city: _cityCtr.text.trim());
                              }
                            else
                              {
                                showSnackBarWidget(message: "${TranslationKeys.pleaseTxt.tr(context)} ${TranslationKeys.chooseYourCity.tr(context)}", successOrNot: false, context: context);
                              }
                          }
                      },
                      showLoading: state is EditParentProfileState && state.status == ApiRequestStatus.Loading,
                      title: TranslationKeys.update.tr(context)
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
