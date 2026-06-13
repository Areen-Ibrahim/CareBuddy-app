import 'dart:developer';
import 'dart:io';

import 'package:carebuddy/Core/Components/show_snackbar_widget.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Constants/translation_keys.dart';
import 'package:carebuddy/Core/Services/notifications_service.dart';
import 'package:carebuddy/Core/Services/supabase_service.dart';
import 'package:carebuddy/Features/BabySitter/Models/baby_sitter.dart';
import 'package:carebuddy/Features/Shared/Models/babysitter_request_model.dart';
import 'package:carebuddy/Features/Shared/Models/chat_overview_model.dart';
import 'package:carebuddy/Features/Shared/Models/comment_model.dart';
import 'package:carebuddy/Features/Shared/Models/message_model.dart';
import 'package:carebuddy/Features/BabySitter/View/Screens/babysitter_chats_screen.dart';
import 'package:carebuddy/Features/Shared/View/Screens/choose_user_role_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/Constants/constants.dart';
import '../../../../Core/Constants/enum.dart';
import '../../../../Core/Constants/strings.dart';
import '../../../../Core/Services/cache_manager_service.dart';
import '../../../../Core/Services/jump_to_bottom_of_screen_service.dart';
import '../../../../Core/Services/pick_file_service.dart';
import '../../../Shared/Models/notification_model.dart';
import '../../Models/babysitter_multi_media.dart';
import '../../View/Screens/babysitter_profile_screen.dart';
import '../../View/Screens/babysitter_requests_screen.dart';
import 'babysitter_state.dart';

class BabysitterCubit extends Cubit<BabysitterStates> {
  BabysitterCubit() : super(BabysitterLayoutInitialState());

  static BabysitterCubit getInstance(BuildContext context) =>
      BlocProvider.of<BabysitterCubit>(context);

  List<Widget> layoutPages = const [
    BabysitterChatsScreen(),
    BabysitterBookingScreen(),
    BabysitterProfileScreen()
  ];

  int? currentRateOfParentRequest;
  void changeRateOfBabysitterRequest(int rate) {
    if (currentRateOfParentRequest != rate) {
      currentRateOfParentRequest = rate;
      emit(ChangeRateOfParentRequestState());
    }
  }

  void deleteAccount({required BuildContext context}) async {
    try {
      emit(DeleteBabysitterAccountState(status: ApiRequestStatus.Loading));
      await _cloudStore
          .collection(AppCollections.kBabySitters)
          .doc(myData!.id)
          .delete();
      logOut(context);
      emit(DeleteBabysitterAccountState(status: ApiRequestStatus.Loading));
    } on FirebaseException catch (e) {
      showSnackBarWidget(message: e.code, successOrNot: false, context: context);
      emit(DeleteBabysitterAccountState(status: ApiRequestStatus.Failure));
    }
  }

  int currentIndexOfBottomNavigation = 0;
  void changeIndexOfBottomNavigation(int index) {
    currentIndexOfBottomNavigation = index;
    emit(ChangeIndexOfBottomNavigationState());
  }

  void getNotifications() async {
    try {
      emit(GetBabySitterNotificationsState(status: ApiRequestStatus.Loading));
      await _cloudStore
          .collection(AppCollections.kBabySitters)
          .doc(myData!.id)
          .collection(AppCollections.kNotifications)
          .orderBy("sentAt")
          .get()
          .then((query) async {
        emit(GetBabySitterNotificationsState(
            status: ApiRequestStatus.Success,
            notifications: List<NotificationModel>.from(
                query.docs.map((e) => NotificationModel.fromJson(json: e)))));
      });
    } on FirebaseException catch (e) {
      emit(GetBabySitterNotificationsState(
          status: ApiRequestStatus.Failure, errorMessage: e.code));
    }
  }

  File? babysitterImageFile;
  void pickBabysitterImage() async {
    await PickFileService.chooseImage().then((file) async {
      if (file != null) {
        babysitterImageFile = file;
        emit(GetProfileImageOfBabysitterState());
      }
    });
  }

