import 'package:flutter/material.dart';
import '../Theme/colors.dart';

class EmptyWidget extends StatelessWidget {
  final String? txt;
  final double? txtSize;
  final Color? txtColor;
  const EmptyWidget({super.key, required this.txt, this.txtSize, this.txtColor});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(txt ?? "",style: TextStyle(fontSize: txtSize ?? 16,fontWeight: FontWeight.w500,color: txtColor ?? AppColors.kBlack)));
  }
}
