import 'package:carebuddy/Features/Shared/Models/babysitter_request_model.dart';

import '../../../../Core/Constants/enum.dart';
import '../../../Shared/Models/message_model.dart';
import '../../../Shared/Models/notification_model.dart';

abstract class BabysitterStates {}

class BabysitterLayoutInitialState extends BabysitterStates {}
class ChangeRateOfParentRequestState extends BabysitterStates {}
class VideoSelectedSuccessfullyState extends BabysitterStates {}
class ChangeStatusOfShownBabysitterBookingState extends BabysitterStates {}

class ChangePricePerHourOfBabysitterState extends BabysitterStates {}
class ChangeIndexOfBottomNavigationState extends BabysitterStates {}
class GetProfileImageOfBabysitterState extends BabysitterStates {}
class ChooseServiceOfBabysitterState extends BabysitterStates {}

class GetBabySitterMessagesState extends BabysitterStates {
  final ApiRequestStatus status;
  final List<MessageModel>? messages;
  final String? errorMessage;
  GetBabySitterMessagesState({this.messages,required this.status,this.errorMessage});
}

class DeleteBabysitterAccountState extends BabysitterStates {
  final ApiRequestStatus status;
  DeleteBabysitterAccountState({required this.status});
}

class GetBabySitterNotificationsState extends BabysitterStates {
  final ApiRequestStatus status;
  final String? errorMessage;
  final List<NotificationModel> notifications;
  GetBabySitterNotificationsState({required this.status,this.errorMessage,this.notifications = const []});
}

class SendMessageState extends BabysitterStates {
  final ApiRequestStatus status;
  final String? errorMessage;
  SendMessageState({required this.status,this.errorMessage});
}

class GetBabysitterBookingState extends BabysitterStates {
  final ApiRequestStatus status;
  final String? errorMessage;
  GetBabysitterBookingState({required this.status,this.errorMessage});
}

class ResponseRequestAsBabysitterState extends BabysitterStates {
  final ApiRequestStatus status;
  final BabysitterRequestStatus response;
  final BabysitterRequestModel request;
  ResponseRequestAsBabysitterState({required this.response,required this.request,required this.status});
}


class GetMyDataState extends BabysitterStates {
  final ApiRequestStatus status;
  final String? errorMessage;
  GetMyDataState({required this.status,this.errorMessage});
}

class UpdateVideoState extends BabysitterStates {
  final ApiRequestStatus status;
  UpdateVideoState({required this.status});
}

class UpdateProfileDataState extends BabysitterStates {
  final ApiRequestStatus status;
  UpdateProfileDataState({required this.status});
}

class AddNewServiceState extends BabysitterStates {
  final ApiRequestStatus status;
  AddNewServiceState({required this.status});
}

class GetChatsUpdateForBabysitterState extends BabysitterStates {
  final ApiRequestStatus status;
  final String? errorMessage;
  GetChatsUpdateForBabysitterState({required this.status,this.errorMessage});
}