  int pricePerHour = 0;
  void changePricePerHour(int value) {
    pricePerHour = value;
    emit(ChangePricePerHourOfBabysitterState());
  }

  String? selectedService;
  void chooseService(String selected) {
    selectedService = selected;
    emit(ChooseServiceOfBabysitterState());
  }

  File? selectedVideoFile;
  void chooseVideo() async {
    await PickFileService.chooseVideo().then((file) async {
      if (file != null) {
        selectedVideoFile = file;
        emit(VideoSelectedSuccessfullyState());
      }
    });
  }

  void updateIntroVideo(
      {required BuildContext context, required File file}) async {
    try {
      emit(UpdateVideoState(status: ApiRequestStatus.Loading));
      final BabysitterMedia media = myData!.multiMedia;
      final String url = await SupabaseService.kUploadFile(file);
      media.introVideo = url;
      await _cloudStore
          .collection(AppCollections.kBabySitters)
          .doc(myData!.id)
          .update({"multiMedia": media.toJson()});
      myData!.multiMedia.introVideo = url;
      showSnackBarWidget(
          message: "Video uploaded successfully.",
          successOrNot: true,
          context: context);
      emit(UpdateVideoState(status: ApiRequestStatus.Success));
      context.pop;
    } on FirebaseException catch (error) {
      showSnackBarWidget(
          message: AppConstants.kFormattedFirebaseErrorCode(error),
          successOrNot: true,
          context: context);
      emit(UpdateVideoState(status: ApiRequestStatus.Failure));
    }
  }

  bool availabilityStatus = true;
  void updateProfileData(
      {required BuildContext context,
      required String fName,
      required String lName,
      required bool availabilityStatus,
      required int pricePerHour,
      required String bio,
      required File? profileImage}) async {
    try {
      emit(UpdateProfileDataState(status: ApiRequestStatus.Loading));
      final BabysitterMedia media = myData!.multiMedia;
      if (profileImage != null) {
        final String url = await SupabaseService.kUploadFile(profileImage);
        media.profileImage = url;
      }
      await _cloudStore
          .collection(AppCollections.kBabySitters)
          .doc(myData!.id)
          .update({
        "fName": fName,
        "lname": lName,
        "bio": bio,
        "availabilityStatus": availabilityStatus,
        "pricePerHour": pricePerHour,
        if (profileImage != null) "multiMedia": media.toJson()
      });
      await getMyData(refresh: true);
      showSnackBarWidget(
          message: TranslationKeys.dataUpdatedSuccessfully.tr(context),
          successOrNot: true,
          context: context);
      emit(UpdateProfileDataState(status: ApiRequestStatus.Success));
      context.pop;
    } on FirebaseException catch (error) {
      showSnackBarWidget(
          message: AppConstants.kFormattedFirebaseErrorCode(error),
          successOrNot: true,
          context: context);
      emit(UpdateProfileDataState(status: ApiRequestStatus.Failure));
    }
  }

  void addNewService(
      {required BuildContext context, required String service}) async {
    try {
      emit(AddNewServiceState(status: ApiRequestStatus.Loading));
      myData!.services.add(service);
      await _cloudStore
          .collection(AppCollections.kBabySitters)
          .doc(myData!.id)
          .update({"services": myData!.services});
      showSnackBarWidget(
          message: "Service added successfully.",
          successOrNot: true,
          context: context);
      emit(AddNewServiceState(status: ApiRequestStatus.Success));
      context.pop;
    } on FirebaseException catch (error) {
      myData!.services.removeLast();
      showSnackBarWidget(
          message: AppConstants.kFormattedFirebaseErrorCode(error),
          successOrNot: true,
          context: context);
      emit(AddNewServiceState(status: ApiRequestStatus.Failure));
    }
  }

