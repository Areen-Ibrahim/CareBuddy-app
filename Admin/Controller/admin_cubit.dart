import 'dart:developer';

import 'package:carebuddy/Core/Components/show_snackbar_widget.dart';
import 'package:carebuddy/Core/Constants/constants.dart';
import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Constants/strings.dart';
import 'package:carebuddy/Core/Services/notifications_service.dart';
import 'package:carebuddy/Features/Admin/View/screens/admin_home_page.dart';
import 'package:carebuddy/Features/Admin/View/screens/admin_login_page.dart';
import 'package:carebuddy/Features/BabySitter/Models/baby_sitter.dart';
import 'package:carebuddy/Features/Shared/Models/notification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/Services/cache_manager_service.dart';
part 'admin_states.dart';

class AdminCubit extends Cubit<AdminStates> {
  AdminCubit() : super(AdminInitialState());

  static AdminCubit getInstance(BuildContext context) => BlocProvider.of<AdminCubit>(context);

  int currentTabBar = 0;
  void changeTabBarIndex(int index){
    if( currentTabBar != index )
      {
        currentTabBar = index;
        emit(ChangeTabBarIndexState());
      }
  }

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  void signIn({required BuildContext context,required String email,required String password}) async {
    try{
      emit(SignInAsAdminState(status: ApiRequestStatus.Loading));
      QuerySnapshot snapshot = await _firebaseFirestore.collection(AppCollections.kAdmin).get();
      final Map<String,dynamic> data = (snapshot.docs.first.data() as Map<String,dynamic>);
      if( data["email"] == email && data["password"] == password )
        {
          context.pushAndRemovePreviousRoutes(const AdminHomePage());
          await CacheManagerService.writeAdminAlreadyLogin();
          emit(SignInAsAdminState(status: ApiRequestStatus.Success));
        }
      else
        {
          showSnackBarWidget(message: "Incorrect data entered !.", successOrNot: false, context: context);
          emit(SignInAsAdminState(status: ApiRequestStatus.Failure));
        }
    }
    on FirebaseAuthException catch(e){
      showSnackBarWidget(message: "Incorrect data entered !.", successOrNot: false, context: context);
      emit(SignInAsAdminState(status: ApiRequestStatus.Failure));
    }
  }

  List<Babysitter> inactiveBabysitters = [];
  Future<void> getInactiveBabysitter() async {
    try{
      emit(GetInactiveBabysittersAsAdminState(status: ApiRequestStatus.Loading));
      await _firebaseFirestore.collection(AppCollections.kBabySitters).get().then((e) async {
        for( var item in e.docs )
          {
            if( inactiveBabysitters.contains(Babysitter.fromJson(json: item.data())) == false )
              {
                inactiveBabysitters.add(Babysitter.fromJson(json: item.data()));
              }
          }
        emit(GetInactiveBabysittersAsAdminState(status: ApiRequestStatus.Success));
      });
    }
    on FirebaseException catch(e){
      emit(GetInactiveBabysittersAsAdminState(status: ApiRequestStatus.Failure,errorMessage: AppConstants.kFormattedFirebaseErrorCode(e)));
    }
  }

  List<Babysitter> blockedBabysitters = [];
  Future<void> getBlockedBabysitter() async {
    try{
      blockedBabysitters.clear();
      emit(GetBlockedBabysittersAsAdminState(status: ApiRequestStatus.Loading));
      await _firebaseFirestore.collection(AppCollections.kBabySitters).where("canceledRequests",isGreaterThanOrEqualTo: 6).get().then((e) async {
        for( var item in e.docs )
        {
          blockedBabysitters.add(Babysitter.fromJson(json: item.data()));
        }
        emit(GetBlockedBabysittersAsAdminState(status: ApiRequestStatus.Success));
      });
      log("Blocked ${blockedBabysitters.length}");
    }
    on FirebaseException catch(e){
      emit(GetBlockedBabysittersAsAdminState(status: ApiRequestStatus.Failure,errorMessage: AppConstants.kFormattedFirebaseErrorCode(e)));
    }
  }

  void updateBabysitterStatusAsAdmin({bool unBlock = false,required BuildContext context,required Babysitter babysitter,required ResponseOfInactiveBabysitterRequest response}) async{
    try{
      emit(UpdateBabysitterStatusAsAdminState(babySitter: babysitter,status: ApiRequestStatus.Loading, response: response));
      await _firebaseFirestore.collection(AppCollections.kBabySitters).doc(babysitter.id).update({
        if( !unBlock )
         "status" : response.name,
        if( unBlock )
          "canceledRequests" : 0,
      });
      if( unBlock )
        {
          blockedBabysitters.remove(babysitter);
          getBlockedBabysitter();
        }
      else
        {
          inactiveBabysitters[inactiveBabysitters.indexOf(babysitter)].status = response.name;
        }
      emit(UpdateBabysitterStatusAsAdminState(babySitter: babysitter,status: ApiRequestStatus.Success, response: response));
      context.pop;
      if( babysitter.fcmToken != null )
      {
        if( unBlock )
          {
            await NotificationsService.pushNotifyToSpecificUser(
                notification: NotificationModel(
                    arTxt: "تم فك الحظر عن حسابك، يمكنك تسجيل الدخول الآن.",
                    enTxt: "Your account ban has been lifted, you can log in now.",
                    seen: false,
                    sentAt: DateTime.now()
                ),
                receiverFCMToken: babysitter.fcmToken!,
                receiverType: UserType.Babysitter,
                receiverUid: null
            );
          }
        else
          {
            await NotificationsService.pushNotifyToSpecificUser(notification: NotificationModel(arTxt: response == ResponseOfInactiveBabysitterRequest.Accepted ? "تم تفعيل حسابك، قم بتسجيل الدخول الآن." : "تم رفض تفعيل حسابك.",enTxt: response == ResponseOfInactiveBabysitterRequest.Accepted ? "You're account has been activated, login now." : "You're account activation has been rejected.", seen: false, sentAt: DateTime.now()), receiverFCMToken: babysitter.fcmToken!, receiverType: UserType.Babysitter, receiverUid: null);
          }
      }
    }
    on FirebaseException catch(error){
      showSnackBarWidget(message: AppConstants.kFormattedFirebaseErrorCode(error), successOrNot: false, context: context);
      emit(UpdateBabysitterStatusAsAdminState(babySitter: babysitter,status: ApiRequestStatus.Failure, response: response));
    }
  }

  void logOut(BuildContext context) async {
    context.pushAndRemovePreviousRoutes(const AdminLoginPage());
    await CacheManagerService.clearAll();
  }
}
