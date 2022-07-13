import 'package:flutter/material.dart';
import 'package:vstextile/screen/edit_profile_screen.dart';
import 'package:vstextile/utils/flutter_walkthrough.dart';

class OnboardingScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    //here we need to pass the list and the route for the next page to be opened after this.

    return IntroScreen(
      new MaterialPageRoute(builder: (context) =>  EditProfileScreen(null)),
    );
  }
}