  Babysitter? myData;
  Future<void> getMyData({bool? refresh}) async {
    if (myData == null || refresh != null) {
      try {
        emit(GetMyDataState(status: ApiRequestStatus.Loading));
        await _cloudStore
            .collection(AppCollections.kBabySitters)
            .doc(CacheManagerService.readUserID()!.id)
            .get()
            .then((query) async {
          if (myData != Babysitter.fromJson(json: query.data())) {
            myData = Babysitter.fromJson(json: query.data());
            emit(GetMyDataState(status: ApiRequestStatus.Success));
            await updateFCMTokenOnCloud();
          }
        });
      } on FirebaseException catch (e) {
        emit(GetMyDataState(
            status: ApiRequestStatus.Failure, errorMessage: e.code));
      }
    }
  }

  Future<void> updateFCMTokenOnCloud() async {
    try {
      String? fcmToken = await NotificationsService.getFCMToken();
      if (fcmToken != null && myData!.fcmToken != fcmToken) {
        await _cloudStore
            .collection(AppCollections.kBabySitters)
            .doc(myData!.id)
            .update({"fcmToken": fcmToken});
      }
    } on FirebaseException catch (e) {
      debugPrint("Exception while updating FCM On CloudStore, ${e.code}");
    }
  }

  static final FirebaseFirestore _cloudStore = FirebaseFirestore.instance;
  Future<void> getMessages(
      {required ScrollController scrollCtr, required String parentID}) async {
    try {
      emit(GetBabySitterMessagesState(status: ApiRequestStatus.Loading));
      _cloudStore
          .collection(AppCollections.kBabySitters)
          .doc(myData!.id)
          .collection(AppCollections.kChats)
          .doc(parentID)
          .collection(AppCollections.kMessages)
          .orderBy("sentAt")
          .snapshots()
          .listen((query) {
        emit(GetBabySitterMessagesState(
            status: ApiRequestStatus.Success,
            messages: List<MessageModel>.from(
                query.docs.map((e) => MessageModel.fromJson(json: e)))));
        JumpToSpecificOffsetOnScreenService.screenBottom(controller: scrollCtr);
      });
    } on FirebaseException catch (e) {
      emit(GetBabySitterMessagesState(
          status: ApiRequestStatus.Failure, errorMessage: e.code));
    }
  }

  List<ParentChatOverviewModel> chatsUpdate = [];
  Future<void> getChatsUpdates() async {
    try {
      emit(GetChatsUpdateForBabysitterState(status: ApiRequestStatus.Loading));
      chatsUpdate.clear();
      await _cloudStore
          .collection(AppCollections.kBabySitters)
          .doc(myData!.id)
          .collection(AppCollections.kChats)
          .get()
          .then((query) async {
        for (var babysitterQuery in query.docs) {
          chatsUpdate.add(ParentChatOverviewModel.fromJson(
              json: babysitterQuery.data()["Parent"]));
        }
      });
      emit(GetChatsUpdateForBabysitterState(status: ApiRequestStatus.Success));
    } on FirebaseException catch (e) {
      emit(GetChatsUpdateForBabysitterState(
          status: ApiRequestStatus.Failure, errorMessage: e.code));
    }
  }

