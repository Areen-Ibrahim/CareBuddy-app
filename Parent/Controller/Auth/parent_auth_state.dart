import 'package:carebuddy/Core/Constants/enum.dart';

abstract class ParentAuthStates {}

class AuthInitial extends ParentAuthStates {}
class GetParentProfileImage extends ParentAuthStates {}
class ChooseGenderState extends ParentAuthStates {}
class CreateParentAccountState extends ParentAuthStates {
  final ApiRequestStatus status;

  CreateParentAccountState({required this.status});
}

