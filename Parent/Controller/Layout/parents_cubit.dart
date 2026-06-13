import 'dart:developer';
import 'dart:io';
import 'package:carebuddy/Core/Components/show_snackbar_widget.dart';
import 'package:carebuddy/Core/Constants/constants.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Constants/translation_keys.dart';
import 'package:carebuddy/Core/Services/supabase_service.dart';
import 'package:carebuddy/Core/Theme/colors.dart';
import 'package:carebuddy/Features/Parent/View/Screens/parent_layout_screen.dart';
import 'package:carebuddy/Features/Shared/Models/babysitter_request_model.dart';
import 'package:carebuddy/Features/Shared/Models/comment_model.dart';
import 'package:carebuddy/Features/Shared/Models/kid_model.dart';
import 'package:carebuddy/Features/Shared/Models/message_model.dart';
import 'package:carebuddy/Core/Services/cache_manager_service.dart';
import 'package:carebuddy/Features/Parent/Controller/Layout/parents_states.dart';
import 'package:carebuddy/Features/Parent/Models/parent.dart';
import 'package:carebuddy/Features/Shared/Models/chat_overview_model.dart';
import 'package:carebuddy/Features/Shared/Models/notification_model.dart';
import 'package:carebuddy/Features/Shared/View/Screens/choose_user_role_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paytabs_bridge/flutter_paytabs_bridge.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../Core/Constants/enum.dart';
import '../../../../Core/Constants/strings.dart';
import '../../../../Core/Services/jump_to_bottom_of_screen_service.dart';
import '../../../../Core/Services/notifications_service.dart';
import '../../../../Core/Services/pay_tabs_service.dart';
import '../../../../Core/Services/pick_file_service.dart';
import '../../../BabySitter/Models/baby_sitter.dart';
import '../../../Shared/Models/pay_tab_request_model.dart';
import '../../View/Screens/parent_chats_screen.dart';
import '../../View/Screens/parent_favorites_screen.dart';
import '../../View/Screens/parent_home_screen.dart';
import '../../View/Screens/parent_profile_screen.dart';
import '../../View/Screens/parent_requests_screen.dart';

class ParentsCubit extends Cubit<ParentsStates> {
  ParentsCubit() : super(ParentLayoutInitialState());

  static ParentsCubit getInstance(BuildContext context) =>
      BlocProvider.of<ParentsCubit>(context);

  List<Widget> layoutPages = const [
    ParentHomeScreen(),
    ParentFavoritesScreen(),
    ParentRequestsScreen(),
    ParentChatScreen(),
    ParentProfileScreen()
  ];

  List<Babysitter> filteredBabysitters = [];
  void filterBabysitterAccordingService({required String service}) {
    filteredBabysitters = babySitters.where((babysitter) => babysitter.services.contains(service)).toList();
    emit(GetBabySittersState(status: ApiRequestStatus.Success));
  }

  void filterBabysittersAccordingName({required String input}) {
    filteredBabysitters = babySitters.where((babysitter) => ("${babysitter.fName} ${babysitter.lname}").toLowerCase().contains(input.toLowerCase())).toList();
    emit(GetBabySittersState(status: ApiRequestStatus.Success));
  }

  void emptyFilterOfBabysitters() {
    filteredBabysitters.clear();
  }

  void showMenuFilterOfHome(BuildContext context) async {
    if (babySitters.isNotEmpty) {
      List<dynamic> services = [];
      for (var babysitter in babySitters) {
        if (babysitter.services.isNotEmpty) {
          services.addAll(babysitter.services);
        }
      }
      if (services.isNotEmpty) {
        await showMenu(
          context: context,
          position: RelativeRect.fill,
          items: List.generate(
            services.length,
                (index) => PopupMenuItem(
                child: Text(
                    services[index].toString().tr(context)
                ),
                onTap: () => filterBabysitterAccordingService(
                  service: services[index].toString(),
                )
            ),
          ).reversed.toList(),
        );
      } else {
        showSnackBarWidget(
          message: TranslationKeys.noServicesAddedYet.tr(context),
          successOrNot: true,
          context: context,
        );
      }
    } else {
      showSnackBarWidget(
        message: TranslationKeys.noServicesAddedYet.tr(context),
        successOrNot: true,
        context: context,
      );
    }
  }

