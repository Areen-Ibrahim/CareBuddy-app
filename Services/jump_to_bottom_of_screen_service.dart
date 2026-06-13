import 'package:flutter/material.dart';

class JumpToSpecificOffsetOnScreenService{
  static void screenBottom({required ScrollController controller}){
    if( controller.positions.isNotEmpty )
    {
      controller.animateTo(
        controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }
}