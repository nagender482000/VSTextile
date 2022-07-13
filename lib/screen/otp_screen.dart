import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';
import 'package:vstextile/utils/amplitude.dart';
import 'package:vstextile/utils/colors.dart';

import '../viewmodels/login_viewmodel.dart';

class OTPScreen extends StatefulWidget {
  final String verificationID;
  final String mboileNumber;

  OTPScreen(
      {Key? key, required this.verificationID, required this.mboileNumber})
      : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

//var isLoggedIn = false;

class _OTPScreenState extends State<OTPScreen> {
  var _otpController = OtpFieldController();
  var otp = "";

  @override
  void initState() {
    super.initState();
    analytics.setUserId(widget.mboileNumber);
    analytics
        .logEvent(submit_phone, eventProperties: {phone: widget.mboileNumber});
    analytics.setUserProperties({phone: widget.mboileNumber});
    var vs = Provider.of<LoginViewModel>(context, listen: false);
    vs.loadingStatus = LoadingStatus.completed;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: showWidget(context, context.watch<LoginViewModel>()));
  }

  Widget buildScaffold(BuildContext contextg, LoginViewModel vs) {
    const String bg = 'assets/images/otp_screen_bg.png';
    return SingleChildScrollView(
        child: Column(
      children: [
        const SizedBox(height: 50),
        SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width * 0.85,
            child: Image.asset(
              bg,
              //
            )),
        const SizedBox(height: 30),
        Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: const Text(
              "Enter Your OTP",
              style: TextStyle(fontSize: 22),
            )),
        Container(
            padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
            child: const Text(
              "We have sent the verification code to Your Mobile Number",
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: 15, color: CustomColors.text_color_light),
            )),
        Container(
            padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
            child: Text(
              "+91 " + widget.mboileNumber,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: CustomColors.text_color_light),
            )),
        Container(
          margin: const EdgeInsets.only(top: 25, left: 20, right: 20),
          child: OTPTextField(
            length: 6,
            controller: _otpController,
            width: MediaQuery.of(context).size.width,
            fieldWidth: 40,
            outlineBorderRadius: 0,
            style: TextStyle(fontSize: 14),
            textFieldAlignment: MainAxisAlignment.spaceAround,
            fieldStyle: FieldStyle.box,
            onCompleted: (pin) {
              setState(() {
                otp = pin.toString();
              });
              print("Completed: " + pin);
            },
          ),
        ),
        const SizedBox(height: 10),
        Container(
            margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40),
                primary: CustomColors.app_secondary_color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5), // <-- Radius
                ),
              ),
              child: const Text('Submit'),
              onPressed: () {
                if (otp.isNotEmpty)
                  _submitOTP(vs);
                else
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Please enter otp"),
                  ));
              },
            )),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("By Signing In, I agree to ", style: TextStyle(fontSize: 14)),
            Text(
              "Terms & Conditions.",
              style: TextStyle(
                  fontSize: 14, color: CustomColors.app_secondary_color),
            ),
          ],
        ),
      ],
    ));
  }

  var _phoneAuthCredential;
  void _submitOTP(LoginViewModel vs) async {
    this._phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: this.widget.verificationID, smsCode: otp);

    await vs.login(context, this._phoneAuthCredential);
  }

  var _isLoading = false;
  Widget showWidget(BuildContext context, LoginViewModel vs) {
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
          opacity: _isLoading
              ? 0.5
              : 1, // You can reduce this when loading to give different effect
          child: AbsorbPointer(
            absorbing: _isLoading,
            child: buildScaffold(context, vs),
          ),
        ),
        Opacity(
            opacity: _isLoading ? 1 : 0,
            child: const Center(
              child: CircularProgressIndicator(),
            )),
      ],
    );
    switch (vs.loadingStatus) {
      case LoadingStatus.searching:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case LoadingStatus.completed:
        return Container(
            margin: const EdgeInsets.all(5), child: buildScaffold(context, vs));
      case LoadingStatus.empty:
        return const Center(
          child: const Text("No results found"),
        );
      default:
        return Container(
            margin: const EdgeInsets.all(5), child: buildScaffold(context, vs));
    }
  }
}
