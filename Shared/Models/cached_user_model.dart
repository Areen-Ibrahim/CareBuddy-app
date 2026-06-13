import 'package:equatable/equatable.dart';

class CachedUserEntity extends Equatable{
  final String type;
  final String id;

  const CachedUserEntity({required this.type, required this.id});

  factory CachedUserEntity.fromJson({required dynamic json})=> CachedUserEntity(type: json["type"], id: json["id"]);

  Map<String,dynamic> toJson()=> {
    "id" : id,
    "type" : type
  };

  @override
  // TODO: implement props
  List<Object?> get props => [id,type];
}