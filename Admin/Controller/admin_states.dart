part of 'admin_cubit.dart';

abstract class AdminStates {}

class AdminInitialState extends AdminStates {}
class ChangeTabBarIndexState extends AdminStates {}
class SignInAsAdminState extends AdminStates {
  final ApiRequestStatus status;
  SignInAsAdminState({required this.status});
}

class UpdateBabysitterStatusAsAdminState extends AdminStates {
  final ApiRequestStatus status;
  final Babysitter babySitter;
  final ResponseOfInactiveBabysitterRequest response;
  UpdateBabysitterStatusAsAdminState({required this.babySitter,required this.status,required this.response});
}

class GetInactiveBabysittersAsAdminState extends AdminStates {
  final ApiRequestStatus status;
  final String? errorMessage;
  GetInactiveBabysittersAsAdminState({required this.status,this.errorMessage});
}

class GetBlockedBabysittersAsAdminState extends AdminStates {
  final ApiRequestStatus status;
  final String? errorMessage;
  GetBlockedBabysittersAsAdminState({required this.status,this.errorMessage});
}
