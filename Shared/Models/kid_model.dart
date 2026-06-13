import 'package:equatable/equatable.dart';

class KidModel extends Equatable{
  final int id;
  final String name;
  final String? image;
  final String dateOfBirth;
  final String dietaryRequirements;
  final String notes;
  final String gender;

  const KidModel({
    required this.id,
    required this.name,
    this.image,
    required this.dateOfBirth,
    required this.dietaryRequirements,
    required this.notes,
    required this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'dateOfBirth': dateOfBirth,
      'dietaryRequirements': dietaryRequirements,
      'notes': notes,
      'gender': gender,
    };
  }

  factory KidModel.fromJson({required dynamic json}) => KidModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      dateOfBirth: json['dateOfBirth'],
      dietaryRequirements: json['dietaryRequirements'],
      notes: json['notes'],
      gender: json['gender']
  );

  @override
  // TODO: implement props
  List<Object?> get props => [id,name,image,dateOfBirth,dietaryRequirements,notes,gender];
}