  int currentIndexOfBottomNavigation = 0;
  void changeIndexOfBottomNavigation(int index) {
    currentIndexOfBottomNavigation = index;
    emit(ChangeIndexOfBottomNavigationParentState());
  }

  int? currentRateOfBabysitterRequest;
  void changeRateOfBabysitterRequest(int rate) {
    if (currentRateOfBabysitterRequest != rate) {
      currentRateOfBabysitterRequest = rate;
      emit(ChangeRateOfBabysitterRequestState());
    }
  }

  bool showRequestsNotBooking = true;
  void changeStatusOfShownRequests(
      {required bool showRequestsNotBookingUpdated}) {
    if (showRequestsNotBooking != showRequestsNotBookingUpdated) {
      showRequestsNotBooking = showRequestsNotBookingUpdated;
      emit(ChangeStatusOfShownRequestsState());
    }
  }

  KidModel? selectedKidOnCreateRequestBabysitter;
  void selectKidOnCreateRequestBabysitter(KidModel kid) {
    if (selectedKidOnCreateRequestBabysitter == null ||
        (selectedKidOnCreateRequestBabysitter != null &&
            selectedKidOnCreateRequestBabysitter!.id != kid.id)) {
      selectedKidOnCreateRequestBabysitter = kid;
      emit(KidSelectedOnCreateRequestBabysitterState());
    }
  }

  File? kidImageFile;
  void selectKidImage() async {
    await PickFileService.chooseImage().then((file) async {
      if (file != null) {
        kidImageFile = file;
        emit(GetKidImageState());
      }
    });
  }

  static final FirebaseFirestore _cloudStore = FirebaseFirestore.instance;
  List<Babysitter> babySitters = [];
  Future<void> getBabySitters({bool? refresh}) async {
    try {
      babySitters.clear();
      emit(GetBabySittersState(status: ApiRequestStatus.Loading));
      await _cloudStore.collection(AppCollections.kBabySitters).where("availabilityStatus",isEqualTo: true).get().then((querySnapshots) {
        if (querySnapshots.docs.isNotEmpty) {
          for (var item in querySnapshots.docs) {
            final Babysitter babySitter = Babysitter.fromJson(json: item.data());
            if (!babySitters.contains(babySitter) && babySitter.city.toLowerCase().contains(myData!.city.toLowerCase())) {
              babySitters.add(babySitter);
            }
          }
        }
      });
      emit(GetBabySittersState(status: ApiRequestStatus.Success));
    } on FirebaseException catch (e) {
      emit(GetBabySittersState(
          status: ApiRequestStatus.Failure, errorMessage: e.code));
    }
  }

  void getSpecificParentDetails({required String id}) async {
    try {
      emit(GetSpecificParentDetailsState(status: ApiRequestStatus.Loading));
      await _cloudStore
          .collection(AppCollections.kParents)
          .doc(id)
          .get()
          .then((query) async {
        emit(GetSpecificParentDetailsState(status: ApiRequestStatus.Success,parent: Parent.fromJson(json: query.data())));
      });
    } on FirebaseException catch (e) {
      emit(GetSpecificParentDetailsState(status: ApiRequestStatus.Failure, errorMessage: e.code));
    }
  }

