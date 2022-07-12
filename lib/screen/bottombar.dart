import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vstextile/screen/home_screen.dart';
import 'package:vstextile/screen/orders_screen.dart';
import 'package:vstextile/screen/product_listing_screen.dart';
import 'package:vstextile/utils/amplitude.dart';
import 'package:vstextile/utils/constant.dart';
import 'package:vstextile/viewmodels/profile_viewmodel.dart';

import '../providers/NavigationProvider.dart';
import '../utils/colors.dart';
import 'ProfileScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;

  var pages = [const HomeScreen(), const OrdersScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: const Color(0xffC4DFCB),
          body: IndexedStack(
            index: provider.currentTabIndex,
            children: pages,
          ),

          //pages[provider.currentTabIndex],
          bottomNavigationBar: buildMyNavBar(context, provider),
        );
      },
    );
  }

  Container buildMyNavBar(BuildContext context, NavigationProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10,
          ),
        ],
      ),
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              IconButton(
                  enableFeedback: false,
                  onPressed: () {
                    setState(() {
                      analytics.logEvent(tab_changed,
                          eventProperties: {source: "home"});

                      provider.setTab(0);
                    });
                  },
                  icon: provider.currentTabIndex == 0
                      ? Image.asset("assets/images/home.png")
                      : SvgPicture.asset("assets/images/ic_home.svg")),
              Text(
                "Home",
                style: TextStyle(
                    fontSize: 11,
                    color: provider.currentTabIndex == 0
                        ? CustomColors.app_secondary_color
                        : CustomColors.text_color_light),
              )
            ],
          ),
          Column(
            children: [
              IconButton(
                  enableFeedback: false,
                  onPressed: () {
                    setState(() {
                      analytics.logEvent(tab_changed,
                          eventProperties: {source: "orders"});
                      provider.setTab(1);
                    });
                  },
                  icon: provider.currentTabIndex == 1
                      ? Image.asset("assets/images/orders_selected.png")
                      : SvgPicture.asset("assets/images/ic_orders.svg")),
              Text(
                "Orders",
                style: TextStyle(
                    fontSize: 11,
                    color: provider.currentTabIndex == 1
                        ? CustomColors.app_secondary_color
                        : CustomColors.text_color_light),
              )
            ],
          ),
          Column(
            children: [
              IconButton(
                  enableFeedback: false,
                  onPressed: () {
                    setState(() {
                      analytics.logEvent(tab_changed,
                          eventProperties: {source: "profile"});
                      provider.setTab(2);
                    });
                  },
                  icon: provider.currentTabIndex == 2
                      ? Image.asset("assets/images/user.png")
                      : SvgPicture.asset("assets/images/user.svg")),
              Text(
                "Profile",
                style: TextStyle(
                    fontSize: 11,
                    color: provider.currentTabIndex == 2
                        ? CustomColors.app_secondary_color
                        : CustomColors.text_color_light),
              )
            ],
          )
        ],
      ),
    );
  }
}

class BottomNavigationBarProvider with ChangeNotifier {
  int currentIndex = 0;

  set currentIndexItem(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
