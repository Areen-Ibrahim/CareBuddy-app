import 'package:carebuddy/Core/Components/app_scaffold_widget.dart';
import 'package:carebuddy/Core/Components/custom_btn_widgets.dart';
import 'package:carebuddy/Core/Components/show_snackbar_widget.dart';
import 'package:carebuddy/Core/Constants/constants.dart';
import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Constants/images.dart';
import 'package:carebuddy/Features/BabySitter/Controller/Layout/babysitter_cubit.dart';
import 'package:carebuddy/Features/BabySitter/Controller/Layout/babysitter_state.dart';
import 'package:carebuddy/Features/BabySitter/Models/baby_sitter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translator/translator.dart';
import '../../../../Core/Components/txt_field_widget.dart';
import '../../../../Core/Constants/translation_keys.dart';
import '../../../../Core/Theme/colors.dart';

class BabysitterEditProfileScreen extends StatefulWidget {
  final Babysitter babySitter;
  final BabysitterCubit cubit;
  const BabysitterEditProfileScreen({super.key, required this.babySitter, required this.cubit});

  @override
  State<BabysitterEditProfileScreen> createState() => _BabysitterEditProfileScreenState();
}

class _BabysitterEditProfileScreenState extends State<BabysitterEditProfileScreen> {
  final TextEditingController _fNameCtr = TextEditingController();
  final TextEditingController _lNameCtr = TextEditingController();
  final TextEditingController _bioCtr = TextEditingController();

  @override
  void initState() {
    _fNameCtr.text = widget.babySitter.fName;
    _lNameCtr.text = widget.babySitter.lname;
    _bioCtr.text = widget.babySitter.bio ?? "";
    widget.cubit.pricePerHour = widget.babySitter.pricePerHour;
    widget.cubit.babysitterImageFile = null;
    widget.cubit.availabilityStatus = widget.babySitter.availabilityStatus;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appBar: AppBar(title: Text(TranslationKeys.updateProfile.tr(context)),),
      body: BlocBuilder<BabysitterCubit,BabysitterStates>(
        builder: (context,state) {
          return Padding(
            padding: AppConstants.kScaffoldPadding,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: ()=> widget.cubit.pickBabysitterImage(),
                    child: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        Container(
                          height: 110,
                          width: 110,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.kMain)
                          ),
                          child: widget.cubit.babysitterImageFile != null ? Image.file(widget.cubit.babysitterImageFile!,fit: BoxFit.cover) : widget.babySitter.multiMedia.profileImage != null ? Image.network(widget.babySitter.multiMedia.profileImage!,fit: BoxFit.cover,) : Icon(Icons.image,color: AppColors.kGreen,size: 46),
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
                  children: [
                    Expanded(child: TextFieldComponentWidget(controller: _fNameCtr, hint: TranslationKeys.firstName.tr(context),maxLength: 50,)),
                    14.hrSpace,
                    Expanded(child: TextFieldComponentWidget(controller: _lNameCtr, hint: TranslationKeys.lastName.tr(context),maxLength: 50,)),
                  ],
                ),
                TextFieldComponentWidget(controller: _bioCtr,isRequired: false,maxLines: 5, hint: TranslationKeys.bio.tr(context),textInputAction: TextInputAction.done),
                StatefulBuilder(
                    builder: (context,setState) {
                      return SwitchListTile(
                          value: widget.cubit.availabilityStatus,
                          contentPadding: EdgeInsets.zero,
                          activeTrackColor: AppColors.kMain,
                          inactiveTrackColor: AppColors.kGrey,
                          title: Text("${TranslationKeys.availabilityStatus.tr(context)}* ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: AppColors.kBlack)),
                          onChanged: (value){
                            setState((){
                              widget.cubit.availabilityStatus = value;
                            });
                          }
                      );
                    }
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${TranslationKeys.pricePerHour.tr(context)}* ${widget.cubit.pricePerHour != 0 ? "(${widget.cubit.pricePerHour} ${TranslationKeys.sar.tr(context)})" : ""}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: AppColors.kBlack)),
                      Slider.adaptive(
                          value: widget.cubit.pricePerHour.toDouble(),
                          max: 200,
                          min: 0,
                          activeColor: AppColors.kMain,
                          onChanged: (value)=> widget.cubit.changePricePerHour(value.toInt())
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("0 ${TranslationKeys.sar.tr(context)}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: AppColors.kBlack)),
                          Text("200 ${TranslationKeys.sar.tr(context)}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: AppColors.kBlack)),
                        ],
                      )
                    ],
                  ),
                ),
                BtnWidget(
                  onTap: (){
                    if( widget.cubit.babysitterImageFile != null || widget.cubit.availabilityStatus != widget.babySitter.availabilityStatus || _fNameCtr.text != widget.babySitter.fName || _lNameCtr.text != widget.babySitter.lname || _bioCtr.text != widget.babySitter.bio || widget.cubit.pricePerHour != widget.babySitter.pricePerHour )
                    {
                      widget.cubit.updateProfileData(availabilityStatus: widget.cubit.availabilityStatus,context: context,profileImage: widget.cubit.babysitterImageFile,bio: _bioCtr.text,fName: _fNameCtr.text.trim(),lName: _lNameCtr.text.trim(),pricePerHour: widget.cubit.pricePerHour);
                    }
                    else
                      {
                        showSnackBarWidget(message: TranslationKeys.youDidNotChangeAnythingOnYourData.tr(context), successOrNot: true, context: context);
                      }
                  },
                  showLoading: state is UpdateProfileDataState && state.status == ApiRequestStatus.Loading,
                  title: TranslationKeys.confirm.tr(context),
                )
              ],
            ),
          );
        }
      ),
    );
  }
}
