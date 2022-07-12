

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:vstextile/utils/colors.dart';

// class OTPScreenSecond extends StatefulWidget {
//   const OTPScreenSecond({Key? key}) : super(key: key);

//   @override
//   _OTPScreenSecondState createState() => _OTPScreenSecondState();
// }

// //var isLoggedIn = false;

// class _OTPScreenSecondState extends State<OTPScreenSecond> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     const String assetName = 'assets/images/bottom.svg';
//     const String bg = 'assets/images/otp_bg.png';

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: <Widget>[
//           Image.asset(
//             bg,
//             fit: BoxFit.cover,
//             height: double.infinity,
//             width: double.infinity,
//             alignment: Alignment.center,
//             //
//           ),
//           Positioned(
//               bottom: 0.1,
//               right: 0.1,
//               left: 0.1,
//               child: SvgPicture.asset(
//                 assetName,
//               )),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Container(
//                   padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
//                   child: const Text(
//                     "Enter Your OTP",
//                     style: TextStyle(fontSize: 22),
//                   )),
//               Container(
//                   padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
//                   child: const Text(
//                     "We have sent the verification code to Your Mobile Number",
//                     textAlign:TextAlign.center,
//                     style: TextStyle(fontSize: 15,color: CustomColors.text_color_light),
//                   )),
//               Container(
//                   padding: const EdgeInsets.fromLTRB(0, 35, 0, 0),
//                   child: const Text(
//                     "+919876543210  ",
//                     style: TextStyle(fontSize: 14,color: CustomColors.text_color_light),
//                   )),
//               Container(
//                   margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
//                   child: const TextField(
//                     decoration: InputDecoration(
//                       hintStyle: TextStyle(fontSize: 14),
//                       hintText: "Enter Mobile Number",
//                       prefixIcon: Icon(Icons.call),
//                     ),
//                   )),
//               const SizedBox(height: 20),
//               Container(
//                   margin: const EdgeInsets.only(top: 0, left: 20, right: 20),
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       minimumSize: const Size.fromHeight(40),
//                       primary: CustomColors.app_secondary_color,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(5), // <-- Radius
//                       ),
//                     ),
//                     child: const Text('Submit'),
//                     onPressed: () {},
//                   )),
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: const [
//                 Text("By Signing In, I agree to ",style: TextStyle(fontSize: 14)),
//                 Text("Terms & Conditions.",style: TextStyle(fontSize: 14,color: CustomColors.app_secondary_color),),
//               ],),
//               const SizedBox(height: 90),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
