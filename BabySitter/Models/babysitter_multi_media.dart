import 'package:equatable/equatable.dart';

class BabysitterMedia extends Equatable{
  final String identification;
  final String securityClearance;
  final String medicalHistory;
  final String? certificates;
  late String? profileImage;
  late String? introVideo;                 // TODO : As It Can Be Updated

  BabysitterMedia({
    required this.identification,
    required this.securityClearance,
    required this.medicalHistory,
    required this.certificates,
    required this.profileImage,
    required this.introVideo,
  });

  Map<String, dynamic> toJson() {
    return {
      'identification': identification,
      'securityClearance': securityClearance,
      'medicalHistory': medicalHistory,
      'certificates': certificates,
      'profileImage': profileImage,
      'introVideo': introVideo,
    };
  }

  factory BabysitterMedia.fromJson({required dynamic json}) => BabysitterMedia(
    identification: json['identification'],
    securityClearance: json['securityClearance'],
    medicalHistory: json['medicalHistory'],
    certificates: json['certificates'],
    profileImage: json['profileImage'],
    introVideo: json['introVideo'],
  );

  @override
  // TODO: implement props
  List<Object?> get props => [identification,securityClearance,medicalHistory,certificates,profileImage,introVideo];
}