import 'dart:developer';

import 'package:carebuddy/Core/Components/show_snackbar_widget.dart';
import 'package:carebuddy/Core/Constants/constants.dart';
import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Constants/strings.dart';
import 'package:carebuddy/Core/Constants/translation_keys.dart';
import 'package:carebuddy/Core/Services/cache_manager_service.dart';
import 'package:carebuddy/Core/Services/error_message_handler.dart';
import 'package:carebuddy/Features/BabySitter/View/Screens/babysitter_layout_screen.dart';
import 'package:carebuddy/Features/Parent/View/Screens/parent_layout_screen.dart';
import 'package:carebuddy/Features/Shared/Models/cached_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'shared_state.dart';

class SharedCubit extends Cubit<SharedStates> {
  SharedCubit() : super(SharedInitialState());

  static SharedCubit getInstance(BuildContext context) => BlocProvider.of<SharedCubit>(context);

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  void signIn({required String email,required BuildContext context,required UserType userType,required String password}) async {
    try{
      emit(SignInState(status: ApiRequestStatus.Loading));
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      DocumentSnapshot snapshot = await _firebaseFirestore.collection(userType == UserType.Parent ? AppCollections.kParents : AppCollections.kBabySitters).doc(userCredential.user!.uid).get();
      if( snapshot.exists )
        {
          if( userType == UserType.Babysitter && ((snapshot.data() as Map<String,dynamic>)["status"] == ResponseOfInactiveBabysitterRequest.Pending.name || ((snapshot.data() as Map<String,dynamic>)["canceledRequests"] != null && (snapshot.data() as Map<String,dynamic>)["canceledRequests"] >= 6)) )
            {
              showSnackBarWidget(message: (snapshot.data() as Map<String,dynamic>)["status"] == ResponseOfInactiveBabysitterRequest.Pending.name ? TranslationKeys.accountPendingApproval.tr(context) : TranslationKeys.accountBlocked.tr(context), successOrNot: false, context: context);
              emit(SignInState(status: ApiRequestStatus.Failure));
              return;
            }
          emit(SignInState(status: ApiRequestStatus.Success));
          await CacheManagerService.writeUserID(cachedUserEntity: CachedUserEntity(type: userType.name, id: userCredential.user!.uid));
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> userType == UserType.Parent ? const ParentLayoutScreen() : const BabysitterLayoutScreen()), (_)=> false);
        }
      else
        {
          showSnackBarWidget(message: TranslationKeys.userNotFound.tr(context), successOrNot: false, context: context);
          emit(SignInState(status: ApiRequestStatus.Failure));
        }
    }
    on FirebaseAuthException catch(e){
      showSnackBarWidget(message: ErrorMessageHandler.error(e.code, context), successOrNot: false, context: context);
      emit(SignInState(status: ApiRequestStatus.Failure));
    }
  }

  void forgetPassword({required String email,required BuildContext context}) async {
    try{
      emit(SendPasswordResetEmailState(status: ApiRequestStatus.Loading));
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      showSnackBarWidget(message: TranslationKeys.resetEmailSentCheckIt.tr(context), successOrNot: true, context: context);
      emit(SendPasswordResetEmailState(status: ApiRequestStatus.Success));
      context.pop;
    }
    on FirebaseAuthException catch(e){
      showSnackBarWidget(message: AppConstants.kFormattedFirebaseErrorCode(e), successOrNot: false, context: context);
      emit(SendPasswordResetEmailState(status: ApiRequestStatus.Loading));
    }
  }

  void toggleLanguage({required LanguageName lang}) async {
    await CacheManagerService.writeAppLanguage(lang: lang);
    emit(ToggleLanguageState());
  }
}
