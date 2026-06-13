import 'package:carebuddy/Features/BabySitter/Models/baby_sitter.dart';
import 'package:carebuddy/Features/Parent/Models/parent.dart';
import 'package:carebuddy/Features/Shared/Models/kid_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'comment_model.dart';

class BabysitterRequestModel extends Equatable{
  late String id;
  final DateTime startAt;
  final DateTime endAt;
  late String status;                              // TODO: As Can Modified
  final KidModel childSelected;
  final String? notes;
  final Babysitter babySitter;
  final Parent parent;
  late CommentModel? rateOfParent;                     // TODO: As Can Modified
  late CommentModel? rateOfBabysitter;                     // TODO: As Can Modified

  BabysitterRequestModel({required this.startAt,required this.id,this.rateOfParent,this.rateOfBabysitter,required this.childSelected,required this.endAt,required this.status,required this.babySitter,required this.parent,this.notes});

  factory BabysitterRequestModel.fromJson({required dynamic json})=> BabysitterRequestModel(babySitter: Babysitter.fromJson(json: json["babySitter"]),rateOfParent: json["rateOfParent"] != null ? CommentModel.fromJson(json: json["rateOfParent"]) : null,rateOfBabysitter: json["rateOfBabysitter"] != null ? CommentModel.fromJson(json: json["rateOfBabysitter"]) : null,parent: Parent.fromJson(json: json["parent"]),notes: json["notes"],status: json["status"],startAt: (json['startAt'] as Timestamp).toDate(),id: json['id'],endAt: (json['endAt'] as Timestamp).toDate(), childSelected: KidModel.fromJson(json: json["childSelected"]));

  Map<String,dynamic> toJson()=> {
    "id" : id,
    "parent" : parent.toJson(),
    "babySitter" : babySitter.toJson(),
    "childSelected" : childSelected.toJson(),
    "notes" : notes,
    "status" : status,
    "startAt" : startAt,
    "endAt" : endAt,
    "rateOfParent" : rateOfParent?.toJson(),
    "rateOfBabysitter" : rateOfBabysitter?.toJson(),
  };

  @override
  // TODO: implement props
  List<Object?> get props => [parent,babySitter,childSelected,notes,status,startAt,endAt];
}