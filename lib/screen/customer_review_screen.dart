import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vstextile/utils/colors.dart';

import 'cart_screen.dart';

class CustomerReviewScreen extends StatefulWidget {
  const CustomerReviewScreen({Key? key}) : super(key: key);

  @override
  _CustomerReviewScreenState createState() => _CustomerReviewScreenState();
}

class _CustomerReviewScreenState extends State<CustomerReviewScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.backgroud,
        appBar: AppBar(
          backgroundColor: CustomColors.app_color,
          elevation: 50.0,
          leadingWidth: 30,
          leading: const Icon(Icons.arrow_back_ios),
          title: const Text("Order Review"),
          centerTitle: false,
          actions: [
            IconButton(
              icon: SvgPicture.asset("assets/images/cart.svg"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return CartScreen();
                    },
                  ),
                );
              },
              color: Colors.white,
            ),

          ],
          //IconButton
        ), //AppBar
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
              child: Container(
                  height: double.infinity,
                  margin: const EdgeInsets.all(10),
                  child: createReviewList())),
        ]));
  }

  createReviewList() {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, position) {
        return _listItem();
      },
      itemCount: 5,
    );
  }

  Widget _listItem() {
    return GestureDetector(
        onTap: () {

        },
        child: Container(
            margin: EdgeInsets.only(left: 1, right: 1, top: 12),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin:
                          EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        color: Colors.blue.shade200,
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(right: 8, top: 4),
                                  child: Text(
                                    "Mitera",
                                    maxLines: 2,
                                    softWrap: true,
                                    style: const TextStyle(
                                      fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                RatingBar.builder(
                                  initialRating: 3,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 22,
                                  itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                ),
                                SizedBox(
                                  height: 6,
                                ),


                              ],
                            ),
                          ),
                        ],
                      ),
                      flex: 100,
                    )
                  ],
                ),
                Divider(color:CustomColors.backgroud,thickness: 1),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("I am very happy both with the shirt and the fast and efficient delivery- despite the distance."),
                ),
                Row(children: [
                  SizedBox(
                    width: 10,
                  ),

                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(35), backgroundColor: CustomColors.app_secondary_color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5), // <-- Radius
                        ),
                      ),
                      onPressed: () {},
                      child: const Text('Submit',style: TextStyle(
                          fontSize: 12)),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ])
              ],
            )));
  }
}
