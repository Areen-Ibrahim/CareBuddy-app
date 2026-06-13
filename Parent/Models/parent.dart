import 'package:carebuddy/Features/Shared/Models/kid_model.dart';
import 'package:equatable/equatable.dart';

class Parent extends Equatable{
  final String id;
  final String? fcmToken;
  final String fName;
  final String lname;
  final String email;
  late int canceledRequests;
  final String phone;
  final String city;
  final String locationUrl;
  final String profileImage;
  final String gender;
  final List<dynamic> favorites;
  final List<KidModel> kids;

  Parent({
    required this.id,
    required this.fcmToken,
    required this.canceledRequests,
    required this.fName,
    required this.lname,
    required this.email,
    required this.phone,
    required this.city,
    required this.locationUrl,
    required this.gender,
    required this.profileImage,
    required this.favorites,
    required this.kids
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fcmToken': fcmToken,
      'canceledRequests': canceledRequests,
      'fName': fName,
      'lname': lname,
      'email': email,
      'phone': phone,
      'city': city,
      'locationUrl': locationUrl,
      'gender': gender,
      'profileImage': profileImage,
      'favorites': favorites,
      'kids': kids.map((kid)=> kid.toJson()).toList()
    };
  }

  factory Parent.fromJson({required dynamic json}) => Parent(
    id: json['id'],
    fcmToken: json['fcmToken'], canceledRequests: json['canceledRequests'] ?? 0,
    fName: json['fName'],
    lname: json['lname'],
    email: json['email'],
    phone: json['phone'],
    city: json['city'],
    locationUrl: json['locationUrl'],
    gender: json['gender'],
    profileImage: json['profileImage'],
    favorites: json['favorites'],
    kids: List<KidModel>.from(json['kids'].map((kid)=> KidModel.fromJson(json: kid)))
  );

  @override
  // TODO: implement props
  List<Object?> get props => [id,canceledRequests,fName,lname,email,phone,city,fcmToken,locationUrl,gender,profileImage,favorites,kids];
}