import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:timelines/timelines.dart';
import '../utils/colors.dart';
import 'package:vstextile/utils/constant.dart';

import '../widgets/delivery_process.dart';
import 'cart_screen.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({Key? key}) : super(key: key);

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

//var isLoggedIn = false;

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.app_color,
        elevation: 30.0,
        leadingWidth: 30,
        leading: const Icon(Icons.arrow_back_ios),
        title: const Text("Order Details"),
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
      ), //A
      backgroundColor: CustomColors.backgroud,
      body: ListView(padding: EdgeInsets.zero, children: [
        const SizedBox(
          height: 10,
        ),
        Stack(children: [
          Container(
              margin: const EdgeInsets.only(top: 8),
              color: Colors.white,
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Text("Expected Delivery")),
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 10),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    right: 8, left: 8, bottom: 8),
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6)),
                                  color: Colors.blue.shade200,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Mitera",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 3),
                                  const Text(
                                    "Sequinned Ready to Wear Saree",
                                    style: TextStyle(
                                        color: CustomColors.text_color_light,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 10),
                                  ),
                                  const SizedBox(height: 8),
                                  Text("One Size",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal)),
                                ],
                              )
                            ])),
                    const Divider(
                      thickness: 1,
                      color: CustomColors.divider,
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Order Details",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Bag Total",
                                    style: TextStyle(
                                        color: CustomColors.text_color_light,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    "\₹" + "1200.00",
                                    style: TextStyle(
                                        color: CustomColors.text_color_light,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Coupon Savings",
                                    style: TextStyle(
                                        color: CustomColors.text_color_light,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    "\₹" + "-2000.00",
                                    style: TextStyle(
                                        color: CustomColors.text_color_light,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Delivery",
                                    style: TextStyle(
                                        color: CustomColors.text_color_light,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    "\₹" + "-9.00",
                                    style: TextStyle(
                                        color: CustomColors.text_color_light,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 11),
                                  ),
                                ],
                              )
                            ])),
                    const Divider(thickness: 1, color: CustomColors.divider),
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total Amount",
                              style: TextStyle(
                                  color: CustomColors.text_color_light,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "\₹" + "10000",
                              style: TextStyle(
                                  color: CustomColors.text_color_light,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 11),
                            ),
                          ],
                        )),
                    const Divider(thickness: 1, color: CustomColors.divider),
                    Container(
                        height: 120,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Expanded(
                                child: Text(
                                  "Check Receipt",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                flex: 1,
                              ),
                              Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: 4,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return listItem(context, index);
                                  },
                                ),
                                flex: 5,
                              )
                            ])),
                    const Divider(thickness: 1, color: CustomColors.divider),
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Size & Fit",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(
                                height: 8,
                              ),
                              const Text(
                                "Legnth:-5.5 meters plus 0.7 meter blouse piece",
                                style: TextStyle(
                                    color: CustomColors.text_color_light,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              const Text(
                                "Width:-1.5 meters(approx)",
                                style: TextStyle(
                                    color: CustomColors.text_color_light,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13),
                              ),
                            ])),
                    const Divider(thickness: 1, color: CustomColors.divider),
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Material & Care",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(
                                height: 8,
                              ),
                              const Text(
                                "Poly Chiffon Saree",
                                style: TextStyle(
                                    color: CustomColors.text_color_light,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              const Text(
                                "Width:-1.5 meters(approx)",
                                style: TextStyle(
                                    color: CustomColors.text_color_light,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13),
                              ),
                            ])),
                    const Divider(thickness: 1, color: CustomColors.divider),
                    Container(
                        margin:
                            const EdgeInsets.only(top: 10, left: 15, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Track Order",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13)),
                                const Text("Order Status: Completed",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12)),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            const Text(
                              "404-0121524-590191",
                              style: TextStyle(
                                  color: CustomColors.text_color_light,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13),
                            ),
                          ],
                        )),
                    Container(
                        height: 300,
                        margin:
                            const EdgeInsets.only(top: 10, left: 15, right: 20),
                        child: _timeline()),
                    Container(
                        margin:
                            const EdgeInsets.only(top: 10, left: 20, right: 20),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(40),
                            primary: CustomColors.text_color_light,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(5), // <-- Radius
                            ),
                          ),
                          child: const Text('View All Reviews'),
                          onPressed: () {},
                        )),
                    const Divider(thickness: 1, color: CustomColors.divider),
                  ])),
        ]),
        SizedBox(
          height: 50,
        )
      ]),
    );
  }

  Widget listItem(BuildContext context, int index) {
    return Row(
      children: <Widget>[
        Container(
          height: 5.0,
          width: 5.0,
          decoration: new BoxDecoration(
            color: CustomColors.text_color_light,
            shape: BoxShape.circle,
          ),
        ),
        Container(
            margin: const EdgeInsets.only(left: 10, top: 2),
            child: const Text(
              "Gray Saree",
              style: TextStyle(fontSize: 13),
            ))
      ],
    );
  }

  Widget listItemCustomerReview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RatingBar.builder(
          initialRating: 3,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: 15,
          itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            print(rating);
          },
        ),
        Container(
            margin: EdgeInsets.only(left: 4, bottom: 5, top: 8),
            child: Text(
                "I am very happy both with the shirt and the fast and efficient delivery- despite the distance.")),
      ],
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height) / 3.5;
    final double itemWidth = size.width / 2;
    return GridView.count(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      crossAxisCount: 2,
      childAspectRatio: (itemWidth / 250),
      children: List.generate(recommends.length, (index) {
        return Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 5),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: CustomColors.divider),
                color: Colors.white,
                borderRadius: BorderRadius.circular(5)),
            child: Column(
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              categories[index]['imgUrl'].toString()),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(5)),
                ),
                Container(
                  width: 140,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            recommends[index]['title'].toString(),
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                height: 1.5),
                          )),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        "Sequinned Ready to Wear Saree",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                            height: 1),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("\$ " + "12000",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold)),
                            const Text("\$ " + "12000",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold)),
                            Text(
                              "\$ " + recommends[index]['price'].toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ]),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _timeline() {
    List<String> data = ["Test","Test","Test","Test","test"];
    return DeliveryProcesses(processes: data);
  }
}
