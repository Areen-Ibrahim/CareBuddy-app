import 'package:flutter/material.dart';
import '../Services/localizations.dart';

extension DoubleOpetaions on int {
  // TODO: Use it with SizedBox Widget
  Widget get vrSpace => SizedBox(height: toDouble());

  Widget get hrSpace => SizedBox(width: toDouble());
}

extension ContextExtensions on BuildContext {
  double get topPaddingOfScreen => MediaQuery.of(this).padding.top;
}

extension DateTimeProcess on DateTime {
  bool get isPast => this.isBefore(DateTime.now());
}

extension RoutingExtensions on BuildContext {
  dynamic get pop => Navigator.pop(this);
  dynamic push (Widget widget)=> Navigator.push(this, MaterialPageRoute(builder: (context)=> widget));
  dynamic pushAndRemovePreviousRoutes (Widget widget)=> Navigator.pushAndRemoveUntil(this, MaterialPageRoute(builder: (context)=> widget),(_)=> false);
  dynamic pushNamed (String routeKey)=> Navigator.pushNamed(this, routeKey);
  dynamic pushNamedAndRemovePreviousRoutes (String routeKey)=> Navigator.pushNamedAndRemoveUntil(this, routeKey,(_)=> false);
}

extension TranslateKey on String{
  String tr(BuildContext context)=> MyLocalizations.getInstance(context: context)!.getValue(this);
  String en(BuildContext context)=> MyLocalizations.getValueFromLanguage(this, "en");
  String ar(BuildContext context)=> MyLocalizations.getValueFromLanguage(this, "ar");
}