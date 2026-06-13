import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:flutter/material.dart';
import '../Constants/constants.dart';
import '../Constants/translation_keys.dart';
import '../Services/pick_date_picker_service.dart';
import '../Theme/colors.dart';

class TextFieldComponentWidget extends StatelessWidget {
  final String hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final bool? isPassword;
  final bool? disableMarginOnBottom;
  final int? maxLength;
  final int? maxLines;
  final bool? enabled;
  final String? labelTxt;
  final String? validateTxt;
  final bool? disabled;
  final bool isRequired;
  final Function(String)? onChanged;
  const TextFieldComponentWidget({
    super.key,
    this.textInputType,
    this.enabled,
    this.textInputAction,
    required this.controller,
    this.isPassword,
    this.disabled,
    this.isRequired = true,
    required this.hint,
    this.validator,
    this.maxLength,
    this.maxLines,
    this.labelTxt,
    this.validateTxt,
    this.prefixIcon,
    this.onChanged,
    this.disableMarginOnBottom,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: disableMarginOnBottom != null ? 0 : 14),
      child: TextFormField(
        controller: controller,
        keyboardType: textInputType ?? TextInputType.text,
        obscureText: isPassword ?? false,
        textInputAction: textInputAction ?? TextInputAction.next,
        maxLength: maxLength,
        maxLines: maxLines ?? 1,
        onChanged: onChanged,
        autofocus: false,
        enabled: disabled != null ? false : true,
        style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.kBlack),
        validator: validator != null
            ? validator!
            : (input) {
                if (input == null || (input.isEmpty)) {
                  return "${TranslationKeys.enter.tr(context)} ${validateTxt ?? hint}";
                } else {
                  return null;
                }
              },

        decoration: InputDecoration(
          contentPadding: AppConstants.kContainerPadding,
          enabledBorder: AppConstants.kEnabledInputBorder,
          focusedBorder: AppConstants.kFocusedInputBorder,
          fillColor: Colors.grey.shade200,
          filled: true,
          labelText: labelTxt,
          enabled: enabled ?? true,
          errorBorder: AppConstants.kEnabledInputBorder,
          disabledBorder: AppConstants.kEnabledInputBorder,
          focusedErrorBorder: AppConstants.kEnabledInputBorder,
          hintText: hint + (isRequired ? "*" : ""),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          hintStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xff49454F)),
        ),
      ),
    );
  }
}

class TxtFieldOfPasswordWidget extends StatelessWidget {
  final TextEditingController controller;
  final TextInputAction? txtInputAction;
  final String? Function(String?)? validator;
  const TxtFieldOfPasswordWidget({super.key, required this.controller, this.txtInputAction, this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFieldComponentWidget(
        hint: TranslationKeys.password.tr(context),
        validator: validator ?? (input){
          if( controller.text.isNotEmpty )
          {
            if( controller.text.length < 8 )
            {
              return TranslationKeys.passwordLengthRequirement.tr(context);
            }
            else if( AppConstants.kPasswordRegExp.hasMatch(controller.text) )
            {
              return null;
            }
            else
            {
              return TranslationKeys.passwordNotStrongEnough.tr(context);
            }
          }
          else
          {
            return "${TranslationKeys.enter.tr(context)} ${TranslationKeys.password.tr(context)}";
          }
        },
        textInputAction: txtInputAction ?? TextInputAction.done,
        controller: controller,
        isPassword: true
    );
  }
}

class UploadMediaTextFieldWidget extends StatelessWidget {
  final String baseName;
  const UploadMediaTextFieldWidget({super.key, required this.baseName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: AppConstants.kMainRadius,
          border: AppConstants.kMainBorder,
          color: AppColors.kGrey),
      child: Text(baseName,
          maxLines: 1,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.kBlack),
          overflow: TextOverflow.ellipsis),
    );
  }
}

class EmailTxtFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final bool enableValidation;
  const EmailTxtFieldWidget({super.key, required this.controller, this.enableValidation = true});

  @override
  Widget build(BuildContext context) {
    return TextFieldComponentWidget(
        controller: controller,
        validator: (input) {
          if( enableValidation )
          {
            if (input == null || (input.isEmpty)) {
              return TranslationKeys.enterEmail.tr(context);
            } else if (!AppConstants.kEmailRegex.hasMatch(controller.text.trim())) {
              return TranslationKeys.enterValidEmail.tr(context);
            } else {
              return null;
            }
          }
          else
            {
              return null;
            }
        },
        hint: TranslationKeys.email.tr(context));
  }
}

class PhoneTxtFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  const PhoneTxtFieldWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFieldComponentWidget(
        controller: controller,
        validator: (input) {
          if (input == null || (input.isEmpty)) {
            return TranslationKeys.enterPhoneNumber.tr(context);
          } else if (!AppConstants.kMobileRegex.hasMatch(controller.text)) {
            return TranslationKeys.enterValidPhoneNumber.tr(context);
          } else {
            return null;
          }
        },
        hint: TranslationKeys.phoneNumber.tr(context));
  }
}

class LocationUrlTxtFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  const LocationUrlTxtFieldWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFieldComponentWidget(
        controller: controller,
        validator: (input) {
          if (input == null || (input.isEmpty)) {
            return TranslationKeys.enterLocationUrl.tr(context);
          } else if (!AppConstants.kGoogleMapsLinkRegex
              .hasMatch(controller.text)) {
            return TranslationKeys.enterValidLocationUrl.tr(context);
          } else {
            return null;
          }
        },
        labelTxt: TranslationKeys.locationUrl.tr(context) + "*",
        hint: "ex: past Google maps link : https://www.google.com/maps?q=37.7749,-122.4194");
  }
}

class DateOrTimeTxtFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final bool dateNotTime;
  final DateTime? firstData;
  final DateTime? lastData;
  const DateOrTimeTxtFieldWidget({super.key, required this.controller, required this.title, required this.dateNotTime, this.firstData, this.lastData});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: GestureDetector(
        onTap: () {
          if (dateNotTime) {
            PickDateService.call(context : context,firstData: firstData,lastData: lastData).then((pickedDate) async {
              if (pickedDate != null) {
                controller.text = pickedDate;
              }
            });
          } else {
            PickTimeService.call(context).then((pickedTime) async {
              if (pickedTime != null) {
                controller.text = pickedTime;
              }
            });
          }
        },
        child: TextFormField(
            enabled: false,
            keyboardType: TextInputType.datetime,
            textInputAction: TextInputAction.done,
            controller: controller,
            validator: (input) {
              if (input == null || (input.isEmpty)) {
                return "${TranslationKeys.select.tr(context)} $title.";
              } else {
                return null;
              }
            },
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.kBlack),
            decoration: InputDecoration(
              contentPadding: AppConstants.kContainerPadding,
              fillColor: Colors.grey.shade200,
              filled: true,
              enabledBorder: AppConstants.kEnabledInputBorder,
              disabledBorder: AppConstants.kEnabledInputBorder,
              focusedBorder: AppConstants.kFocusedInputBorder,
              errorBorder: AppConstants.kErrorInputBorder,
              focusedErrorBorder: AppConstants.kErrorInputBorder,
              hintStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff49454F)),
              hintText: title + "*",
            )),
      ),
    );
  }
}


