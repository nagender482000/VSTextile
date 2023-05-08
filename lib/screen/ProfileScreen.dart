import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vstextile/models/profile/UserData.dart';
import 'package:vstextile/screen/edit_profile_screen.dart';
import 'package:vstextile/screen/home_screen.dart';
import 'package:vstextile/utils/amplitude.dart';

import '../models/ListProfileSection.dart';
import '../utils/colors.dart';
import '../viewmodels/profile_viewmodel.dart';
import 'cart_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<ListProfileSection> listSection = [];
  UserData? userData;
  UserProfile? user;

  @override
  void initState() {
    super.initState();
    createListItem();
    fetchTokenAndCallApi();
  }

  Future<void> fetchTokenAndCallApi() async {
    Future.delayed(const Duration(milliseconds: 200), () async {
      var vs = Provider.of<ProfileViewModel>(context, listen: false);
      var result = await vs.getProfile(context);
      if (result is UserData) {
        this.userData = result;
        if (userData!.user != null) {
          user = userData!.user!;
        }
      }
    });
  }

  void createListItem() async {
    listSection.add(createSection("My Account", "images/ic_notification.png",
        Colors.blue.shade800, const HomeScreen()));
    listSection.add(createSection("My Order", "images/ic_payment.png",
        Colors.teal.shade800, const HomeScreen()));
    listSection.add(createSection("My Address", "images/ic_settings.png",
        Colors.red.shade800, const HomeScreen()));
    listSection.add(createSection(
        "Notifications",
        "images/ic_invite_friends.png",
        Colors.indigo.shade800,
        const HomeScreen()));
    listSection.add(createSection("My Cart", "images/ic_about_us.png",
        Colors.black.withOpacity(0.8), const CartScreen()));
    listSection.add(createSection(
        "Terms & Conditions",
        "images/ic_about_us.png",
        Colors.black.withOpacity(0.8),
        const HomeScreen()));
    listSection.add(createSection(
        "Return & Refund Policy",
        "images/ic_logout.png",
        Colors.red.withOpacity(0.7),
        const HomeScreen()));
  }

  createSection(String title, String icon, Color color, Widget? widget) {
    return ListProfileSection(title, icon, color, widget!);
  }

  @override
  Widget build(BuildContext context) {
    final vs = context.watch<ProfileViewModel>();
    return Scaffold(
      backgroundColor: CustomColors.backgroud,
      appBar: AppBar(
        backgroundColor: CustomColors.app_color,
        elevation: 50.0,
        leadingWidth: 30,
        leading: Container(
          child: const Icon(Icons.arrow_back_ios),
          margin: const EdgeInsets.only(left: 15),
        ),
        title: const Text("Profile"),
        centerTitle: false,
        actions: [
          IconButton(
            icon: SvgPicture.asset("assets/images/cart.svg"),
            onPressed: () {
              analytics
                  .logEvent(cart_click, eventProperties: {source: "profile"});
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const CartScreen();
                  },
                ),
              );
            },
            color: Colors.white,
          ),
        ],
        //IconButton
      ),
      body: callApi(vs),
    );
  }

  ListView buildMainView() {
    return ListView(
      children: <Widget>[
        const SizedBox(height: 24),
        buildHeader(),
        const SizedBox(height: 24),
        buildListView(),
        Container(
            margin: const EdgeInsets.all(10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40), backgroundColor: CustomColors.app_secondary_color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5), // <-- Radius
                ),
              ),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const LoginScreen(),
                  ),
                  (route) => false,
                );
              },
              child: const Text('Log Out'),
            ))
      ],
    );
  }

  Widget callApi(ProfileViewModel vs) {
    switch (vs.loadingStatus) {
      case LoadingStatus.searching:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case LoadingStatus.completed:
        return buildMainView();
      case LoadingStatus.empty:
        return buildMainView();
      default:
        return const Center(
          child: const Text("No results found"),
        );
    }
  }

  Container buildHeader() {
    return Container(
      child: Row(
        children: <Widget>[
          const SizedBox(width: 14),
          Container(
            width: 60,
            margin: const EdgeInsets.only(top: 8),
            height: 60,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/placeholder_profile.png")),
                borderRadius: BorderRadius.all(Radius.circular(24))),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (user != null)
                      Text(
                        user!.username ?? "",
                        textAlign: TextAlign.start,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    const SizedBox(height: 2),
                    if (user != null)
                      Text(
                        user!.email ?? "",
                        style: TextStyle(
                            color: Colors.grey.shade400, fontSize: 12),
                      ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  EditProfileScreen(user),
                            )).then((value) {
                          fetchTokenAndCallApi();
                        });
                      },
                      child: Row(
                        children: [
                          Image.asset("assets/images/edit.png"),
                          const Text("Edit")
                        ],
                      )),
                )
              ],
            ),
            flex: 100,
          )
        ],
      ),
    );
  }

  ListView buildListView() {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        return createListViewItem(listSection[index]);
      },
      itemCount: listSection.length,
    );
  }

  createListViewItem(ListProfileSection listSection) {
    return Builder(builder: (context) {
      return InkWell(
          splashColor: Colors.teal.shade200,
          onTap: () {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => listSection.widget));
          },
          child: Container(
              color: Colors.white,
              child: Column(children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(
                      top: 14, left: 24, right: 8, bottom: 14),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            listSection.title,
                          ),
                        ),
                        flex: 84,
                      ),
                      Expanded(
                        child: Container(
                          child: const Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.grey,
                          ),
                        ),
                        flex: 8,
                      ),
                    ],
                  ),
                ),
                Container(color: Colors.grey, height: 0.5)
              ])));
    });
  }
}
