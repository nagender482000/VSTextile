
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:vstextile/utils/colors.dart';

// class LoginScreenSecond extends StatefulWidget {
//   const LoginScreenSecond({Key? key}) : super(key: key);

//   @override
//   _LoginScreenSecondState createState() => _LoginScreenSecondState();
// }

// //var isLoggedIn = false;

// class _LoginScreenSecondState extends State<LoginScreenSecond> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     const String assetName = 'assets/images/bottom.svg';
//     const String bg = 'assets/images/login_bg.png';

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
//                   padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
//                   child: const Text(
//                     "Welcome to VS Textile",
//                     style: TextStyle(fontSize: 22),
//                   )),
//               Container(
//                   margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
//                   child: const TextField(
//                     decoration: InputDecoration(
//                       hintStyle: TextStyle(fontSize: 14),
//                       hintText: "Enter Mobile Number",
//                       prefixIcon: Icon(Icons.call),
//                     ),
//                   )),
//               const SizedBox(height: 30),
//               Container(
//                   margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
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
//               const SizedBox(height: 30),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: const [
//                 Text("By Signing In, I agree to ",style: TextStyle(fontSize: 14)),
//                 Text("Terms & Conditions.",style: TextStyle(fontSize: 14,color: CustomColors.app_secondary_color),),
//               ],),
//               const SizedBox(height: 150),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
