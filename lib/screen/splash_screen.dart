import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:vstextile/screen/login_screen.dart';
import 'package:vstextile/screen/update_page.dart';

import 'bottombar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

//var isLoggedIn = false;

class _SplashScreenState extends State<SplashScreen> {
  int reqversion = 0;
  int curversion = 0;
  setupRemoteConfig() async {
    final RemoteConfig remoteConfig = RemoteConfig.instance;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    await remoteConfig.fetch();
    await remoteConfig.activate();
    reqversion = remoteConfig.getInt("build_number");
    curversion = int.parse(packageInfo.buildNumber);
  }

  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () async => {
              if (reqversion > curversion)
                {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const UpdatePage()),
                    (route) => false,
                  )
                }
              else
                {
                  if (FirebaseAuth.instance.currentUser != null)
                    {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => HomePage(),
                        ),
                        (route) => false,
                      )
                    }
                  else
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => LoginScreen(),
                      ),
                      (route) => false,
                    )
                }
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/splash_bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/images/logo.svg"),
            SvgPicture.asset("assets/images/title.svg"),
          ],
        ) /* add child content here */,
      ),
    );
  }
}
