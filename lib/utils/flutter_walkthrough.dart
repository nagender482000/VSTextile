import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vstextile/screen/bottombar.dart';
import 'package:vstextile/utils/amplitude.dart';
import 'package:vstextile/utils/walkthrough.dart';

import '../screen/edit_profile_screen.dart';
import '../viewmodels/profile_viewmodel.dart';

class IntroScreen extends StatefulWidget {
  final MaterialPageRoute pageRoute;
  dynamic result = "";

  IntroScreen(this.pageRoute);

  void skipPage(BuildContext context) {
    analytics
        .logEvent(onboarding_skip);

    redirection(context);
  }

  @override
  IntroScreenState createState() {
    return IntroScreenState();
  }

  void redirection(BuildContext context) async {
    if (await result is String && await result == "User not found.") {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => EditProfileScreen(null),
          ));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const HomePage(),
          ));
    }
  }
}

class IntroScreenState extends State<IntroScreen> {
  final PageController controller = PageController();
  int currentPage = 0;
  bool lastPage = false;
  late List<Walkthrough> list;

  void _onPageChanged(int page) {
    setState(() {
      currentPage = page;
      if (currentPage == list.length - 1) {
        lastPage = true;
      } else {
        lastPage = false;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callApi();
    list = [
      Walkthrough(
          title: "",
          content: "35000+ retailers & wholesalers",
          imageIcon: "assets/images/onboarding_one.svg",
          progressImg: "assets/images/progress_img_one.png",
          controller: controller,
          isLast: false),
      Walkthrough(
          title: "",
          content: "5 Lakh+ Order per Annum",
          imageIcon: "assets/images/onboarding_two.svg",
          progressImg: "assets/images/progress_img_two.png",
          controller: controller,
          isLast: false),
      Walkthrough(
          title: "",
          content: "300+ employees",
          imageIcon: "assets/images/onbaording_three.svg",
          progressImg: "assets/images/progress_img_three.png",
          controller: controller,
          isLast: false),
    ];
  }

  Future<void> callApi() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('walkthroughShown', true);
    Future.delayed(Duration(milliseconds: 200), () async {
      var vs = Provider.of<ProfileViewModel>(context, listen: false);
      var result = await vs.getProfile(context);
      widget.result = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 50),
          Expanded(
            flex: 9,
            child: PageView(
              children: list,
              controller: controller,
              onPageChanged: _onPageChanged,
            ),
          ),
          Expanded(
            child: GestureDetector(
              child: Image.asset(list[currentPage].progressImg),
              onTap: () {
                analytics.logEvent(onboarding_next);
                if (controller.page != 2.0) {
                  controller.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn);
                } else {
                  widget.redirection(context);
                }
              },
            ),
            flex: 2,
          ),
          Expanded(
              flex: 1,
              child: GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                        child: Text(
                      "SKIP",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    )),
                    SizedBox(
                      width: 5,
                    ),
                    Stack(children: [
                      Container(
                        child: SvgPicture.asset("assets/images/skip_bg.svg"),
                        height: 25,
                        width: 25,
                      ),
                      Positioned(
                          left: 8,
                          top: 8,
                          child: Container(
                            child: SvgPicture.asset(
                                "assets/images/skip_arrow.svg"),
                            height: 10,
                            width: 10,
                          ))
                    ]),
                  ],
                ),
                onTap: () {
                  widget.skipPage(context);
                },
              ))
        ],
      ),
    );
  }
}