  Parent? myData;
  void getMyData({bool? refresh}) async {
    if (myData == null || refresh != null) {
      try {
        emit(GetParentDataState(status: ApiRequestStatus.Loading));
        await _cloudStore
            .collection(AppCollections.kParents)
            .doc(CacheManagerService.readUserID()!.id)
            .get()
            .then((query) async {
          if (myData == null ||
              (myData != null &&
                  myData != Parent.fromJson(json: query.data()))) {
            myData = Parent.fromJson(json: query.data());
            emit(GetParentDataState(status: ApiRequestStatus.Success));
            await updateFCMTokenOnCloud();
          }
        });
      } on FirebaseException catch (e) {
        emit(GetParentDataState(status: ApiRequestStatus.Failure, errorMessage: e.code));
      }
    }
  }

  void deleteAccount({required BuildContext context}) async {
    try {
      emit(DeleteParentAccountState(status: ApiRequestStatus.Loading));
      await _cloudStore
          .collection(AppCollections.kParents)
          .doc(myData!.id)
          .delete();
      logOut(context);
      emit(DeleteParentAccountState(status: ApiRequestStatus.Loading));
    } on FirebaseException catch (e) {
      showSnackBarWidget(message: e.code, successOrNot: false, context: context);
      emit(DeleteParentAccountState(status: ApiRequestStatus.Failure));
    }
  }

  void getBabysitterDetails(String babysitterID) async {
    try {
      emit(GetDetailsOfSpecificBabysitterState(status: ApiRequestStatus.Loading));
      await _cloudStore
          .collection(AppCollections.kBabySitters)
          .doc(babysitterID)
          .get()
          .then((query) {
        emit(GetDetailsOfSpecificBabysitterState(status: ApiRequestStatus.Success,babysitter: Babysitter.fromJson(json: query.data())));
      });
    } on FirebaseException catch (e) {
      emit(GetDetailsOfSpecificBabysitterState(
          status: ApiRequestStatus.Failure, errorMessage: e.code));
    }
  }

  List<NotificationModel> notifications = [];
  void getNotifications() async {
    try {
      emit(GetNotificationsState(status: ApiRequestStatus.Loading));
      await _cloudStore
          .collection(AppCollections.kParents)
          .doc(myData!.id)
          .collection(AppCollections.kNotifications)
          .orderBy("sentAt")
          .get()
          .then((query) async {
        notifications = List<NotificationModel>.from(query.docs.map((e) => NotificationModel.fromJson(json: e)));
        emit(GetNotificationsState(status: ApiRequestStatus.Success));
      });
    } on FirebaseException catch (e) {
      emit(GetNotificationsState(
          status: ApiRequestStatus.Failure, errorMessage: e.code));
    }
  }

  Future<void> updateFCMTokenOnCloud() async {
    try {
      String? fcmToken = await NotificationsService.getFCMToken();
      if (fcmToken != null && myData!.fcmToken != fcmToken) {
        await _cloudStore
            .collection(AppCollections.kParents)
            .doc(myData!.id)
            .update({"fcmToken": fcmToken});
      }
    } on FirebaseException catch (e) {
      debugPrint("Exception while updating FCM On CloudStore, ${e.code}");
    }
  }

  Future<void> getMessages({required ScrollController scrollCtr,required String babysitterID}) async {
    try {
      emit(GetMessagesState(status: ApiRequestStatus.Loading));
      _cloudStore
          .collection(AppCollections.kBabySitters)
          .doc(babysitterID)
          .collection(AppCollections.kChats)
          .doc(myData!.id)
          .collection(AppCollections.kMessages)
          .orderBy("sentAt")
          .snapshots()
          .listen((query) {
        emit(GetMessagesState(
            status: ApiRequestStatus.Success,
            messages: List<MessageModel>.from(
                query.docs.map((e) => MessageModel.fromJson(json: e)))));
        JumpToSpecificOffsetOnScreenService.screenBottom(controller: scrollCtr);
      });
    } on FirebaseException catch (e) {
      emit(GetMessagesState(
          status: ApiRequestStatus.Failure, errorMessage: e.code));
    }
  }

