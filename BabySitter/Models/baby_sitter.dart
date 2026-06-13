import 'package:equatable/equatable.dart';
import 'babysitter_multi_media.dart';

class Babysitter extends Equatable{
  final String id;
  late int canceledRequests;
  late String status;                     // TODO: As It Can Be Updated
  late bool availabilityStatus;                     // TODO: As It Can Be Updated
  final String? fcmToken;
  final String fName;
  final String lname;
  final String email;
  final String phone;
  final String city;
  late List<dynamic> services;           // TODO: As It Can Be Updated
  final String nationality;
  final int pricePerHour;
  final String? bio;
  final BabysitterMedia multiMedia;

  Babysitter({
    required this.id,
    required this.canceledRequests,
    required this.status,
    required this.availabilityStatus,
    required this.fcmToken,
    required this.fName,
    required this.lname,
    required this.email,
    required this.services,
    required this.phone,
    required this.city,
    required this.nationality,
    required this.bio,
    required this.pricePerHour,
    required this.multiMedia
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'canceledRequests': canceledRequests,
      'fcmToken': fcmToken,
      'status': status,
      'fName': fName,
      'lname': lname,
      'services': services,
      'email': email,
      'phone': phone,
      'city': city,
      'availabilityStatus': availabilityStatus,
      'nationality': nationality,
      'bio': bio != null && bio!.isNotEmpty ? bio : null,
      'pricePerHour': pricePerHour,
      'multiMedia': multiMedia.toJson()
    };
  }

  factory Babysitter.fromJson({required dynamic json}) => Babysitter(
    id: json['id'],
    canceledRequests: json['canceledRequests'] ?? 0,
    status: json['status'],
    availabilityStatus: json['availabilityStatus'] ?? true,
    fcmToken: json['fcmToken'],
    fName: json['fName'],
    lname: json['lname'],
    email: json['email'],
    services: json['services'] ?? [],
    phone: json['phone'],
    city: json['city'],
    nationality: json['nationality'],
    multiMedia: BabysitterMedia.fromJson(json: json['multiMedia']),
    bio: json['bio'],
    pricePerHour: json['pricePerHour'],
  );

  @override
  // TODO: implement props
  List<Object?> get props => [id,fName,status,availabilityStatus,services,canceledRequests,lname,email,fcmToken,phone,city,nationality,multiMedia,bio,pricePerHour];
}