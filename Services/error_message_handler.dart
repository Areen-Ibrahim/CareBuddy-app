import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Constants/translation_keys.dart';
import 'package:flutter/cupertino.dart';

class ErrorMessageHandler{
  static String error(String error,BuildContext context){
    if( error.replaceAll("-", " ").toUpperCase() == "INVALID CREDENTIAL" )
      {
        return TranslationKeys.inCorrectEmailOrPassword.tr(context);
      }
    else
      {
        return error;
      }
  }
}