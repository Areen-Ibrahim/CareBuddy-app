import 'package:carebuddy/Core/Constants/strings.dart';
import 'package:carebuddy/Core/Services/local_notifications_service.dart';
import 'package:carebuddy/Features/Shared/Models/notification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import '../../firebase_options.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import "package:http/http.dart" as http;
import 'dart:convert';

import '../Constants/enum.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

class NotificationsService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static Future<void> initialize() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await NotificationsService.requestPermission();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if( message.notification != null )
      {
        LocalNotificationService.showImmediatelyNotify(body: message.notification!.body!);
      }
    });
  }
  static Future<String?> getFCMToken() async {
    return await _firebaseMessaging.getToken();
  }

  static Future<void> requestPermission() async {
    await _firebaseMessaging.requestPermission(alert: true, badge: true, sound: true,);
  }

  static Future<String> getAccessTokenOfFirebaseFCM() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "carebuddy-3649e",
      "private_key_id": "020897aa2c0919c2b5abe2530b376923e780141c",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDDugKboM6tUyZB\n/wzpJTt5s/4rhy/N0T1jNfP/fT86/UKRouDyjO5h13f/nV2zK6ustNROwRHUPb1w\nZzIpM5IJYChS2gBOyHzBziL3dx1GT7k3gwr6Ye9fK0fpkOUwfYgCQZ7NaaH+pVRc\nIR8p/u3Jkyt21dl8VCWcEJiqIV5yunGkrkrRwLFDyZI6bqak28JFGfU0mFTx9tiY\nKz8k2Q99QMJGsYitSE+WPdf2A6keujEX5QrvVSBzEhF8cmQ0h3mlTP6yT0sGIUQG\nA7BTK6MGpTk4ckqs118zdyqgsc7faxPrTmQVeDQaPoXvbsgr+ZksQmp4hDNrH0rA\nuY/uQWX7AgMBAAECggEAGcBK4IvvNUmn0m4KllAiO5htW++83+DkKT3rfNVPMOUq\nUXvzCaZ2JKRTMuvS7KRVwXLHLhdjz59R4cyKAna5A4fFtmTdPoBNPbhvzEw9K0eI\n8F9K3fdtpYFNxFKefNs/PkDA8niv6g95gmePMJjMU0WMJeXr59owWpCqbVPXl9Np\n0WAoHQ7JkpKOEX7kdvHKaypSuXr6vM1CpC6EMqdstGZS2bLi+ICZB1EXc7QSgNji\nHq6Qb55s+ZA9NfZUJkQQYR1/ZsWG5p4jQQ5ERJ41lsC+IXh6EVN8r3SNOcXqgo73\nBDC60WAZiTzp3vq5E4lQMd+Ayp42wxI72KMQ4ybNuQKBgQDypIO0pujWdC4gea28\ngK1t2C/2QsNvcIY+RQy/vVk05zXQ8EM9m50i86m+VnAphsbP+5eWCWp4JBtspIJr\nS0znPmoCjMrvoe5yaQVcpljksJ4SHnd0T6dav/I7EI20dxh+w/YXL1j+sq/iKCU1\nxT8AwtwcWJCiDiQWodqmL4bz8wKBgQDOgFKu1UuJeuI4dwzF7LaBhod1dQob45CJ\nLjmUDGhYADozj1qamKp9ljWLiMJEvGnA33pFE8qaxS6G2dJPFTFohOgbHqz3rI0j\njR+oqlwRPu8uhIDmfczWoHZpgQ3ubEHZqIDAoGISlU+EHhUnJ3aZU5n5rvtSBsbz\nujIDlWEv2QKBgQDXiZwVFU8vcPSolG3oTMXCFZBFSPkiPOqC1gOFL0XW4KvFdifE\nyj7DlX7rPQ1VVgu1JOB6vtJ89lYGI/xWIwWlRKQWr8p1I3sU1oWUz4+XVeyUW8vw\n3fDjhC5AmWvHKyPvN1ObNMvxM/lZBCBJq3VTz8SGyYVw7u7Py+bWSNGwUQKBgQDN\nurKlVALpeO+f6ZtkJKy+5lRWBMCJgHIi+VaL1MCvy6owbAWMN8TDUb8OwLUq3btO\nWFbsMweKoh/0YVZRS3/p7V+AhVM1fUcvwA1mcDNBSz3nTkNNXs+QlFTkT5qdimUg\nf+ul/SM3+GE78uyIEZzqrIueYWIpGm9jqoDhaRVmIQKBgB10qdUtkRlQqWIuET3O\nlybTE/0X5mtaXwEfSl/05+d7+ARSi10vC89TYKbnLcjiAwaMwA0o7njDw0e/a5Wr\n4YgDZAH5fHHd65YbSUG1Xzw5VPm6aG2zvVuo77sRbE/Y04lYwrJucqwjtZuqBLoV\nXI8M/b/7qtnXnHAekL2saZ0s\n-----END PRIVATE KEY-----\n",
      "client_email": "firebase-adminsdk-fbsvc@carebuddy-3649e.iam.gserviceaccount.com",
      "client_id": "106841528101308396171",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40carebuddy-3649e.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };
    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging",
    ];
    http.Client client = await auth.clientViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
        scopes
    );
    auth.AccessCredentials credentials = await auth.obtainAccessCredentialsViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
        scopes,
        client
    );
    client.close();
    return credentials.accessToken.data;
  }

  static final FirebaseFirestore _cloudStore = FirebaseFirestore.instance;
  static String? _serverKeyOfFirebaseFCM;
  static Future<void> pushNotifyToSpecificUser({required NotificationModel notification,required String receiverFCMToken,required UserType receiverType,required String? receiverUid}) async {
    try{
      _serverKeyOfFirebaseFCM ??= await getAccessTokenOfFirebaseFCM();
      debugPrint("Token $_serverKeyOfFirebaseFCM");
      http.Response response = await http.post(
          Uri.parse("https://fcm.googleapis.com/v1/projects/carebuddy-3649e/messages:send"),
          headers: <String,String>{
            'Content-Type' : 'application/json',
            'Authorization': "Bearer $_serverKeyOfFirebaseFCM"
          },
          body: jsonEncode(
              {
                "message" : {
                  "token": receiverFCMToken,
                  "notification":
                  {
                    "title": "Carebuddy",
                    "body": notification.enTxt
                  },
                  "data": {}
                }
              }
          )
      );
      if( receiverUid != null )
      {
        await _cloudStore.collection(receiverType == UserType.Parent ? AppCollections.kParents : AppCollections.kBabySitters).doc(receiverUid).collection(AppCollections.kNotifications).add(notification.toJson());
      }
    }
    catch(e){
      debugPrint("Exception while pushing notify ${e.toString()}");
    }
  }
}
