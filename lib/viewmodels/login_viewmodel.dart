import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vstextile/models/home/HomeData.dart';
import 'package:vstextile/models/categories/categories_data.dart';
import 'package:vstextile/models/news_article.dart';
import 'package:vstextile/services/web_service.dart';
import 'package:vstextile/utils/amplitude.dart';
import 'package:vstextile/utils/constant.dart';

import '../models/product/product_list_data.dart';
import '../models/profile/UserData.dart';
import '../screen/bottombar.dart';
import '../screen/edit_profile_screen.dart';
import '../screen/onboarding_screen.dart';
import '../screen/otp_screen.dart';

enum LoadingStatus {
  completed,
  searching,
  empty,
}

class LoginViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  Future<void> submitPhoneNumber(
      BuildContext context, String mobileNumber) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();

    /// NOTE: Either append your phone number country code or add in the code itself
    /// Since I'm in India we use "+91 " as prefix `phoneNumber`

    String phoneNumber = "+91 " + mobileNumber;
    print(phoneNumber);

    /// The below functions are the callbacks, separated so as to make code more readable
    void verificationCompleted(AuthCredential phoneAuthCredential) {
      print('verificationCompleted');
      print(phoneAuthCredential);
    }

    void verificationFailed(FirebaseAuthException error) {
      loadingStatus = LoadingStatus.empty;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.message!),
      ));
      print(error);
    }

    void codeSent(String verificationId, [int? code]) {
      loadingStatus = LoadingStatus.completed;
      notifyListeners();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => OTPScreen(
            verificationID: verificationId,
            mboileNumber: mobileNumber,
          ),
        ),
      );
      print('codeSent ' + code!.toString());
    }

    void codeAutoRetrievalTimeout(String verificationId) {
      loadingStatus = LoadingStatus.empty;
      notifyListeners();
      print('codeAutoRetrievalTimeout');
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      /// Make sure to prefix with your country code
      phoneNumber: phoneNumber,

      /// `seconds` didn't work. The underlying implementation code only reads in `milliseconds`
      timeout: Duration(milliseconds: 10000),

      /// If the SIM (with phoneNumber) is in the current device this function is called.
      /// This function gives `AuthCredential`. Moreover `login` function can be called from this callback
      verificationCompleted: verificationCompleted,

      /// Called when the verification is failed
      verificationFailed: verificationFailed,

      /// This is called after the OTP is sent. Gives a `verificationId` and `code`
      codeSent: codeSent,

      /// After automatic code retrival `tmeout` this function is called
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    ); // All the callbacks are above
  }

  dynamic getProfile(BuildContext context) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();
    final user = await FirebaseAuth.instance.currentUser!;
    final idToken = await user.getIdToken();
    dynamic result = await WebService().getProfile(idToken, context);
    dynamic finalData;
    if (result is String) {
      finalData = result;
      if (finalData == "User not found.") {
        loadingStatus = LoadingStatus.empty;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => EditProfileScreen(null),
          ),
        );
      }
    } else {
      Map<String, dynamic> data =
          Map<String, dynamic>.from(result as Map<dynamic, dynamic>);
      finalData = UserData.fromJson(data);

      redirection(context);
    }

    if (result == null) {
      loadingStatus = LoadingStatus.empty;
    } else {
      loadingStatus = LoadingStatus.completed;
    }
    notifyListeners();
    return finalData;
  }

  Future<void> login(context, phoneAuthCredential) async {
    loadingStatus = LoadingStatus.searching;
    notifyListeners();
    try {
      await FirebaseAuth.instance
          .signInWithCredential(phoneAuthCredential)
          .then((UserCredential authRes) {
        print(authRes.user.toString());

        loadingStatus = LoadingStatus.completed;
        analytics.logEvent(submit_otp, eventProperties: {status: "success"});
        analytics.logEvent(login_success);
        notifyListeners();
        getProfile(context);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      analytics.logEvent(submit_otp, eventProperties: {status: "failure"});

      print(e.toString());
    }
  }

  void redirection(context) async {
    final prefs = await SharedPreferences.getInstance();
    bool? isWalkthroughShown = await prefs.getBool("walkthroughShown");
    if (isWalkthroughShown != null && isWalkthroughShown)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => HomePage(),
        ),
      );
    else
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => OnboardingScreen(),
        ),
      );
  }
}
