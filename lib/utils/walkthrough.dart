import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vstextile/screen/edit_profile_screen.dart';

class Walkthrough extends StatefulWidget {
  final title;
  final content;
  final imageIcon;
  final progressImg;
  final controller;
  final isLast;

  Walkthrough(
      {this.title, this.content, this.imageIcon, this.progressImg, this.controller, this.isLast});

  @override
  WalkthroughState createState() {
    return WalkthroughState();
  }
}

class WalkthroughState extends State<Walkthrough>
    with SingleTickerProviderStateMixin {
  late Animation animation;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animation = Tween(begin: -250.0, end: 0.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut));

    animation.addListener(() => setState(() {}));

    animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _buildMainView(widget.isLast),
          Expanded(
            child: Column(children: [
              Container(
                  margin: EdgeInsets.only(top: 50,left: 20,right: 20),
                  child: Transform(
                    transform:
                    Matrix4.translationValues(animation.value, 0.0, 0.0),
                    child: Text(
                      widget.content,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  )),
              // Container(
              //     margin: EdgeInsets.only(top: 25, left: 10, right: 10),
              //     child: Transform(
              //       transform:
              //       Matrix4.translationValues(animation.value, 0.0, 0.0),
              //       child: Text(widget.content,
              //           softWrap: true,
              //           textAlign: TextAlign.start,
              //           style: const TextStyle(
              //               fontWeight: FontWeight.normal,
              //               fontSize: 16.0,
              //               color: Colors.black)),
              //     )),
              const SizedBox(
                height: 30,
              ),

            ]),
            flex: _flexForBottom(widget.isLast),
          )
        ],
      ),
    );
  }

  int _flexForBottom(bool isLast){
    return isLast ? 3:2;
  }

  Widget _buildMainView(bool isLast ) {
    if(isLast){
      return Expanded(
        flex: 5,
        child:Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset("assets/images/benefit_listing.png",width: 80),
          Container(
              margin:EdgeInsets.only(top:12),child:Text("35000+ Retailers",style: TextStyle(fontSize: 12,color: Colors.black))),
          Image.asset("assets/images/benefit_sellers.png",width: 80),
          Container(
              margin:EdgeInsets.only(top:12),child:Text("5 Lakh+ Orders",style: TextStyle(fontSize: 12,color: Colors.black))),

          Image.asset("assets/images/benefit_employees.png",width: 80,),
          Container(
              margin:EdgeInsets.only(top:12),child:Text("200+ Employees",style: TextStyle(fontSize: 12,color: Colors.black))),

        ],
      ));
    }else
    return Expanded(
      child: SvgPicture.asset(
        widget.imageIcon,
      ),
      flex: 4,
    );
  }
}
