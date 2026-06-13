import 'dart:io';
import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../Constants/constants.dart';

class SupabaseService{
  static const kBaseUrl = "https://epndsvpxwsvgakzcxsqe.supabase.co";
  static const String kBucketName = "carebuddy";
  static const String kServiceRole = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVwbmRzdnB4d3N2Z2FremN4c3FlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc0MjkzNTY2MSwiZXhwIjoyMDU4NTExNjYxfQ.Wxcoc0mHZLPKX3AK_gq6VlY2WXl4vVJ7sAnFTD-OPKI";
  static const kBaseUrlOfFileAccessOnSpecificBucket = "$kBaseUrl/storage/v1/object/public/";
  static Future<void> kInitialize() async {
    await Supabase.initialize(
      url: kBaseUrl,
      anonKey: kServiceRole
    );
  }
  static SupabaseClient kSupabaseClient = Supabase.instance.client;
  static Future<String> kUploadFile(File file) async {
    try{
      final bool fileExists = await kSupabaseClient.storage.from(kBucketName).list().then((files) => files.any((f) => f.name == AppConstants.kGetFileName(file)));
      return "$kBaseUrlOfFileAccessOnSpecificBucket${fileExists ? await kSupabaseClient.storage.from(kBucketName).update(AppConstants.kGetFileName(file), file, fileOptions: const FileOptions(cacheControl: '3600', upsert: false)) : await kSupabaseClient.storage.from(kBucketName).upload("${Random().nextDouble()*1000000000}${AppConstants.kGetFileName(file)}", file, fileOptions: const FileOptions(cacheControl: '3600', upsert: false))}";
    }
    catch(e){
      return AppConstants.kErrorImageUrl;
    }
  }

  static String defaultAccountImageUrl = "https://i.suar.me/3GYwr/c";
}