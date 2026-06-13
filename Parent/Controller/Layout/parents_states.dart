import 'package:carebuddy/Features/BabySitter/Models/baby_sitter.dart';
import 'package:carebuddy/Features/Parent/Models/parent.dart';
import 'package:carebuddy/Features/Shared/Models/babysitter_request_model.dart';
import 'package:carebuddy/Features/Shared/Models/notification_model.dart';
import '../../../../Core/Constants/enum.dart';
import '../../../Shared/Models/message_model.dart';

abstract class ParentsStates {}

class ParentLayoutInitialState extends ParentsStates {}

class ChangeIndexOfBottomNavigationParentState extends ParentsStates {}

class ChangeRateOfBabysitterRequestState extends ParentsStates {}

class ChangeStatusOfShownRequestsState extends ParentsStates {}

class KidSelectedOnCreateRequestBabysitterState extends ParentsStates {}

class GetKidImageState extends ParentsStates {}

class GetBabySittersState extends ParentsStates {
  final ApiRequestStatus status;
  final String? errorMessage;
  GetBabySittersState({required this.status, this.errorMessage});
}

class GetParentDataState extends ParentsStates {
  final ApiRequestStatus status;
  final String? errorMessage;
  GetParentDataState({required this.status, this.errorMessage});
}

class GetSpecificParentDetailsState extends ParentsStates {
  final ApiRequestStatus status;
  final Parent? parent;
  final String? errorMessage;
  GetSpecificParentDetailsState({required this.status,this.parent, this.errorMessage});
}

class DeleteParentAccountState extends ParentsStates {
  final ApiRequestStatus status;
  DeleteParentAccountState({required this.status});
}

class GetNotificationsState extends ParentsStates {
  final ApiRequestStatus status;
  final String? errorMessage;
  GetNotificationsState({required this.status, this.errorMessage});
}

class GetDetailsOfSpecificBabysitterState extends ParentsStates {
  final ApiRequestStatus status;
  final String? errorMessage;
  final Babysitter? babysitter;
  GetDetailsOfSpecificBabysitterState({required this.status, this.babysitter, this.errorMessage});
}

class GetMessagesState extends ParentsStates {
  final ApiRequestStatus status;
  final List<MessageModel>? messages;
  final String? errorMessage;
  GetMessagesState({this.messages, required this.status, this.errorMessage});
}

class GetChatsUpdateState extends ParentsStates {
  final ApiRequestStatus status;
  final String? errorMessage;
  GetChatsUpdateState({required this.status, this.errorMessage});
}

class GetRequestsState extends ParentsStates {
  final ApiRequestStatus status;
  final String? errorMessage;
  GetRequestsState({required this.status, this.errorMessage});
}

class PickedImageOnParentState extends ParentsStates {}

class SendMessageState extends ParentsStates {
  final ApiRequestStatus status;
  final String? errorMessage;
  SendMessageState({required this.status, this.errorMessage});
}

class EditParentProfileState extends ParentsStates {
  final ApiRequestStatus status;
  final String? errorMessage;
  EditParentProfileState({required this.status, this.errorMessage});
}

class GetReviewsOfBabysitterState extends ParentsStates {
  final ApiRequestStatus status;
  final String? errorMessage;
  final List<BabysitterRequestModel> requests;
  GetReviewsOfBabysitterState({required this.status, this.errorMessage,this.requests = const []});
}

class ResponseRequestAsParentState extends ParentsStates {
  final ApiRequestStatus status;
  final BabysitterRequestModel request;
  final BabysitterRequestStatus? response;
  ResponseRequestAsParentState({this.response,required this.status, required this.request});
}

class CreateBabysitterRequestState extends ParentsStates {
  final ApiRequestStatus status;
  CreateBabysitterRequestState({required this.status});
}

class AddOrRemoveBabysitterOnFavoritesState extends ParentsStates {
  final ApiRequestStatus status;
  final String? errorMessage;
  AddOrRemoveBabysitterOnFavoritesState({required this.status,this.errorMessage});
}

class AddOrUpdateNewKidState extends ParentsStates {
  final ApiRequestStatus status;
  final bool addNotUpdate;
  AddOrUpdateNewKidState({required this.status, required this.addNotUpdate});
}