  List<BabysitterChatOverviewModel> chatsUpdate = [];
  Future<void> getChatsUpdates() async {
    try {
      emit(GetChatsUpdateState(status: ApiRequestStatus.Loading));
      await _cloudStore
          .collection(AppCollections.kBabySitters)
          .get()
          .then((query) async {
        for (var babysitterQuery in query.docs) {
          await babysitterQuery.reference
              .collection(AppCollections.kChats)
              .doc(myData!.id)
              .get()
              .then((documentSnapshot) async {
            if (documentSnapshot.exists) {
              final BabysitterChatOverviewModel model =
              BabysitterChatOverviewModel.fromJson(
                  json: documentSnapshot.data()!["Babysitter"]);
              if (chatsUpdate.contains(model) == false) {
                chatsUpdate.add(model);
              }
            }
          });
        }
      });
      emit(GetChatsUpdateState(status: ApiRequestStatus.Success));
    } on FirebaseException catch (e) {
      emit(GetChatsUpdateState(status: ApiRequestStatus.Failure, errorMessage: e.code));
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
      emit(GetRequestsState(status: ApiRequestStatus.Loading));
      QuerySnapshot querySnapshot = await _cloudStore.collection(AppCollections.kRequests)
          .where("parent.id",isEqualTo: myData!.id)
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
          requestsWithReviews = requests.where((e)=> e.rateOfBabysitter != null ).toList();
          averageRating = requestsWithReviews.isEmpty ? 0 : (requestsWithReviews.map((request) => request.rateOfBabysitter!.rate).reduce((a, b) => a + b) / requestsWithReviews.length).toInt();
        }
      emit(GetRequestsState(status: ApiRequestStatus.Success));
    } on FirebaseException catch (e) {
      emit(GetRequestsState(status: ApiRequestStatus.Failure, errorMessage: e.code));
    }
  }

  void sendMessage(
      {required TextEditingController messageCtr,
        required ScrollController scrollCtr,
        required bool updateChatsOverview,
        required BabysitterChatOverviewModel receiverData,
        required String message,
        required BuildContext context}) async {
    try {
      messageCtr.clear();
      emit(SendMessageState(status: ApiRequestStatus.Loading));
      await _cloudStore
          .collection(AppCollections.kBabySitters)
          .doc(receiverData.babysitterID)
          .collection(AppCollections.kChats)
          .doc(myData!.id)
          .get()
          .then((documentSnapshot) async {
        await documentSnapshot.reference
            .collection(AppCollections.kMessages)
            .add(MessageModel(
            message: message,
            senderName: myData!.fName,
            sentAt: DateTime.now(),
            senderID: myData!.id,
            receiverName: receiverData.babysitterIName)
            .toJson());
        ParentChatOverviewModel sender = ParentChatOverviewModel(
            parentID: myData!.id,
            parentName: myData!.fName,
            lastMessage: message,
            parentImage: myData!.profileImage);
        BabysitterChatOverviewModel receiver = BabysitterChatOverviewModel(
            lastMessage: message,
            babysitterID: receiverData.babysitterID,
            babysitterIImage: receiverData.babysitterIImage,
            babysitterIName: receiverData.babysitterIName);
        if (documentSnapshot.data() == null) {
          await documentSnapshot.reference.set(
              {"Parent": sender.toJson(), "Babysitter": receiver.toJson()});
        } else {
          await documentSnapshot.reference.update(
              {"Parent": sender.toJson(), "Babysitter": receiver.toJson()});
        }
      });
      JumpToSpecificOffsetOnScreenService.screenBottom(controller: scrollCtr);
      emit(SendMessageState(status: ApiRequestStatus.Success));
      if (updateChatsOverview) {
        int indexOfChatOnChatsUpdate = chatsUpdate.indexWhere(
                (query) => query.babysitterID == receiverData.babysitterID);
        if (indexOfChatOnChatsUpdate != -1) {
          chatsUpdate[indexOfChatOnChatsUpdate].lastMessage = message;
        } else {
          chatsUpdate.add(BabysitterChatOverviewModel(
              babysitterID: receiverData.babysitterID,
              babysitterIName: receiverData.babysitterIName,
              lastMessage: message,
              babysitterIImage: receiverData.babysitterIImage));
        }
        emit(GetChatsUpdateState(status: ApiRequestStatus.Success));
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

  void createBabysitterRequest({required BabysitterRequestModel request, required Babysitter babysitter, required BuildContext context}) async {
    try {
      emit(CreateBabysitterRequestState(status: ApiRequestStatus.Loading));
      await _cloudStore.collection(AppCollections.kRequests).doc(request.id).set(request.toJson());
      context.pop;
      emit(CreateBabysitterRequestState(status: ApiRequestStatus.Success));
      showSnackBarWidget(message: TranslationKeys.requestCreatedSuccess.tr(context), successOrNot: true, context: context);
      await NotificationsService.pushNotifyToSpecificUser(
          receiverUid: request.babySitter.id,
          receiverType: UserType.Babysitter,
          notification: NotificationModel(
              sentAt: DateTime.now(),
              arTxt: "لديك طلب جديد من ${request.babySitter.fName} ${request.babySitter.lname}",
              enTxt: "A new booking request received from ${request.parent.fName} ${request.parent.lname}", seen: false),
          receiverFCMToken: request.babySitter.fcmToken!);
    } on FirebaseException catch (e) {
      showSnackBarWidget(message: AppConstants.kFormattedFirebaseErrorCode(e), successOrNot: false, context: context,);
      emit(CreateBabysitterRequestState(status: ApiRequestStatus.Failure));
    }
  }

  void addOrRemoveBabysitterOnFavorites({required BuildContext context, required String babysitterID}) async {
    try {
      emit(AddOrRemoveBabysitterOnFavoritesState(status: ApiRequestStatus.Loading));
      myData!.favorites.contains(babysitterID)
          ? myData!.favorites.remove(babysitterID)
          : myData!.favorites.add(babysitterID);
      await _cloudStore
          .collection(AppCollections.kParents)
          .doc(myData!.id)
          .update({"favorites": myData!.favorites});
      emit(AddOrRemoveBabysitterOnFavoritesState(
          status: ApiRequestStatus.Success));
    } on FirebaseException catch (e) {
      // TODO: Back it Again As Didn't Changed On Cloud
      myData!.favorites.contains(babysitterID)
          ? myData!.favorites.remove(babysitterID)
          : myData!.favorites.add(babysitterID);
      showSnackBarWidget(
          message: "Failed To Change Item status on Favorites, ${e.code}",
          successOrNot: false,
          context: context);
      emit(AddOrRemoveBabysitterOnFavoritesState(
          status: ApiRequestStatus.Failure));
    }
  }

  void addNewKid({required BuildContext context, required KidModel kid}) async {
    try {
      emit(AddOrUpdateNewKidState(
          status: ApiRequestStatus.Loading, addNotUpdate: true));
      myData!.kids.add(KidModel(
          id: kid.id,
          name: kid.name,
          image: kidImageFile != null
              ? await SupabaseService.kUploadFile(kidImageFile!)
              : null,
          dateOfBirth: kid.dateOfBirth,
          dietaryRequirements: kid.dietaryRequirements,
          notes: kid.notes,
          gender: kid.gender));
      await _cloudStore
          .collection(AppCollections.kParents)
          .doc(myData!.id)
          .update({"kids": myData!.kids.map((e) => e.toJson()).toList()});
      emit(AddOrUpdateNewKidState(
          status: ApiRequestStatus.Success, addNotUpdate: true));
      context.pop;
    } on FirebaseException catch (e) {
      myData!.kids.removeAt(0);
      showSnackBarWidget(
          message: e.code, successOrNot: false, context: context);
      emit(AddOrUpdateNewKidState(
          status: ApiRequestStatus.Failure, addNotUpdate: true));
    }
  }

  void updateKid(
      {required BuildContext context,
        required bool calledFromDetailsScreen,
        required KidModel kid}) async {
    try {
      emit(AddOrUpdateNewKidState(
          status: ApiRequestStatus.Loading, addNotUpdate: false));
      KidModel updatedKid = KidModel(
          id: kid.id,
          name: kid.name,
          image: kidImageFile != null
              ? await SupabaseService.kUploadFile(kidImageFile!)
              : kid.image,
          dateOfBirth: kid.dateOfBirth,
          dietaryRequirements: kid.dietaryRequirements,
          notes: kid.notes,
          gender: kid.gender);
      int indexOfKidOnKids = myData!.kids.indexWhere((e) => e.id == kid.id);
      myData!.kids[indexOfKidOnKids] = updatedKid;
      await _cloudStore
          .collection(AppCollections.kParents)
          .doc(myData!.id)
          .update({"kids": myData!.kids.map((e) => e.toJson()).toList()});
      emit(AddOrUpdateNewKidState(
          status: ApiRequestStatus.Success, addNotUpdate: false));
      if (context.mounted) {
        showSnackBarWidget(
            message: TranslationKeys.dataUpdatedSuccessfully.tr(context),
            successOrNot: true,
            context: context);
        calledFromDetailsScreen
            ? context.pushAndRemovePreviousRoutes(const ParentLayoutScreen())
            : context.pop;
      }
    } on FirebaseException catch (e) {
      showSnackBarWidget(
          message: e.code, successOrNot: false, context: context);
      emit(AddOrUpdateNewKidState(
          status: ApiRequestStatus.Failure, addNotUpdate: false));
    }
  }

  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void signOutOfEmail() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseException catch (e) {
      debugPrint("Exception while signOut ${AppConstants.kFormattedFirebaseErrorCode(e)}");
    }
  }

  GenderStatus genderChosen = GenderStatus.Male;
  void chooseGender(GenderStatus gender) {
    genderChosen = gender;
    emit(PickedImageOnParentState());
  }

  File? parentImageFile;
  void chooseParentImageFile() async {
    await PickFileService.chooseImage().then((file) async {
      if (file != null) {
        parentImageFile = file;
        emit(PickedImageOnParentState());
      }
    });
  }

  Future<void> editParentData({required BuildContext context, required String locationUrl, required String fName, required String lname, required String phone, required String city}) async {
    try {
      emit(EditParentProfileState(status: ApiRequestStatus.Loading));
      await _cloudStore
          .collection(AppCollections.kParents)
          .doc(myData!.id)
          .update({
        'fName': fName,
        'lname': lname,
        'phone': phone,
        'city': city,
        'locationUrl': locationUrl,
        if (parentImageFile != null)
          'profileImage': await SupabaseService.kUploadFile(parentImageFile!),
      });
      emit(EditParentProfileState(status: ApiRequestStatus.Success));
      getMyData(refresh: true);
      showSnackBarWidget(
          message: TranslationKeys.dataUpdatedSuccessfully.tr(context),
          successOrNot: true,
          context: context);
      context.pop;
    } on FirebaseException catch (error) {
      showSnackBarWidget(
          context: context,
          successOrNot: false,
          message: AppConstants.kFormattedFirebaseErrorCode(error));
      emit(EditParentProfileState(status: ApiRequestStatus.Failure));
    }
  }

  Future<void> editParentProfileImage({required BuildContext context}) async {
    try {
      emit(EditParentProfileState(status: ApiRequestStatus.Loading));
      await _cloudStore.collection(AppCollections.kParents).doc(myData!.id).update({'profileImage': await SupabaseService.kUploadFile(parentImageFile!),});
      emit(EditParentProfileState(status: ApiRequestStatus.Success));
      getMyData(refresh: true);
      context.pop;
    } on FirebaseException catch (error) {
      showSnackBarWidget(context: context, successOrNot: false, message: AppConstants.kFormattedFirebaseErrorCode(error));
      emit(EditParentProfileState(status: ApiRequestStatus.Failure));
    }
  }

  void getReviewsOfBabysitter({required Babysitter babysitter}) async {
    try{
      emit(GetReviewsOfBabysitterState(status: ApiRequestStatus.Loading));
      await _cloudStore.collection(AppCollections.kRequests).where("babySitter.id",isEqualTo: babysitter.id).get().then((query) async {
        emit(GetReviewsOfBabysitterState(status: ApiRequestStatus.Success,requests: List<BabysitterRequestModel>.from(query.docs.where((e)=> e.data()["rateOfParent"] != null).map((e)=> BabysitterRequestModel.fromJson(json: e.data())))));
      });
    }
    on FirebaseException catch(e){
      emit(GetReviewsOfBabysitterState(status: ApiRequestStatus.Failure,errorMessage: e.code));
    }
  }

  void logOut(BuildContext context) async {
    changeIndexOfBottomNavigation(0);
    myData = null;
    chatsUpdate.clear();
    babySitters.clear();
    requests.clear();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ChooseUserRoleScreen()),
            (_) => false);
    await CacheManagerService.clearAll();
    signOutOfEmail();
  }

  void payNow({bool? calledAfterCancelRequest,required BuildContext context, required BabysitterRequestModel request}) async {
    FlutterPaytabsBridge.startCardPayment(PayTabsService().configPayment(payTabsPaymentRequest: PayTabsPaymentRequest(AppConstants.kGetTotalPriceOfSession(request), "${request.parent.fName} ${request.parent.lname}", request.parent.email, request.parent.city, request.parent.phone)), (event) async {
      if (event["status"] == "success" && event["data"]["isSuccess"]) {
        await responseRequest(
          context: context,
          request: request,
          response: calledAfterCancelRequest != null ? BabysitterRequestStatus.Canceled : BabysitterRequestStatus.Paid,
          comment: null,
        );
        if( calledAfterCancelRequest != null )
        {
          await _cloudStore.collection(AppCollections.kParents).doc(myData!.id).update({
            "canceledRequests" : ++myData!.canceledRequests
          });
        }
      } else if (event["status"] == "error") {
        Fluttertoast.showToast(
            msg: (event["message"]).toString(),
            backgroundColor: AppColors.kRed);
      } else if (event["status"] == "event") {
        Fluttertoast.showToast(
            msg: (event["message"]).toString(),
            backgroundColor: AppColors.kRed);
      } else {
        Fluttertoast.showToast(
            msg: (event["data"]["paymentResult"]["responseMessage"]).toString(),
            backgroundColor: AppColors.kRed);
      }
    });
  }

  Future<void> responseRequest({required BuildContext context, required CommentModel? comment, required BabysitterRequestModel request, required BabysitterRequestStatus? response}) async {
    try {
      emit(ResponseRequestAsParentState(request: request, status: ApiRequestStatus.Loading,response: response));
      await _cloudStore.collection(AppCollections.kRequests).doc(request.id).update({
        if( response != null )
          "status" : response.name,
        if( comment != null )
          "rateOfParent" : comment.toJson()
      });
      int indexOfSelectedRequest = requests.indexOf(request);
      if( response != null && response.name == BabysitterRequestStatus.Canceled.name )
        {
          requests.removeAt(indexOfSelectedRequest);
        }
      else
        {
          if (response != null) {
            requests[indexOfSelectedRequest].status = response.name;
          }
          if (comment != null) {
            requests[indexOfSelectedRequest].rateOfParent = comment;
          }
        }
      emit(ResponseRequestAsParentState(request: request,response: response, status: ApiRequestStatus.Success));
      if( comment != null )
        {
          context.pop;
        }
    } on FirebaseException catch (e) {
      showSnackBarWidget(message: e.toString(), successOrNot: false, context: context);
      emit(ResponseRequestAsParentState(response: response, request: request, status: ApiRequestStatus.Failure));
    }
  }
}
