import 'package:flutter/material.dart';
import 'colors.dart';

class AppTheme{
  static ThemeData light = ThemeData(
      scaffoldBackgroundColor: AppColors.kWhite,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.kWhite,
          elevation: 0,
      ),
      primaryColor: AppColors.kMain,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.kMain),
      appBarTheme: AppBarTheme(
          foregroundColor: AppColors.kBlack,
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: AppColors.kBlack),
          centerTitle: true,
          scrolledUnderElevation: 0,
      )
  );
}