import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MessageModel extends Equatable{
  final String message;
  final DateTime sentAt;
  final String senderID;
  final String senderName;
  final String receiverName;

  const MessageModel({required this.message,required this.senderName,required this.sentAt,required this.senderID,required this.receiverName});

  factory MessageModel.fromJson({required dynamic json})=> MessageModel(senderName: json['senderName'],receiverName: json['receiverName'],message: json['message'], sentAt: (json['sentAt'] as Timestamp).toDate(), senderID: json['senderID']);

  Map<String,dynamic> toJson(){
    return {
      'message' : message,
      'sentAt' : sentAt,
      'senderName' : senderName,
      'receiverName' : receiverName,
      'senderID' : senderID,
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [message,sentAt,senderName,receiverName,senderID];

}