  void sendMessage(
      {required TextEditingController messageCtr,
      required ScrollController scrollCtr,
      required bool updateChatsOverview,
      required ParentChatOverviewModel receiverData,
      required String message,
      required BuildContext context}) async {
    try {
      messageCtr.clear();
      emit(SendMessageState(status: ApiRequestStatus.Loading));
      await _cloudStore
          .collection(AppCollections.kBabySitters)
          .doc(myData!.id)
          .collection(AppCollections.kChats)
          .doc(receiverData.parentID)
          .get()
          .then((documentSnapshot) async {
        await documentSnapshot.reference
            .collection(AppCollections.kMessages)
            .add(MessageModel(
                    message: message,
                    senderName: myData!.fName,
                    sentAt: DateTime.now(),
                    senderID: myData!.id,
                    receiverName: receiverData.parentName)
                .toJson());
        ParentChatOverviewModel parentOverview = ParentChatOverviewModel(
            parentID: receiverData.parentID,
            parentName: receiverData.parentName,
            lastMessage: message,
            parentImage: receiverData.parentImage);
        BabysitterChatOverviewModel babysitterOverview =
            BabysitterChatOverviewModel(
                lastMessage: message,
                babysitterID: myData!.id,
                babysitterIImage: myData!.multiMedia.profileImage,
                babysitterIName: myData!.fName);
        if (documentSnapshot.data() == null) {
          await documentSnapshot.reference.set({
            "Parent": parentOverview.toJson(),
            "Babysitter": babysitterOverview.toJson()
          });
        } else {
          await documentSnapshot.reference.update({
            "Parent": parentOverview.toJson(),
            "Babysitter": babysitterOverview.toJson()
          });
        }
      });
      JumpToSpecificOffsetOnScreenService.screenBottom(controller: scrollCtr);
      emit(SendMessageState(status: ApiRequestStatus.Success));
      if (updateChatsOverview) {
        int indexOfChatOnChatsUpdate = chatsUpdate
            .indexWhere((query) => query.parentID == receiverData.parentID);
        if (indexOfChatOnChatsUpdate != -1) {
          chatsUpdate[indexOfChatOnChatsUpdate].lastMessage = message;
        } else {
          chatsUpdate.add(ParentChatOverviewModel(
              parentID: receiverData.parentID,
              parentName: receiverData.parentName,
              lastMessage: message,
              parentImage: receiverData.parentImage));
        }
        emit(
            GetChatsUpdateForBabysitterState(status: ApiRequestStatus.Success));
      }
    } on FirebaseException catch (e) {
      showSnackBarWidget(
          message: AppConstants.kFormattedFirebaseErrorCode(e),
          successOrNot: false,
          context: context);
      emit(SendMessageState(
          status: ApiRequestStatus.Failure, errorMessage: e.code));
    }
  }

  bool showRequestsNotBooking = true;
  void changeStatusOfShownRequests(
      {required bool showRequestsNotBookingUpdated}) {
    if (showRequestsNotBooking != showRequestsNotBookingUpdated) {
      showRequestsNotBooking = showRequestsNotBookingUpdated;
      emit(ChangeStatusOfShownBabysitterBookingState());
    }
  }

  List<BabysitterRequestModel> requests = [];
  List<BabysitterRequestModel> requestsWithReviews = [];
  int averageRating = 0;
  Future<void> getRequests() async {
    try {
      requests.clear();
      requestsWithReviews.clear();
      averageRating = 0;
      emit(GetBabysitterBookingState(status: ApiRequestStatus.Loading));
      QuerySnapshot querySnapshot = await _cloudStore.collection(AppCollections.kRequests)
          .where("babySitter.id",isEqualTo: myData!.id)
          .get();
      for( var request in querySnapshot.docs )
      {
        Map decodeRequest = (request.data()) as Map;
        if( decodeRequest["status"] != BabysitterRequestStatus.Canceled.name && !(decodeRequest["status"] == BabysitterRequestStatus.Pending.name && (decodeRequest['startAt'] as Timestamp).toDate().isPast) )
        {
          if( !requests.contains(BabysitterRequestModel.fromJson(json: request.data())) )
          {
            requests.add(BabysitterRequestModel.fromJson(json: request.data()));
          }
        }
      }
      if( requests.isNotEmpty )
        {
          requestsWithReviews = requests.where((e)=> e.rateOfParent != null ).toList();
          averageRating = requestsWithReviews.isEmpty ? 0 : (requestsWithReviews.map((request) => request.rateOfParent!.rate).reduce((a, b) => a + b) / requestsWithReviews.length).toInt();
        }
      emit(GetBabysitterBookingState(status: ApiRequestStatus.Success));
    } on FirebaseException catch (e) {
      emit(GetBabysitterBookingState(
          status: ApiRequestStatus.Failure,
          errorMessage: AppConstants.kFormattedFirebaseErrorCode(e)));
    }
  }

