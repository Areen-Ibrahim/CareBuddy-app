import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:flutter/material.dart';
import '../Constants/constants.dart';
import '../Constants/translation_keys.dart';
import '../Theme/colors.dart';

class ChooseCityDropDownWidget extends StatelessWidget {
  final String? value;
  final bool isRequired;
  final Function(String?)? onChanged;
  const ChooseCityDropDownWidget({super.key, this.value, this.onChanged, required this.isRequired});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: AppConstants.kMainRadius,
          border: AppConstants.kMainBorder
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(
            TranslationKeys.chooseYourCity.tr(context) + (isRequired ? "*" : ""),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xff49454F),
            ),
          ),
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.kBlack
          ),
          items: AppConstants.saudiArabiaCities.map(
                (city) => DropdownMenuItem(
              value: city,
              child: Text(city.tr(context)),
            ),
          ).toList(),
          padding: EdgeInsets.zero,
          value: value,
          isExpanded: true,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class ChooseNationalityDropDownWidget extends StatelessWidget {
  final String? value;
  final Function(String?)? onChanged;
  const ChooseNationalityDropDownWidget({super.key, this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: AppConstants.kMainRadius,
          border: AppConstants.kMainBorder
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(
            TranslationKeys.chooseYourNationality.tr(context),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xff49454F),
            ),
          ),
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.kBlack
          ),
          items: AppConstants.countries.map(
                (country) => DropdownMenuItem(
              value: country,
              child: Text(country.tr(context)),
            ),
          ).toList(),
          padding: EdgeInsets.zero,
          value: value,
          isExpanded: true,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
