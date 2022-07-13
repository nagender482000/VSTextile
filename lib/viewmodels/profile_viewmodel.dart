// ignore_for_file: unnecessary_this

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vstextile/models/profile/UserData.dart';
import 'package:vstextile/services/web_service.dart';

enum LoadingStatus {
  completed,
  searching,
  empty,
}

class ProfileViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;
  List<String> articles = <String>[];

  dynamic getProfile(BuildContext context) async {
    this.loadingStatus = LoadingStatus.searching;
    notifyListeners();
    final user = FirebaseAuth.instance.currentUser!;
    final idToken = await user.getIdToken();
    dynamic result = await WebService().getProfile(idToken, context);
    dynamic finalData;
    if (result is String) {
      finalData = result;
    } else {
      Map<String, dynamic> data =
          Map<String, dynamic>.from(result as Map<dynamic, dynamic>);
      finalData = UserData.fromJson(data);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', jsonEncode(finalData));
    }

    if (result == null) {
      this.loadingStatus = LoadingStatus.empty;
    } else {
      this.loadingStatus = LoadingStatus.completed;
    }
    notifyListeners();
    return finalData;
  }

  dynamic editProfile(
      BuildContext context,
      String username,
      String shopName,
      String gstNumber,
      String address,
      String referenceName,
      String email,
      bool isFromAdd) async {
    var params = {
      "username": username,
      "shop_name": shopName,
      "gst_number": gstNumber,
      "address": address,
      "reference_name": referenceName,
      "email": email,
    };
    this.loadingStatus = LoadingStatus.searching;
    //notifyListeners();
    final user = FirebaseAuth.instance.currentUser!;
    final idToken = await user.getIdToken();

    dynamic result = "";

    if (isFromAdd) {
      result = await WebService().addProfile(context, idToken, params);
    } else {
      result = await WebService().editProfile(context, idToken, params);
    }
    if (result == null) {
      this.loadingStatus = LoadingStatus.empty;
    } else {
      this.loadingStatus = LoadingStatus.completed;
    }
    print(result);
    notifyListeners();
    return result;
  }
}
