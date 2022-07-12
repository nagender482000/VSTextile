import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vstextile/screen/product_details_screen.dart';
import 'package:vstextile/utils/amplitude.dart';
import 'package:vstextile/utils/colors.dart';
import 'package:vstextile/viewmodels/orders_viewmodel.dart';

import 'cart_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    callApi();
  }

  Future<void> callApi() async {
    Future.delayed(const Duration(milliseconds: 200), () async {
      var vs = Provider.of<OrdersViewModel>(context, listen: false);
      var result = await vs.getOrders(context);
      // if (result is CategoriesData) {
      //   setState(() {
      //     categoriesData = result;
      //   });
      // }
    });
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
          title: const Text("Orders"),
          centerTitle: false,
          actions: [
            IconButton(
              icon: SvgPicture.asset("assets/images/cart.svg"),
              onPressed: () {
                analytics
                    .logEvent(cart_click, eventProperties: {source: "orders"});
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
        body: showWidget(context, context.watch<OrdersViewModel>()));
  }

  createCartList() {
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
          analytics.logEvent(order_item_click);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => ProductDetailsScreen(0),
              ));
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
                      width: 60,
                      height: 60,
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
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  "Sequinned Ready to Wear Saree",
                                  style: TextStyle(
                                      color: CustomColors.text_color_light,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 10),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Text("\₹" + "1200.00",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal)),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: 20,
                              height: 60,
                              alignment: Alignment.centerRight,
                              margin: EdgeInsets.only(right: 10, top: 8),
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 20,
                              ),
                            ),
                          )
                        ],
                      ),
                      flex: 100,
                    )
                  ],
                ),
                Row(children: [
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          'Cancel Order',
                          style: TextStyle(
                              fontSize: 11,
                              color: CustomColors.app_secondary_color),
                        )),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          analytics.logEvent(track_order);
                        },
                        child: Text(
                          'Track Order',
                          style: TextStyle(
                              fontSize: 11, color: CustomColors.green),
                        )),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ])
              ],
            )));
  }

  Widget buildView(BuildContext context, OrdersViewModel vs) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(
          child: Container(
              height: double.infinity,
              margin: const EdgeInsets.all(10),
              child: createCartList())),
    ]);
  }

  Widget showWidget(BuildContext context, OrdersViewModel vs) {
    switch (vs.loadingStatus) {
      case LoadingStatus.searching:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case LoadingStatus.completed:
        return Container(
            margin: const EdgeInsets.all(15), child: buildView(context, vs));
      case LoadingStatus.empty:
        return const Center(
          child: const Text("No results found"),
        );
      default:
        return const Center(
          child: Text("No results found"),
        );
    }
  }
}
