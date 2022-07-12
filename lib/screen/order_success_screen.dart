import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vstextile/utils/walkthrough.dart';

import '../screen/edit_profile_screen.dart';
import '../utils/colors.dart';
import 'bottombar.dart';
import 'cart_screen.dart';

class OrderSuccessScreen extends StatefulWidget {
  @override
  OrderSuccessScreenState createState() {
    return OrderSuccessScreenState();
  }
}

class OrderSuccessScreenState extends State<OrderSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColors.app_color,
          elevation: 30.0,
          leadingWidth: 30,
          leading: GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => HomePage(),
                  ),
                  (route) => false,
                );
              },
              child: Container(
                child: Icon(Icons.arrow_back_ios),
                margin: const EdgeInsets.only(left: 15),
              )),
          title: const Text("Order Success"),
          centerTitle: false,
          actions: [
            // IconButton(
            //   icon: SvgPicture.asset("assets/images/cart.svg"),
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) {
            //           return CartScreen();
            //         },
            //       ),
            //     );
            //   },
            //   color: Colors.white,
            // ),
          ],
          //IconButton
        ), //A
        backgroundColor: CustomColors.backgroud,
        body: Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 50),
              SvgPicture.asset("assets/images/order_success.svg"),
              SizedBox(height: 50),
              const Text(
                "Thank You",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 20),
              Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Your Order has been successfully \n Placed",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ))
            ],
          ),
        ));
  }
}
