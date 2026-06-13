import 'dart:io';
import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Constants/strings.dart';
import 'package:carebuddy/Features/BabySitter/View/Screens/account_under_review_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/Components/show_snackbar_widget.dart';
import '../../../../Core/Constants/firebase_exception_code.dart';
import '../../../../Core/Services/notifications_service.dart';
import '../../../../Core/Services/pick_file_service.dart';
import '../../../../Core/Services/supabase_service.dart';
import '../../Models/baby_sitter.dart';
import '../../Models/babysitter_multi_media.dart';
import 'babysitter_auth_state.dart';

class BabysitterAuthCubit extends Cubit<BabysitterAuthStates> {
  BabysitterAuthCubit() : super(AuthInitial());

  static BabysitterAuthCubit getInstance(BuildContext context) => BlocProvider.of<BabysitterAuthCubit>(context);

  int indexOfRegisterContentShown = 0;
  void changeIndexOfRegisterContentShown(bool plusOrMinus){
    plusOrMinus ? ++indexOfRegisterContentShown : --indexOfRegisterContentShown;
    emit(ChangeIndexOfRegisterContentShownState());
  }

  int pricePerHour = 0;
  void changePricePerHour(int value){
    pricePerHour = value;
    emit(ChangePricePerHourState());
  }

  bool availabilityStatus = true;
  void changAvailabilityStatus(){
    availabilityStatus = !availabilityStatus;
    emit(ChangeIndexOfRegisterContentShownState());
  }

  File? identificationImage;
  File? securityClearanceMedia;
  File? medicalHistoryMedia;
  File? certificateMedia;
  File? profileImage;
  File? introVideo;
  void getIdentificationImage() async {
    await PickFileService.chooseImage().then((file) async {
      if( file != null )
        {
          identificationImage = file;
          emit(GetIdentificationImageState());
        }
    });
  }

  void getSecurityClearanceMedia() async {
    await PickFileService.chooseMedia().then((file) async {
      if (file != null) {
        securityClearanceMedia = file;
        emit(GetSecurityClearanceMediaState());
      }
    });
  }

  void getMedicalHistoryMedia() async {
    await PickFileService.chooseMedia().then((file) async {
      if (file != null) {
        medicalHistoryMedia = file;
        emit(GetMedicalHistoryMediaState());
      }
    });
  }

  void getCertificateMedia() async {
    await PickFileService.chooseMedia().then((file) async {
      if (file != null) {
        certificateMedia = file;
        emit(GetCertificateMediaState());
      }
    });
  }

  void getProfileImage() async {
    await PickFileService.chooseImage().then((file) async {
      if (file != null) {
        profileImage = file;
        emit(GetProfileImageState());
      }
    });
  }

  void getIntroVideo() async {
    await PickFileService.chooseVideo().then((file) async {
      if (file != null) {
        introVideo = file;
        emit(GetIntroVideoState());
      }
    });
  }

  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore _cloudFirestore = FirebaseFirestore.instance;

  Future<bool> checkIfAccountAlreadyOrNot(String email) async {
    QuerySnapshot querySnapshot = await _cloudFirestore.collection(AppCollections.kParents).where("email",isEqualTo: email.trim()).get();
    return querySnapshot.docs.isNotEmpty ? true : false;
  }

  Future<void> createAccount({required BuildContext context,required String email,required String nationality,required String password,required String fName,required String lname,required String phone,required String city,required String? bio}) async {
    try{
      emit(CreateAccountUsingEmailLoadingState());
      await checkIfAccountAlreadyOrNot(email).then((exist) async {
        if( !exist )
        {
          await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password).then((userCredential) async {
            await uploadMainDataOfUser(context: context,email: email,userID: userCredential.user!.uid,nationality: nationality,password: password,fName: fName,bio: bio,city: city,lname: lname,phone: phone);
          });
        }
        else
        {
          emit(CreateAccountUsingEmailWithFailureState());
          showSnackBarWidget(message: "Sorry, but account already exist !.", successOrNot: false, context: context);
        }
      });
    }
    on FirebaseAuthException catch (error){
      if( error.code == FirebaseExceptionCodes.kEmailAlreadyInUse )
        {
          await uploadMainDataOfUser(context: context,email: email,password: password,nationality: nationality,fName: fName,bio: bio,city: city,lname: lname,phone: phone);
        }
      else
        {
          showSnackBarWidget(context: context,successOrNot: false,message: error.code == FirebaseExceptionCodes.kInvalidEmailEntered ? "Invalid Email Entered." : error.code.replaceAll("-"," "));
          emit(CreateAccountUsingEmailWithFailureState());
        }
    }
  }

  Future<void> uploadMainDataOfUser({required String email,required String fName,required String lname,required String nationality,required String phone,required String city,required String? bio,required BuildContext context,String? userID,required String password}) async {
    try{
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(AppCollections.kBabySitters).where('email', isEqualTo: email).get();
      if( querySnapshot.docs.isNotEmpty )
        {
          // TODO: Mean His Data already sent to CloudStore
          showSnackBarWidget(message: "Email already in use, Sign in with it.", successOrNot: false, context: context);
          emit(UploadMainDataOfUserSuccessfullyState());
        }
      else
        {
          BabysitterMedia? multiMediaModel = await uploadMultiMediaOfUserToStorage(context: context);
          if( multiMediaModel != null )
            {
              String? uid = userID;
              if( uid == null )
              {
                // TODO: ده عشان لو كان عمل login without storing his data on CloudFirestore
                UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
                uid = userCredential.user!.uid;
              }
              final Babysitter babySitter = Babysitter(availabilityStatus: availabilityStatus,canceledRequests: 0,services: const [],fcmToken: await NotificationsService.getFCMToken(),id: uid,fName: fName, lname: lname, email: email, phone: phone, city: city, nationality: nationality, bio: bio, status: ResponseOfInactiveBabysitterRequest.Pending.name, pricePerHour: pricePerHour, multiMedia: multiMediaModel);
              await _cloudFirestore.collection(AppCollections.kBabySitters).doc(uid).set(babySitter.toJson());
              showSnackBarWidget(context: context,message: "Account Created Successfully.",successOrNot: true);
              emit(UploadMainDataOfUserSuccessfullyState());
              context.push(const AccountUnderReviewScreen());
            }
        }
    }
    on FirebaseException catch(error){
      showSnackBarWidget(context: context,successOrNot: false,message: error.code.replaceAll("-", " "));
      emit(UploadMainDataOfUserWithFailureState());
    }
  }

  Future<BabysitterMedia?> uploadMultiMediaOfUserToStorage({required BuildContext context}) async {
    try{
      final BabysitterMedia multiMediaModel = BabysitterMedia(identification: await SupabaseService.kUploadFile(identificationImage!), securityClearance: await SupabaseService.kUploadFile(securityClearanceMedia!), medicalHistory: await SupabaseService.kUploadFile(medicalHistoryMedia!), certificates: certificateMedia != null ? await SupabaseService.kUploadFile(certificateMedia!) : null, profileImage: profileImage != null ? await SupabaseService.kUploadFile(profileImage!) : null, introVideo: introVideo != null ? await SupabaseService.kUploadFile(introVideo!) : null);
      return multiMediaModel;
    }
    catch(e){
      showSnackBarWidget(context: context,successOrNot: false,message: "Check Internet and try again later.");
      emit(UploadMainDataOfUserWithFailureState());
    }
    return null;
  }
}
