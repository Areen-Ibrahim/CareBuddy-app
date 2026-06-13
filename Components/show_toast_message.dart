import 'package:carebuddy/Core/Theme/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ToastMessageStatus {Success,Warning,Failure}

void showToastMessage({required String message,required ToastMessageStatus status})=> Fluttertoast.showToast(msg: message,backgroundColor: status == ToastMessageStatus.Success ? AppColors.kGreen : status == ToastMessageStatus.Warning ? AppColors.kBlack : AppColors.kRed);