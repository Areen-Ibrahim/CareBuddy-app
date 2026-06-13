import 'package:carebuddy/Core/Components/app_scaffold_widget.dart';
import 'package:carebuddy/Core/Constants/constants.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Features/BabySitter/Models/baby_sitter.dart';
import 'package:flutter/material.dart';
import '../../../../Core/Components/babysitter_data_list_view_widget.dart';
import '../../../../Core/Constants/translation_keys.dart';

class BabysitterDetailsScreen extends StatelessWidget {
  final Babysitter babySitter;
  const BabysitterDetailsScreen({super.key, required this.babySitter});

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appBar: AppBar(title: Text(TranslationKeys.babysitterDetails.tr(context)),),
      body: Padding(
        padding: AppConstants.kScaffoldPadding,
        child: BabysitterDataListViewWidget(babySitter: babySitter),
      ),
    );
  }
}
