import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vstextile/models/product/product_list_data.dart';
import 'package:vstextile/screen/product_details_screen.dart';
import 'package:vstextile/utils/amplitude.dart';
import 'package:vstextile/utils/colors.dart';
import 'package:vstextile/utils/constant.dart';
import 'package:vstextile/viewmodels/product_listing_viewmodel.dart';

import '../models/categories/categories_data.dart';
import 'cart_screen.dart';

class ProductListingScreen extends StatefulWidget {
  final int? categories;
  final String? name;
  //final String? from;

  const ProductListingScreen(this.categories, this.name);

  @override
  _ProductListingScreenState createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  ProductListData? productListData;

  @override
  void initState() {
    super.initState();
    callApi();
  }

  Future<void> callApi() async {
    Future.delayed(const Duration(milliseconds: 200), () async {
      var vs = Provider.of<ProductListingViewModel>(context, listen: false);
      var result = await vs.getProductListing(context, widget.categories!);
      if (result is ProductListData) {
        setState(() {
          productListData = result;
        });
      }
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
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context, true);
              },
              child: Container(
                child: Icon(Icons.arrow_back_ios),
                margin: const EdgeInsets.only(left: 15),
              )),
          title: Text(widget.name ?? ""),
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
          const SizedBox(height: 15),
          // Container(
          //   margin: EdgeInsets.symmetric(horizontal: 15),
          //   height: 80,
          //   decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(5),
          //       image: const DecorationImage(
          //           image: NetworkImage(
          //               "https://qph.fs.quoracdn.net/main-qimg-d1152b52979494a4d5ea509bb965c7c2-lq"),
          //           fit: BoxFit.cover)),
          // ),
          Expanded(
              child: Container(
                  height: double.infinity,
                  margin: const EdgeInsets.all(10),
                  child: showWidget(context.watch<ProductListingViewModel>()))),
          _buildFilterWidgets(MediaQuery.of(context).size)
        ]));
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height) / 3.5;
    final double itemWidth = size.width / 2;
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: (itemWidth / 255),
      children: List.generate(productListData?.products.length ?? 0, (index) {
        return GestureDetector(
            onTap: () {
              analytics.logEvent(click_product_card, eventProperties: {
                source: "View All",
                section_name: widget.name,
                sub_section: ""
              });
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ProductDetailsScreen(
                        productListData?.products[index].id),
                  ));
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 2, right: 2, top: 10),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  children: [
                    Container(
                      height: 140,
                      child: CachedNetworkImage(
                        imageBuilder: (context, imageProvider) => Container(
                          width: 180.0,
                          height: 120.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                        imageUrl: productListData
                                ?.products[index].images.data.first.url
                                .toString() ??
                            "",
                        placeholder: (context, url) =>
                            SvgPicture.asset("assets/images/ic_gallery.svg"),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(productListData
                                      ?.products[index].images.data.first.url
                                      .toString() ??
                                  ""),
                              fit: BoxFit.fill),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                productListData?.products[index].label
                                        .toString() ??
                                    "",
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    height: 1.5),
                              )),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            productListData?.products[index].title.toString() ??
                                "",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: CustomColors.text_color_light,
                                height: 1),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    productListData?.products[index].price
                                            .toString() ??
                                        "",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                                // Container(
                                //   child: Text("₹ ${productListData?.products[index].price ?? ""}",
                                //       style: TextStyle(
                                //           decoration: TextDecoration.lineThrough,
                                //           fontSize: 11,
                                //           fontWeight: FontWeight.normal)),
                                //   margin: EdgeInsets.symmetric(horizontal: 10),
                                // ),
                                // Text(
                                //   "",
                                //   style: const TextStyle(
                                //     fontWeight: FontWeight.bold,
                                //     color: Colors.grey,
                                //     fontSize: 12,
                                //   ),
                                // ),
                              ]),
                          // TextButton(
                          //     child: Text("Add to cart".toUpperCase(),
                          //         style: TextStyle(fontSize: 14)),
                          //     style: ButtonStyle(
                          //         padding:
                          //             MaterialStateProperty.all<EdgeInsets>(
                          //                 const EdgeInsets.all(10)),
                          //         foregroundColor:
                          //             MaterialStateProperty.all<Color>(
                          //                 Colors.red),
                          //         shape: MaterialStateProperty.all<
                          //                 RoundedRectangleBorder>(
                          //             RoundedRectangleBorder(
                          //                 borderRadius:
                          //                     BorderRadius.circular(8.0),
                          //                 side:
                          //                     BorderSide(color: Colors.red)))),
                          //     onPressed: () => null),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ));
      }),
    );
  }

  _buildFilterWidgets(Size screenSize) {
    return Container(
      color: Colors.white,
      width: screenSize.width,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildFilterButton("SORT"),
            Container(
              color: Colors.black,
              width: 2.0,
              height: 24.0,
            ),
            _buildFilterButton("FILTER"),
          ],
        ),
      ),
    );
  }

  _buildFilterButton(String title) {
    return InkWell(
      onTap: () {
        print(title);
      },
      child: Row(
        children: <Widget>[
          Icon(
            Icons.arrow_drop_down,
            color: Colors.black,
          ),
          SizedBox(
            width: 2.0,
          ),
          Text(title),
        ],
      ),
    );
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert!'),
          content: Text("content"),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                ///Insert here an action, in your case should be:
                ///  Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget showWidget(ProductListingViewModel vs) {
    switch (vs.loadingStatus) {
      case LoadingStatus.searching:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case LoadingStatus.completed:
        return Container(margin: const EdgeInsets.all(5), child: getBody());
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
