import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:vstextile/screen/bottombar.dart';
import 'package:vstextile/utils/amplitude.dart';
import 'package:vstextile/utils/colors.dart';

import '../models/profile/UserData.dart';
import '../viewmodels/profile_viewmodel.dart';

class EditProfileScreen extends StatefulWidget {
  UserProfile? user;

  EditProfileScreen(this.user);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var shopNameController = TextEditingController();
  var referenceNameController = TextEditingController();
  var gstNumberController = TextEditingController();
  var addressController = TextEditingController();
  var emailController = TextEditingController();
  var userNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      shopNameController.text = widget.user!.shopName ?? "NaN";
      referenceNameController.text = widget.user!.referenceName ?? "NaN";
      gstNumberController.text = widget.user!.gstNumber ?? "NaN";
      addressController.text = widget.user!.address ?? "NaN";
      emailController.text = widget.user!.email ?? "NaN";
      userNameController.text = widget.user!.username ?? "NaN";
    }
  }

  @override
  Widget build(BuildContext context) {
    final vs = context.watch<ProfileViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: CustomColors.app_color,
        elevation: 50.0,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
            color: Colors.white,
          )
        ],
        title: Text("Detailing Page"),
        //IconButton
      ), //AppBar
      body: callApi(vs, context), //Center
    );
  }

  SingleChildScrollView buildSingleChildScrollView(
      BuildContext context, ProfileViewModel vs) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.only(top: 25),
              child: Text(
                "Welcome to VS Textile",
                style: TextStyle(fontSize: 22),
              )),
          SizedBox(
            height: 25,
          ),
          const Text(
            "Enter Your Personal Details Below",
            style: TextStyle(fontSize: 12),
          ),
          Container(
              margin: const EdgeInsets.only(top: 15, left: 20, right: 20),
              child: TextField(
                controller: userNameController,
                onChanged: (value) {
                  setState(() {
                    // userNameController.text = value;
                  });
                },
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  enabledBorder: buildOutlineInputBorder(),
                  focusedBorder: buildOutlineInputBorder(),
                  hintStyle: TextStyle(fontSize: 14),
                  hintText: "Enter Full Name",
                ),
              )),
          Container(
              margin: const EdgeInsets.only(top: 15, left: 20, right: 20),
              child: TextField(
                controller: shopNameController,
                onChanged: (value) {
                  setState(() {
                    //shopNameController.text = value;
                  });
                },
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  enabledBorder: buildOutlineInputBorder(),
                  focusedBorder: buildOutlineInputBorder(),
                  hintStyle: TextStyle(fontSize: 14),
                  hintText: "Enter Your Shop Name",
                ),
              )),
          Container(
              margin: const EdgeInsets.only(top: 15, left: 20, right: 20),
              child: TextField(
                controller: gstNumberController,
                onChanged: (value) {
                  setState(() {
                    // gstNumberController.text = value;
                  });
                },
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  enabledBorder: buildOutlineInputBorder(),
                  focusedBorder: buildOutlineInputBorder(),
                  hintStyle: TextStyle(fontSize: 14),
                  hintText: "Enter Your GST Number",
                ),
              )),
          Container(
              margin: const EdgeInsets.only(top: 15, left: 20, right: 20),
              child: TextField(
                controller: addressController,
                onChanged: (value) {
                  setState(() {
                    // addressController.text = value;
                  });
                },
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  enabledBorder: buildOutlineInputBorder(),
                  focusedBorder: buildOutlineInputBorder(),
                  hintStyle: TextStyle(fontSize: 14),
                  hintText: "Enter Your Address",
                ),
              )),
          Container(
              margin: const EdgeInsets.only(top: 15, left: 20, right: 20),
              child: TextField(
                controller: referenceNameController,
                onChanged: (value) {
                  setState(() {
                    // referenceNameController.text = value;
                  });
                },
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  enabledBorder: buildOutlineInputBorder(),
                  focusedBorder: buildOutlineInputBorder(),
                  hintStyle: TextStyle(fontSize: 14),
                  hintText: "Enter the Reference Name",
                ),
              )),
          Container(
              margin: const EdgeInsets.only(top: 15, left: 20, right: 20),
              child: TextField(
                controller: emailController,
                onChanged: (value) {
                  setState(() {
                    // emailController.text = value;
                  });
                },
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  enabledBorder: buildOutlineInputBorder(),
                  focusedBorder: buildOutlineInputBorder(),
                  hintStyle: TextStyle(fontSize: 14),
                  hintText: "Enter Your Email",
                ),
              )),
          const SizedBox(height: 10),
          Container(
              margin: const EdgeInsets.only(top: 15, left: 20, right: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40), backgroundColor: CustomColors.app_secondary_color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // <-- Radius
                  ),
                ),
                child: const Text('Next'),
                onPressed: () {
                  if (shopNameController.text.isEmpty) {
                    Fluttertoast.showToast(
                      msg: "Please enter shop name",
                      toastLength: Toast.LENGTH_SHORT,
                      fontSize: 14.0,
                    );
                    return;
                  } else if (gstNumberController.text.isEmpty) {
                    Fluttertoast.showToast(
                      msg: "Please enter GST number",
                      toastLength: Toast.LENGTH_SHORT,
                      fontSize: 14.0,
                    );
                    return;
                  } else if (addressController.text.isEmpty) {
                    Fluttertoast.showToast(
                      msg: "Please enter address",
                      toastLength: Toast.LENGTH_SHORT,
                      fontSize: 14.0,
                    );
                    return;
                  } else if (referenceNameController.text.isEmpty) {
                    Fluttertoast.showToast(
                      msg: "Please enter reference name",
                      toastLength: Toast.LENGTH_SHORT,
                      fontSize: 14.0,
                    );
                    return;
                  }
                  callEditProfile();
                },
              )),
        ],
      ),
    );
  }

  OutlineInputBorder buildOutlineInputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: CustomColors.text_color_light, width: 1.0),
    );
  }

  void callEditProfile() async {
    Future.delayed(Duration(milliseconds: 200), () async {
      bool isFromAdd = true;
      if (widget.user != null) isFromAdd = false;
      var vs = Provider.of<ProfileViewModel>(context, listen: false);
      var result = await vs.editProfile(
          context,
          userNameController.text,
          shopNameController.text,
          gstNumberController.text,
          addressController.text,
          referenceNameController.text,
          emailController.text,
          isFromAdd);
      debugPrint("Final result " + result.toString());

      if (result != null && result is UserData) {
        if (widget.user != null) {
          analytics.logEvent(submit_personal_info, eventProperties: {
            name: userNameController.text,
            shop_name: shopNameController.text,
            gst_number: gstNumberController.text,
            address: addressController.text,
            reference_name: referenceNameController.text,
            email: emailController.text,
          });
          Map<String, dynamic> userProps = {
            name: userNameController.text,
            shop_name: shopNameController.text,
            gst_number: gstNumberController.text,
            address: addressController.text,
            reference_name: referenceNameController.text,
            email: emailController.text,
          };
          analytics.setUserProperties(userProps);
          Fluttertoast.showToast(
            msg: "Profile Updated Successfully!",
            toastLength: Toast.LENGTH_SHORT,
            fontSize: 14.0,
          );
          Navigator.pop(context, true);
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => HomePage(),
            ),
            (route) => false,
          );
        }
      }
    });
  }

  Widget callApi(ProfileViewModel vs, BuildContext context) {
    switch (vs.loadingStatus) {
      case LoadingStatus.searching:
      // return Center(
      //   child: CircularProgressIndicator(),
      // );
      case LoadingStatus.completed:
        return buildSingleChildScrollView(context, vs);
      case LoadingStatus.empty:
        return Center(child: Text("No results found"));
      default:
        return Center(
          child: Text("No results found"),
        );
    }
  }
}
