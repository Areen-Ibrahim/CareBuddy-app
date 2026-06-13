import 'package:equatable/equatable.dart';

class CommentModel extends Equatable{
  final String comment;
  final int rate;

  const CommentModel({required this.rate, required this.comment});

  factory CommentModel.fromJson({required dynamic json})=> CommentModel(comment: json["comment"], rate: json["rate"]);

  Map<String,dynamic> toJson()=> {
    "rate" : rate,
    "comment" : comment
  };

  @override
  // TODO: implement props
  List<Object?> get props => [rate,comment];
}