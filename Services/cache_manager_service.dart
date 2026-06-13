import 'package:carebuddy/Features/Shared/Models/cached_user_model.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../Constants/enum.dart';
import '../Constants/strings.dart';

class CacheManagerService{
  static final GetStorage storage = GetStorage();

  static Future<void> init() async {
    await GetStorage.init();
  }

  static Future<void> clearAll() async {
    await storage.erase();
  }

  static Future<void> writeUserID({required CachedUserEntity cachedUserEntity}) async {
    try{
      storage.write(AppStrings.kUserID, cachedUserEntity.toJson());
    }
    catch(e){}
  }

  static Future<void> writeAdminAlreadyLogin() async {
    try{
      storage.write(AppStrings.kAdminAlreadyLogin, true);
    }
    catch(e){}
  }

  static bool? readAlreadyAdminLogin(){
    try{
      return storage.read(AppStrings.kAdminAlreadyLogin) as bool;
    }
    catch(e){
      return null;
    }
  }

  static CachedUserEntity? readUserID(){
    try{
      return CachedUserEntity.fromJson(json: storage.read(AppStrings.kUserID) as Map<String,dynamic>);
    }
    catch(e){
      return null;
    }
  }

  static Future<void> writeAppLanguage({required LanguageName lang}) async {
    try{
      await storage.write(AppStrings.kCurrentAppLanguage, lang.name);
    }
    catch(e){
      debugPrint("Exception while writeLanguageName $e");
    }
  }

  static String readCurrentLanguage(){
    try{
      return storage.read(AppStrings.kCurrentAppLanguage) ?? LanguageName.en.name;
    }
    catch(e){
      debugPrint("Exception while readCurrentAppLanguage $e");
      return LanguageName.en.name;
    }
  }
}