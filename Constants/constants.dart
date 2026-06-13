import 'dart:io';
import 'package:carebuddy/Core/Constants/extensions.dart';
import 'package:carebuddy/Features/Admin/Controller/admin_cubit.dart';
import 'package:carebuddy/Features/Shared/Models/babysitter_request_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Features/BabySitter/Controller/Auth/babysitter_auth_cubit.dart';
import '../../Features/BabySitter/Controller/Layout/babysitter_cubit.dart';
import '../../Features/Parent/Controller/Auth/parent_auth_cubit.dart';
import '../../Features/Parent/Controller/Layout/parents_cubit.dart';
import '../../Features/Shared/Controller/shared_cubit.dart';
import '../Theme/colors.dart';

class AppConstants{
  static dynamic kProviders = [
    BlocProvider(create: (context)=> AdminCubit()),
    BlocProvider(create: (context)=> BabysitterAuthCubit()),
    BlocProvider(create: (context)=> ParentAuthCubit()),
    BlocProvider(create: (context)=> SharedCubit()),
    BlocProvider(create: (context)=> BabysitterCubit()),
    BlocProvider(create: (context)=> ParentsCubit()),
    BlocProvider(create: (context)=> SharedCubit()),
  ];
  static String kFormattedFirebaseErrorCode(FirebaseException error) => error.code.replaceAll("-", " ").toUpperCase();
  static Orientation kGetDeviceOrientation(BuildContext context) => MediaQuery.of(context).orientation;
  static String kGetFileName(File file) => file.path.split('/').last;
  static const String kErrorImageUrl = "https://i.suar.me/3GYwr/l";
  static RegExp kEmailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  static final RegExp kGoogleMapsLinkRegex = RegExp(
      r'^https:\/\/(maps\.(app\.)?goo\.gl\/[a-zA-Z0-9_-]+(\?[a-zA-Z0-9=&_-]+)?|www\.google\.com\/maps\?q=[0-9\.\,-]+|maps\.google\.com\/maps\?q=[0-9\.\,-]+|goo\.gle\/maps\/[a-zA-Z0-9_-]+(\?[a-zA-Z0-9=&_-]+)?)$'
  );
  static final RegExp kMobileRegex = RegExp(r'^\+?[0-9]{1,4}?[-.\s]?\(?[0-9]{1,3}?\)?[-.\s]?[0-9]{1,4}[-.\s]?[0-9]{1,4}[-.\s]?[0-9]{1,9}$');
  static Widget Function(BuildContext, int) kSeparatorBuilder() => (context,index) => 10.vrSpace;
  static BorderRadius kMainRadius = BorderRadius.circular(10);
  static BorderRadius kMaxRadius = BorderRadius.circular(22);
  static EdgeInsets kContainerPadding = const EdgeInsets.all(14);
  static EdgeInsets kScaffoldPadding = const EdgeInsets.all(14).copyWith(top: 0);
  static EdgeInsets kListViewPadding = EdgeInsets.zero.copyWith(bottom: 22);
  static BoxBorder kMainBorder = Border.all(color: AppColors.kBorder);
  static List<String> saudiArabiaCities = [
    "Riyadh",
    "Makkah",
    "Madinah",
    "Eastern Province",
    "Asir",
    "Jazan",
    "Najran",
    "Al-Baha",
    "Qassim",
    "Hail",
    "Tabuk",
    "Al-Jawf",
    "Northern Borders",
  ];
  static List<String> countries = [
    "Sudan",
    "Somalia",
    "Ethiopia",
    "Eritrea",
    "Kenya",
    "Nigeria",
    "Uganda",
    "Ghana",
    "Tanzania",
    "India",
    "Pakistan",
    "Bangladesh",
    "Philippines",
    "Indonesia",
    "Nepal",
    "Sri Lanka",
    "Vietnam",
    "Thailand",
    "Myanmar (Burma)",
  ];

  static RegExp kPasswordRegExp = RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+{}|:"<>?~`]).{8,}$');
  static InputBorder kEnabledInputBorder = OutlineInputBorder(borderRadius: AppConstants.kMainRadius, borderSide: BorderSide(color: AppColors.kBorder));
  static InputBorder kFocusedInputBorder = OutlineInputBorder(borderRadius: AppConstants.kMainRadius, borderSide: BorderSide(color: AppColors.kMain));
  static InputBorder kErrorInputBorder = OutlineInputBorder(borderRadius: AppConstants.kMainRadius, borderSide: BorderSide(color: AppColors.kRed));
  static BoxBorder kSkeletonLoadingBorder = Border.all(color: AppColors.kBorder);
  static int kGetTotalPriceOfSession (BabysitterRequestModel request)=> request.babySitter.pricePerHour * (request.endAt.difference(request.startAt).inMinutes / 60).toInt();
}