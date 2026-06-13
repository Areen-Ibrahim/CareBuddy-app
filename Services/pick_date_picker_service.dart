import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PickDateService{
  static Future<String?> call({required BuildContext context, DateTime? firstData, DateTime? lastData}) async {
    try{
      DateTime? dateChosen = await showDatePicker(
          context: context,
          firstDate: firstData ?? DateTime(1900),
          lastDate: lastData ?? DateTime.now().add(const Duration(days: (365*24))),
          initialDate: DateTime.now()
      );
      return DateFormat('dd-MM-yyyy').format(dateChosen!);
    }
    catch(e){
      return null;
    }
  }
}

class PickTimeService{
  static Future<String?> call(BuildContext context) async {
    try{
      TimeOfDay? timeChosen = await showTimePicker(context: context,initialTime: TimeOfDay.now());
      final DateTime now = DateTime.now();
      return DateFormat.Hm().format(DateTime(now.year, now.month, now.day, timeChosen!.hour, timeChosen.minute));
    }
    catch(e){
      return null;
    }
  }
}