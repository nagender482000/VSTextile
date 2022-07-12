import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vstextile/screen/edit_profile_screen.dart';
import 'package:vstextile/screen/login_screen.dart';
import 'package:vstextile/utils/flutter_walkthrough.dart';
import 'package:vstextile/utils/walkthrough.dart';

class OnboardingScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    //here we need to pass the list and the route for the next page to be opened after this.

    return IntroScreen(
      new MaterialPageRoute(builder: (context) =>  EditProfileScreen(null)),
    );
  }
}