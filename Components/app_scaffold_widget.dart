import 'package:carebuddy/Core/Theme/colors.dart';
import 'package:flutter/material.dart';

class AppScaffoldWidget extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;
  final bool showBackgroundImage;
  const AppScaffoldWidget({super.key, this.appBar,this.showBackgroundImage = true, required this.body, this.bottomNavigationBar});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: showBackgroundImage ? BoxDecoration(
        color: AppColors.kWhite,
          image: DecorationImage(image: AssetImage("assets/images/background_image.png"),fit: BoxFit.cover)
      ) : null,
      child: SafeArea(
        child: Scaffold(
          appBar: appBar,
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: true,
          body: body,
          bottomNavigationBar: bottomNavigationBar,
        ),
      ),
    );
  }
}
