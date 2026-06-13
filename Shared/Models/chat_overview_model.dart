import 'package:equatable/equatable.dart';

class BabysitterChatOverviewModel extends Equatable{
  final String babysitterID;
  final String babysitterIName;
  late String lastMessage;                     // TODO : As it can be Updated
  final String? babysitterIImage;

  BabysitterChatOverviewModel({required this.babysitterID, required this.babysitterIName, required this.lastMessage,required this.babysitterIImage});

  Map<String, dynamic> toJson() {
    return {
      'babysitterID': babysitterID,
      'babysitterIName': babysitterIName,
      'lastMessage': lastMessage,
      'babysitterIImage': babysitterIImage,
    };
  }

  factory BabysitterChatOverviewModel.fromJson({required dynamic json}) => BabysitterChatOverviewModel(
    babysitterID: json['babysitterID'],
    babysitterIImage: json['babysitterIImage'],
    lastMessage: json['lastMessage'],
    babysitterIName: json['babysitterIName'],
  );

  @override
  // TODO: implement props
  List<Object?> get props => [babysitterID,babysitterIImage,babysitterIName,lastMessage];
}

class ParentChatOverviewModel extends Equatable {
  final String parentID;
  final String parentName;
  late String lastMessage;                       // TODO : As it can be Updated
  final String? parentImage;

  ParentChatOverviewModel({required this.parentID, required this.parentName, required this.lastMessage,required this.parentImage});

  Map<String, dynamic> toJson() {
    return {
      'parentID': parentID,
      'parentName': parentName,
      'lastMessage': lastMessage,
      'parentImage': parentImage,
    };
  }

  factory ParentChatOverviewModel.fromJson({required dynamic json}) => ParentChatOverviewModel(
    parentID: json['parentID'],
    parentImage: json['parentImage'],
    lastMessage: json['lastMessage'],
    parentName: json['parentName'],
  );

  @override
  // TODO: implement props
  List<Object?> get props => [parentName,parentID,parentImage,lastMessage];
}