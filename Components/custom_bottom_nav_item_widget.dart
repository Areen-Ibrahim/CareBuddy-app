import 'package:flutter/material.dart';
import '../Theme/colors.dart';

class CustomBottomNavigationItem{
  static BottomNavigationBarItem show({required int currentIndex, required int index,required imageName,required String title}) {
    return BottomNavigationBarItem(
      icon: Image.asset(
        "assets/images/$imageName.png",
        height: 22,
        width: 22,
        fit: BoxFit.fill,
        color: currentIndex == index ? AppColors.kMain : AppColors.kGrey,
      ),
      label: title,
    );
  }
}

