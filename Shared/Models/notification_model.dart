import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable{
  final String enTxt;
  final String arTxt;
  final bool seen;
  final DateTime sentAt;

  const NotificationModel({required this.arTxt,required this.enTxt, required this.seen, required this.sentAt});

  factory NotificationModel.fromJson({required dynamic json})=> NotificationModel(arTxt: json["arTxt"],seen: json["seen"],sentAt: (json['sentAt'] as Timestamp).toDate(), enTxt: json["enTxt"]);

  Map<String,dynamic> toJson()=> {
    "enTxt" : enTxt,
    "arTxt" : arTxt,
    "sentAt" : sentAt,
    "seen" : seen
  };

  @override
  // TODO: implement props
  List<Object?> get props => [enTxt,seen,sentAt,arTxt];
}