  void responseRequest({bool? updateCanceledRequestsOfBabysitter,CommentModel? comment, required BuildContext context, required BabysitterRequestModel request, required BabysitterRequestStatus status}) async {
    try {
      log("Rate sent : $currentRateOfParentRequest");
      emit(ResponseRequestAsBabysitterState(request: request, status: ApiRequestStatus.Loading, response: status));
      int itemExistOnSameTime = -1;
      if( status == BabysitterRequestStatus.Accepted )
        {
          await _cloudStore.collection(AppCollections.kRequests)
              .where("babySitter.id",isEqualTo: myData!.id)
              .get().then((query) async {
                itemExistOnSameTime = query.docs.indexWhere((e)=> (e.data()["startAt"] as Timestamp).toDate().isBefore(request.startAt) && (e.data()["endAt"] as Timestamp).toDate().isAfter(request.startAt) && e.data()["status"] == BabysitterRequestStatus.Accepted.name);
          });
        }
      if( itemExistOnSameTime == -1 )
      {
        if (updateCanceledRequestsOfBabysitter != null) {
          await _cloudStore.collection(AppCollections.kBabySitters).doc(myData!.id).update({"canceledRequests": ++myData!.canceledRequests});
        }
        await _cloudStore.collection(AppCollections.kRequests).doc(request.id).update({
          "status" : status.name,
          if( comment != null )
            "rateOfBabysitter" : comment.toJson()
        });
        int indexOfSelectedRequest = requests.indexWhere((e) => e == request);
        if( status != BabysitterRequestStatus.Canceled )
        {
          requests[indexOfSelectedRequest].status = status.name;
          if( comment != null )
          {
            requests[indexOfSelectedRequest].rateOfBabysitter = comment;
          }
        }
        else
        {
          requests.removeAt(indexOfSelectedRequest);
        }
        emit(ResponseRequestAsBabysitterState(request: request, status: ApiRequestStatus.Success, response: status));
        if( comment != null )
        {
          context.pop;
        }
        else
        {
          if (status == BabysitterRequestStatus.Accepted || status == BabysitterRequestStatus.Rejected || status == BabysitterRequestStatus.Canceled) {
            NotificationsService.pushNotifyToSpecificUser(
                receiverUid: request.parent.id,
                receiverType: UserType.Parent,
                notification: NotificationModel(
                  sentAt: DateTime.now(),
                  enTxt: "You're request with ${request.babySitter.fName} ${request.babySitter.lname} ${status.name.toLowerCase()}",
                  arTxt: "لقد تم ${status == BabysitterRequestStatus.Accepted ? "قبول" : status == BabysitterRequestStatus.Rejected ? "رفض" : "إلغاء"} طلبك مع ${request.babySitter.fName} ${request.babySitter.lname}.",
                  seen: false,
                ),
                receiverFCMToken: request.parent.fcmToken!
            );
          }
        }
        if( status == BabysitterRequestStatus.Canceled && myData!.canceledRequests > 5 )
        {
          context.pushAndRemovePreviousRoutes(const ChooseUserRoleScreen(reachCancelRequestsLimit: true,));
        }
      }
      else
        {
          showSnackBarWidget(
              message: TranslationKeys.canNotAcceptRequestAsAlreadyExistItemOnSameTime.tr(context),
              successOrNot: false,
              context: context);
          emit(ResponseRequestAsBabysitterState(
              request: request,
              status: ApiRequestStatus.Failure,
              response: status));
        }
    } on FirebaseException catch (e) {
      showSnackBarWidget(
          message: AppConstants.kFormattedFirebaseErrorCode(e),
          successOrNot: false,
          context: context);
      emit(ResponseRequestAsBabysitterState(
          request: request,
          status: ApiRequestStatus.Failure,
          response: status));
    }
  }

  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void signOutOfEmail() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseException catch (e) {
      debugPrint(
          "Exception while signOut ${AppConstants.kFormattedFirebaseErrorCode(e)}");
    }
  }

  void logOut(BuildContext context) async {
    changeIndexOfBottomNavigation(0);
    myData = null;
    chatsUpdate.clear();
    requests.clear();
    context.pushAndRemovePreviousRoutes(const ChooseUserRoleScreen());
    await CacheManagerService.clearAll();
    signOutOfEmail();
  }
}
