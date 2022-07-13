// ignore_for_file: unnecessary_const

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:vstextile/models/address/Address.dart';
import 'package:vstextile/utils/colors.dart';
import 'package:vstextile/viewmodels/address_viewmodel.dart';

import '../models/address/DeliveryAddress.dart';

class AddressScreen extends StatefulWidget {
  final AddressData? data;

  const AddressScreen(this.data, {Key? key}) : super(key: key);

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

//var isLoggedIn = false;

class _AddressScreenState extends State<AddressScreen> {
  bool isDefault = false;

  var nameController = TextEditingController(text: "NaN");
  var cityController = TextEditingController(text: "NaN");
  var stateController = TextEditingController(text: "NaN");
  var localityController = TextEditingController(text: "NaN");
  var flatNoController = TextEditingController(text: "NaN");
  var phoneNumberController = TextEditingController(text: "NaN");
  var pincodeController = TextEditingController(text: "NaN");

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      nameController.text = widget.data!.name;
      cityController.text = widget.data!.city;
      stateController.text = widget.data!.state;
      localityController.text = widget.data!.locality;
      phoneNumberController.text = widget.data!.phoneNumber;
      pincodeController.text = widget.data!.pincode;
      flatNoController.text = widget.data!.flatNo;
    }
    // Future.delayed(const Duration(milliseconds: 200), () async {
    //   var vs = Provider.of<AddressViewModel>(context, listen: false);
    // });
  }

  void addAddress(BuildContext context, AddressViewModel vs) {
    if (nameController.text.toString().isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter name",
        toastLength: Toast.LENGTH_SHORT,
        fontSize: 14.0,
      );
      return;
    }
    if (phoneNumberController.text.toString().isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter phone number",
        toastLength: Toast.LENGTH_SHORT,
        fontSize: 14.0,
      );
      return;
    }

    if (pincodeController.text.toString().isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter pincode",
        toastLength: Toast.LENGTH_SHORT,
        fontSize: 14.0,
      );
      return;
    }
    if (cityController.text.toString().isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter city",
        toastLength: Toast.LENGTH_SHORT,
        fontSize: 14.0,
      );
      return;
    }
    if (stateController.text.toString().isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter state",
        toastLength: Toast.LENGTH_SHORT,
        fontSize: 14.0,
      );
      return;
    }
    if (localityController.text.toString().isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter locality",
        toastLength: Toast.LENGTH_SHORT,
        fontSize: 14.0,
      );
      return;
    }
    // if(flatNoController.text.toString().isEmpty){
    //   Fluttertoast.showToast(
    //     msg: "Please enter flat no.",
    //     toastLength: Toast.LENGTH_SHORT,
    //     fontSize: 14.0,
    //   );
    //   return;
    // }

    Future.delayed(const Duration(milliseconds: 200), () async {
      dynamic result;
      if (widget.data != null) {
        result = await vs.updateAddress(
            context,
            widget.data!.id,
            nameController.text.toString(),
            cityController.text.toString(),
            stateController.text.toString(),
            localityController.text.toString(),
            flatNoController.text.toString(),
            phoneNumberController.text.toString(),
            pincodeController.text.toString(),
            _selected + 1,
            isDefault);
      } else {
        result = await vs.addAddress(
            context,
            nameController.text.toString(),
            cityController.text.toString(),
            stateController.text.toString(),
            localityController.text.toString(),
            flatNoController.text.toString(),
            phoneNumberController.text.toString(),
            pincodeController.text.toString(),
            _selected + 1,
            isDefault);
      }
      if (result is DeliveryAddress) {

        Fluttertoast.showToast(
          msg: "Address Updated Successfully!",
          toastLength: Toast.LENGTH_SHORT,
          fontSize: 14.0,
        );

        Navigator.pop(context, result);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: CustomColors.app_color,
        elevation: 50.0,
        title: const Text("Address"),
        //IconButton
      ), //AppBar
      body: showWidget(context, context.watch<AddressViewModel>()), //Center
    );
  }

  var _isLoading = false;

  Widget showWidget(BuildContext context, AddressViewModel vs) {
    switch (vs.loadingStatus) {
      case LoadingStatus.searching:
        _isLoading = true;
        break;
      case LoadingStatus.completed:
        _isLoading = false;
        break;
      case LoadingStatus.empty:
        _isLoading = false;
        break;
      default:
        _isLoading = false;
    }
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: _isLoading ? 0.5 : 1,
          // You can reduce this when loading to give different effect
          child: AbsorbPointer(
            absorbing: _isLoading,
            child: buildView(context, vs),
          ),
        ),
        Opacity(
            opacity: _isLoading ? 1 : 0,
            child: const Center(
              child: CircularProgressIndicator(),
            )),
      ],
    );
  }

  int _selected = 0;

  Widget _icon(int index, {required String text, required String icon}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkResponse(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                SvgPicture.asset("assets/images/radio_circle.svg"),
                Positioned(
                  child: SvgPicture.asset(icon),
                  top: 6,
                  left: 8,
                ),
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            Text(text,
                style:
                    TextStyle(color: _selected == index ? Colors.red : null)),
          ],
        ),
        onTap: () => setState(
          () {
            _selected = index;
            debugPrint(_selected.toString());
          },
        ),
      ),
    );
  }

  OutlineInputBorder buildOutlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        width: 0,
        style: BorderStyle.none,
      ),
    );
  }

  Widget buildView(BuildContext context, AddressViewModel vs) {
    return SingleChildScrollView(
        child: Container(
      color: CustomColors.filter_bg,
      child: Column(
        children: [
          Container(
              color: Colors.white,
              margin: const EdgeInsets.only(top: 15),
              padding: const EdgeInsets.only(
                  top: 15, left: 20, right: 20, bottom: 10),
              child: TextField(
                style: const TextStyle(fontSize: 14),
                controller: nameController,
                decoration: InputDecoration(
                    filled: true,
                    enabledBorder: buildOutlineInputBorder(),
                    focusedBorder: buildOutlineInputBorder(),
                    hintStyle: const TextStyle(fontSize: 14),
                    hintText: "Name",
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 5, horizontal: 14)),
              )),
          Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: TextField(
                style: const TextStyle(fontSize: 14),
                controller: phoneNumberController,

                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                // Only numbe
                decoration: InputDecoration(
                    filled: true,
                    enabledBorder: buildOutlineInputBorder(),
                    focusedBorder: buildOutlineInputBorder(),
                    hintStyle: const TextStyle(fontSize: 14),
                    hintText: "Phone Number",
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 14)),
              )),
          const SizedBox(height: 10),
          Container(
              width: double.infinity,
              color: Colors.white,
              margin: const EdgeInsets.only(top: 5),
              padding: const EdgeInsets.only(
                  top: 20, left: 20, right: 20, bottom: 10),
              child: const Text(
                "Address Info",
                style: const TextStyle(fontSize: 12),
              )),
          Row(
            children: [
              Expanded(
                  child: Container(
                      padding: const EdgeInsets.only(right: 10, left: 20),
                      width: double.infinity,
                      color: Colors.white,
                      child: TextField(
                        style: const TextStyle(fontSize: 14),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: pincodeController,
                        decoration: InputDecoration(
                            filled: true,
                            enabledBorder: buildOutlineInputBorder(),
                            focusedBorder: buildOutlineInputBorder(),
                            hintStyle: const TextStyle(fontSize: 14),
                            hintText: "Pincode",
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 14)),
                      ))),
              Expanded(
                  child: Container(
                      padding: const EdgeInsets.only(right: 20, left: 10),
                      width: double.infinity,
                      color: Colors.white,
                      child: TextField(
                        style: const TextStyle(fontSize: 14),
                        controller: cityController,
                        decoration: InputDecoration(
                            filled: true,
                            enabledBorder: buildOutlineInputBorder(),
                            focusedBorder: buildOutlineInputBorder(),
                            hintStyle: const TextStyle(fontSize: 14),
                            hintText: "City",
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 14)),
                      )))
            ],
          ),
          Container(
              color: Colors.white,
              padding: const EdgeInsets.only(
                  top: 10, left: 20, right: 20, bottom: 10),
              child: TextField(
                controller: stateController,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                    filled: true,
                    enabledBorder: buildOutlineInputBorder(),
                    focusedBorder: buildOutlineInputBorder(),
                    hintStyle: const TextStyle(fontSize: 14),
                    hintText: "State",
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 14)),
              )),
          Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: TextField(
                controller: localityController,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                    filled: true,
                    enabledBorder: buildOutlineInputBorder(),
                    focusedBorder: buildOutlineInputBorder(),
                    hintStyle: const TextStyle(fontSize: 14),
                    hintText: "Locality / Area / Street",
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 14)),
              )),
          Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: TextField(
                controller: flatNoController,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                    filled: true,
                    enabledBorder: buildOutlineInputBorder(),
                    focusedBorder: buildOutlineInputBorder(),
                    hintStyle: const TextStyle(fontSize: 14),
                    hintText: "Flat no / Building Number",
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 14)),
              )),
          Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: TextField(
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                    filled: true,
                    enabledBorder: buildOutlineInputBorder(),
                    focusedBorder: buildOutlineInputBorder(),
                    hintStyle: const TextStyle(fontSize: 14),
                    hintText: "Landmark (optional)",
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 14)),
              )),
          const SizedBox(height: 10),
          Container(
              width: double.infinity,
              color: Colors.white,
              margin: const EdgeInsets.only(top: 5),
              padding: const EdgeInsets.only(top: 14, left: 20, right: 20),
              child: const Text(
                "Type of Address",
                style: const TextStyle(fontSize: 12),
              )),
          Container(
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: [
                  _icon(0, text: "Home", icon: "assets/images/home.svg"),
                  _icon(1, text: "Office", icon: "assets/images/office.svg"),
                  _icon(2, text: "Other", icon: "assets/images/other.svg"),
                ],
              )),
          Container(
            width: double.infinity,
            color: Colors.white,
            child: Row(children: <Widget>[
              Checkbox(
                value: isDefault,
                onChanged: (value) {
                  setState(() {
                    isDefault = value!;
                  });
                },
              ),
              const Text(
                'Make as default address',
                style: TextStyle(fontSize: 14.0),
              ), //Text
            ]),
          ),
          Container(
              margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                  primary: CustomColors.app_secondary_color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // <-- Radius
                  ),
                ),
                child: const Text('Save Address'),
                onPressed: () {
                  addAddress(context, vs);
                },
              )),
        ],
      ),
    ));
  }
}
