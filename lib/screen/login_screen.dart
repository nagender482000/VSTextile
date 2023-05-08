import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vstextile/utils/colors.dart';
import 'package:vstextile/viewmodels/login_viewmodel.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

//var isLoggedIn = false;

class _LoginScreenState extends State<LoginScreen> {
  var _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();

    var vs = Provider.of<LoginViewModel>(context, listen: false);
    vs.loadingStatus = LoadingStatus.completed;
    _phoneNumberController.addListener(() {
      print("value: ${_phoneNumberController.text}");
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        body: showWidget(context, context.watch<LoginViewModel>()));
  }

  SingleChildScrollView getBody(BuildContext context, LoginViewModel vs) {
    const String bg = 'assets/images/login_bg.png';
    return SingleChildScrollView(
          child: Column(
        children: [
          const SizedBox(height: 50),
          SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width * 0.75,
              child: Image.asset(
                bg,
                //
              )),
          const SizedBox(height: 30),
          Container(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: const Text(
                "Welcome to VS Textile",
                style: TextStyle(fontSize: 22),
              )),
          Container(
              margin: EdgeInsets.only(top: 25, left: 20, right: 20),
              child: TextFormField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                maxLength: 10,
                decoration: InputDecoration(
                  prefixStyle: TextStyle(color: Colors.black, fontSize: 16),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: CustomColors.text_color_light, width: 1.0),
                  ),
                  hintStyle: TextStyle(fontSize: 14),
                  hintText: "Enter Mobile Number",
                  prefixIconConstraints:
                      BoxConstraints(minWidth: 0, minHeight: 0),
                  errorText:
                      validateMobile(_phoneNumberController.text.toString()),
                  prefixIcon: Container(
                      width: 70,
                      child:Row(
                    children: [
                      Icon(Icons.call),
                      SizedBox(width: 15),
                     Text('+91',style:TextStyle(fontSize: 14)),
                    ],
                  )),
                ),
              )),
          const SizedBox(height: 10),
          Container(
              margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40), backgroundColor: CustomColors.app_secondary_color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // <-- Radius
                  ),
                ),
                child: const Text('Next'),
                onPressed: () {
                  if (_phoneNumberController.text.toString().length == 10)
                    vs.submitPhoneNumber(context,_phoneNumberController.text.toString().trim());
                },
              )),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("By Signing In, I agree to ",
                  style: TextStyle(fontSize: 14)),
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

  String? validateMobile(String value) {
// Indian Mobile number are of 10 digit only
    if (value.length != 10)
      return 'Mobile Number must be of 10 digit';
    else
      return null;
  }
var _isLoading = false;
  Widget showWidget(BuildContext context,LoginViewModel vs) {
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
          opacity: _isLoading ? 0.5 : 1, // You can reduce this when loading to give different effect
          child: AbsorbPointer(
            absorbing: _isLoading,
            child: getBody(context,vs),
          ),
        ),
        Opacity(
          opacity: _isLoading ? 1 : 0,
          child: const Center(child:CircularProgressIndicator(),)
        ),
      ],
    );

  }
}
