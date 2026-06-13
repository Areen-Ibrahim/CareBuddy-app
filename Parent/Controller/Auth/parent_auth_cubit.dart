import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carebuddy/Core/Components/show_awesome_dialog_widget.dart';
import 'package:carebuddy/Core/Constants/enum.dart';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Core/Constants/firebase_exception_code.dart';
import 'package:carebuddy/Core/Constants/strings.dart';
import 'package:carebuddy/Core/Constants/translation_keys.dart';
import 'package:carebuddy/Core/Services/notifications_service.dart';
import 'package:carebuddy/Features/Parent/Models/parent.dart';
import 'package:carebuddy/Features/Shared/View/Screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/Components/show_snackbar_widget.dart';
import '../../../../Core/Services/cache_manager_service.dart';
import '../../../../Core/Services/pick_file_service.dart';
import '../../../../Core/Services/supabase_service.dart';
import '../../../Shared/Models/cached_user_model.dart';
import 'parent_auth_state.dart';

class ParentAuthCubit extends Cubit<ParentAuthStates> {
  ParentAuthCubit() : super(AuthInitial());

  static ParentAuthCubit getInstance(BuildContext context) => BlocProvider.of<ParentAuthCubit>(context);

  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore _cloudFirestore = FirebaseFirestore.instance;
  File? parentProfileImage;
  void getParentProfileImage() async {
    await PickFileService.chooseImage().then((file) async {
      if (file != null) {
        parentProfileImage = file;
        emit(GetParentProfileImage());
      }
    });
  }

  GenderStatus genderChosen = GenderStatus.Male;
  void chooseGender(GenderStatus gender){
    genderChosen = gender;
    emit(ChooseGenderState());
  }

  Future<bool> checkIfAccountAlreadyOrNot(String email) async {
    QuerySnapshot querySnapshot = await _cloudFirestore.collection(AppCollections.kParents).where("email",isEqualTo: email.trim()).get();
    return querySnapshot.docs.isNotEmpty ? true : false;
  }

  Future<void> createAccount({required BuildContext context,required String email,required String locationUrl,required String password,required String fName,required String city,required String lname,required String phone}) async {
    try{
      emit(CreateParentAccountState(status: ApiRequestStatus.Loading));
      await checkIfAccountAlreadyOrNot(email).then((exist) async {
        if( !exist )
          {
            await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password).then((userCredential) async {
              await uploadParentDataOnCloudStore(context: context,email: email,userID: userCredential.user!.uid,locationUrl: locationUrl,password: password,fName: fName,gender: genderChosen.name,city: city,lname: lname,phone: phone);
            });
          }
        else
          {
            emit(CreateParentAccountState(status: ApiRequestStatus.Failure));
            showSnackBarWidget(message: TranslationKeys.accountAlreadyExist.tr(context), successOrNot: false, context: context);
          }
      });
    }
    on FirebaseException catch (error){
      if( error.code == FirebaseExceptionCodes.kEmailAlreadyInUse )
        {
          await uploadParentDataOnCloudStore(email: email, fName: fName, lname: lname, locationUrl: locationUrl, phone: phone, city: city, gender: genderChosen.name, context: context, password: password);
        }
      else
        {
          showSnackBarWidget(context: context,successOrNot: false,message: error.code.replaceAll("-"," "));
          emit(CreateParentAccountState(status: ApiRequestStatus.Failure));
        }
    }
  }

  Future<void> uploadParentDataOnCloudStore({required String email,required String fName,required String lname,required String locationUrl,required String phone,required String city,required String gender,required BuildContext context,String? userID,required String password}) async {
    try{
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(AppCollections.kParents).where('email', isEqualTo: email).get();
      if( querySnapshot.docs.isEmpty )
      {
        String? uid = userID;
        if( uid == null )
        {
          // TODO: ده عشان لو كان عمل login without storing his data on CloudFirestore
          UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
          uid = userCredential.user!.uid;
        }
        final Parent parent = Parent(canceledRequests : 0,fcmToken: await NotificationsService.getFCMToken(),kids: const [],favorites: const [],id: uid,fName: fName, lname: lname, email: email, phone: phone, city: city, locationUrl: locationUrl, gender: gender, profileImage: parentProfileImage != null ? await SupabaseService.kUploadFile(parentProfileImage!) : SupabaseService.defaultAccountImageUrl);
        await _cloudFirestore.collection(AppCollections.kParents).doc(uid).set(parent.toJson());
        await CacheManagerService.writeUserID(cachedUserEntity: CachedUserEntity(type: UserType.Parent.name, id: uid));
      }
      emit(CreateParentAccountState(status: ApiRequestStatus.Success));
      showAwesomeDialogWidget(title: "Congratulations", desc: "Account created successfully.",okBtnText: "Login now", context: context, type: DialogType.success,okBtnMethod: ()=> context.push(const LoginScreen(userType: UserType.Parent)),showOnlyOkBtn: true);
    }
    on FirebaseException catch(error){
      showSnackBarWidget(context: context,successOrNot: false,message: error.code.replaceAll("-", " "));
      emit(CreateParentAccountState(status: ApiRequestStatus.Failure));
    }
    catch(e){
      showSnackBarWidget(context: context,successOrNot: false,message: "Something went wrong while uploading image, try again later !.");
      emit(CreateParentAccountState(status: ApiRequestStatus.Failure));
    }
  }

}
