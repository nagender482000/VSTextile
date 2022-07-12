import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vstextile/screen/login_screen.dart';
import 'package:vstextile/screen/login_screen_second.dart';
import 'package:vstextile/utils/colors.dart';

class BenefitScreen extends StatefulWidget {
  const BenefitScreen({Key? key}) : super(key: key);

  @override
  _BenefitScreenState createState() => _BenefitScreenState();
}

//var isLoggedIn = false;

class _BenefitScreenState extends State<BenefitScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: CustomColors.app_color,
        elevation: 50.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          tooltip: 'Back Icon',
          onPressed: () {},
        ), //IconButton
      ), //AppBar
      body:  Center(
        child: GestureDetector(child:Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
          Image.asset("assets/images/benefit_listing.png",width: 150),
          Image.asset("assets/images/benefit_sellers.png",width: 120),
          Image.asset("assets/images/benefit_employees.png",width: 200,),
        ],
        ),onTap: (){
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => LoginScreen(),
            ),
                (route) => false,
          );
        },),
      ), //Center
    );
  }


}
