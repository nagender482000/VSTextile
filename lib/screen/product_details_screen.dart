import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:vstextile/models/cart/AddToCartResponse.dart';
import 'package:vstextile/models/product/product_details.dart';
import 'package:vstextile/screen/cart_screen.dart';
import 'package:vstextile/screen/checkout_screen.dart';
import 'package:vstextile/utils/amplitude.dart';
import 'package:vstextile/viewmodels/product_details_viewmodel.dart';
import '../models/product/variant.dart';
import '../utils/colors.dart';
import '../utils/custom_slider.dart';
import 'package:vstextile/utils/constant.dart';

import '../widgets/horizontal_list.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int? productID;

  const ProductDetailsScreen(this.productID);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  ProductDetails? productDetails;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () async {
      var vs = Provider.of<ProductDetailsViewModel>(context, listen: false);
      var result = await vs.getProductDetails(context, widget.productID!);
      if (result is ProductDetails) {
        setState(() {
          productDetails = result;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  int _quantity = 0;
  bool isItemAddedToCart = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.backgroud,
        body: showWidget(context.watch<ProductDetailsViewModel>()),
        bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 10,
                ),
              ],
            ),
            height: 50,
            child: Row(
              children: [
                Expanded(
                    child: Material(
                  color: Colors.white,
                  child: InkWell(
                    onTap: () {
                      if (!isItemAddedToCart)
                        addTocartApi(context);
                      else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const CartScreen(),
                          ),
                        ).then((value) {
                          setState(() {
                            //isItemAddedToCart = false;
                          });
                        });
                      }
                    },
                    child: SizedBox(
                      height: kToolbarHeight,
                      width: 100,
                      child: Center(
                        child: Text(
                          isItemAddedToCart ? 'Go To Cart' : 'Add To Cart',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
                Expanded(
                  child: Material(
                    color: CustomColors.app_secondary_color,
                    child: InkWell(
                      onTap: () {
                        var length =
                            productDetails?.product.variant?.data.length;
                        for (var i = 0; i < length!; i++) {
                          if (productDetails
                                  ?.product.variant?.data[i].isSelected ??
                              false)
                            productDetails?.product.selectedVariant =
                                productDetails?.product.variant?.data[i];
                        }
                        analytics.logEvent(buy_now, eventProperties: {
                          amount: _quantity *
                              double.parse(
                                  productDetails?.product.price ?? "0"),
                          quantity: _quantity,
                          variant_quantity:
                              productDetails?.product.selectedVariant?.quantity,
                          size: productDetails?.product.selectedVariant?.sizes
                        });

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                CheckOutScreen(productDetails, _quantity),
                          ),
                        ).then((value) {
                          setState(() {
                            //isItemAddedToCart = false;
                          });
                        });
                      },
                      child: const SizedBox(
                        height: kToolbarHeight,
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            'Buy Now',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }

  void addTocartApi(BuildContext context) async {
    var componenetID = 0;
    var length = productDetails?.product.variant?.data.length;
    for (var i = 0; i < length!; i++) {
      if (productDetails?.product.variant?.data[i].isSelected ?? false)
        componenetID = productDetails?.product.variant?.data[i].id ?? 0;
    }
    debugPrint("component ID $componenetID");
    if (componenetID == 0) {
      Fluttertoast.showToast(
        msg: "Please select variant",
        toastLength: Toast.LENGTH_SHORT,
        fontSize: 14.0,
      );
      return;
    } else if (_quantity == 0) {
      Fluttertoast.showToast(
        msg: "Please select quantity",
        toastLength: Toast.LENGTH_SHORT,
        fontSize: 14.0,
      );
      return;
    }

    var vs = Provider.of<ProductDetailsViewModel>(context, listen: false);

    var result = await vs.addToCart(context, componenetID, _quantity);
    if (result is AddToCartResponse) {
      if (result.error == false) {
        setState(() {
          isItemAddedToCart = true;
        });
        _quantity = 0;
        analytics.logEvent(add_to_cart_button, eventProperties: {
          amount:
              _quantity * double.parse(productDetails?.product.price ?? "0"),
          quantity: _quantity,
          variant_quantity: productDetails?.product.selectedVariant?.quantity,
          size: productDetails?.product.selectedVariant?.sizes
        });
        removeAllSelection(productDetails?.product.variant?.data ?? []);
        Fluttertoast.showToast(
            msg: "Item added to cart successfully!",
            toastLength: Toast.LENGTH_SHORT,
            textColor: Colors.white);
      }
    }
  }

  void removeAllSelection(List<VariantData> data) {
    for (int i = 0; i < data.length; i++) {
      data[i].isSelected = false;
    }
  }

  Widget buildView() {
    return ListView(padding: EdgeInsets.zero, children: [
      if (productDetails != null)
        BasicDemo(
          items: productDetails?.product.images.data ?? [],
          id: widget.productID.toString(),
        ),
      const SizedBox(
        height: 30,
      ),
      Stack(children: [
        SvgPicture.asset("assets/images/rounded_bg.svg"),
        Container(
            padding: const EdgeInsets.all(8),
            color: Colors.white,
            child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productDetails?.product.title ?? "",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            productDetails?.product.description ?? "",
                            style: TextStyle(
                                color: CustomColors.text_color_light,
                                fontWeight: FontWeight.normal,
                                fontSize: 10),
                          ),
                          const SizedBox(height: 8),
                          Row(children: [
                            Text(
                                "₹ ${productDetails?.product.finalPrice ?? ""}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal)),
                            SizedBox(width: 8),
                            Text("₹ ${productDetails?.product.price ?? ""}",
                                style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: CustomColors.text_color_light,
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal)),
                            SizedBox(width: 6),
                            // Text("Save " + "\₹" + "200",
                            //     style: TextStyle(
                            //         color: CustomColors.text_color_light,
                            //         fontSize: 13,
                            //         fontWeight: FontWeight.normal)),
                          ]),
                          const SizedBox(height: 5),
                          const Text(
                            "Price Inclusive of all taxes",
                            style: TextStyle(
                                color: CustomColors.text_color_light,
                                fontWeight: FontWeight.normal,
                                fontSize: 10),
                          ),
                        ],
                      )),
                  const Divider(
                    thickness: 1,
                    color: CustomColors.divider,
                  ),
                  Container(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, top: 10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Select Size",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            HorizontalList(productDetails?.product.variant,
                                productDetails?.product.selectedVariant),
                          ])),
                  const Divider(
                    thickness: 1,
                    color: CustomColors.divider,
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Quantity"),
                            Row(
                              children: <Widget>[
                                GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: CustomColors.divider,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    child: Icon(
                                      Icons.remove,
                                      size: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      if (_quantity != 0) _quantity -= 1;
                                      analytics.logEvent(
                                          quantity_product_detail_click,
                                          eventProperties: {value: _quantity});
                                    });
                                  },
                                ),
                                SizedBox(width: 15),
                                Text(
                                  "$_quantity",
                                ),
                                SizedBox(width: 15),
                                GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: CustomColors.divider,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    child: Icon(
                                      Icons.add,
                                      size: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _quantity += 1;
                                      analytics.logEvent(
                                          quantity_product_detail_click,
                                          eventProperties: {value: _quantity});
                                    });
                                  },
                                ),
                              ],
                            )
                          ])),
                  const Divider(thickness: 1, color: CustomColors.divider),
                  // deliveryDetails(),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Size & Fit",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              productDetails?.product.description ?? "",
                              style: TextStyle(
                                  color: CustomColors.text_color_light,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            // const Text(
                            //   "Width:-1.5 meters(approx)",
                            //   style: TextStyle(
                            //       color: CustomColors.text_color_light,
                            //       fontWeight: FontWeight.normal,
                            //       fontSize: 13),
                            // ),
                          ])),
                  const Divider(thickness: 1, color: CustomColors.divider),
                  // Container(
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: 15, vertical: 10),
                  //     child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           const Text("Material & Care",
                  //               style:
                  //               TextStyle(fontWeight: FontWeight.bold)),
                  //           const SizedBox(
                  //             height: 8,
                  //           ),
                  //           const Text(
                  //             "Poly Chiffon Saree",
                  //             style: TextStyle(
                  //                 color: CustomColors.text_color_light,
                  //                 fontWeight: FontWeight.normal,
                  //                 fontSize: 13),
                  //           ),
                  //           const SizedBox(
                  //             height: 8,
                  //           ),
                  //           const Text(
                  //             "Width:-1.5 meters(approx)",
                  //             style: TextStyle(
                  //                 color: CustomColors.text_color_light,
                  //                 fontWeight: FontWeight.normal,
                  //                 fontSize: 13),
                  //           ),
                  //         ])),
                  // const Divider(thickness: 1, color: CustomColors.divider),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Returns",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 8,
                            ),
                            const Text(
                              "Easy 30 days returns and exchange. Return Policies may vary based on products and promotions. For full details on over Returns Policies, Please Click here",
                              style: TextStyle(
                                  color: CustomColors.text_color_light,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13),
                            )
                          ])),
                  // const Divider(thickness: 1, color: CustomColors.divider),
                  // Container(
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: 15, vertical: 10),
                  //     child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           const Text("Product Reviews",
                  //               style:
                  //               TextStyle(fontWeight: FontWeight.bold)),
                  //           const SizedBox(
                  //             height: 10,
                  //           ),
                  //           Row(
                  //             children: [
                  //               Flexible(
                  //                   flex: 1,
                  //                   child: Container(
                  //                       margin: EdgeInsets.only(right: 5),
                  //                       child: Text("5",
                  //                           style:
                  //                           TextStyle(fontSize: 12)))),
                  //               Flexible(
                  //                 flex: 1,
                  //                 child: Container(
                  //                     margin: EdgeInsets.only(right: 3),
                  //                     child: SvgPicture.asset(
                  //                         "assets/images/star.svg")),
                  //               ),
                  //               const Flexible(
                  //                   flex: 20,
                  //                   child: SizedBox(
                  //                       child: LinearProgressIndicator(
                  //                         backgroundColor: Colors.grey,
                  //                         valueColor:
                  //                         const AlwaysStoppedAnimation<
                  //                             Color>(
                  //                             CustomColors
                  //                                 .text_color_light),
                  //                         value: 0.8,
                  //                       ))),
                  //               Flexible(
                  //                   flex: 1,
                  //                   child: Container(
                  //                       margin: EdgeInsets.only(left: 5),
                  //                       child: Text("5",
                  //                           style:
                  //                           TextStyle(fontSize: 12)))),
                  //             ],
                  //           ),
                  //           Row(
                  //             children: [
                  //               Flexible(
                  //                   flex: 1,
                  //                   child: Container(
                  //                       margin: EdgeInsets.only(
                  //                           right: 5, top: 8),
                  //                       child: Text("5",
                  //                           style:
                  //                           TextStyle(fontSize: 12)))),
                  //               Flexible(
                  //                 flex: 1,
                  //                 child: Container(
                  //                     margin:
                  //                     EdgeInsets.only(right: 3, top: 8),
                  //                     child: SvgPicture.asset(
                  //                         "assets/images/star.svg")),
                  //               ),
                  //               Flexible(
                  //                   flex: 20,
                  //                   child: Container(
                  //                       margin: EdgeInsets.only(
                  //                           right: 3, top: 8),
                  //                       child: SizedBox(
                  //                           child: LinearProgressIndicator(
                  //                             backgroundColor: Colors.grey,
                  //                             valueColor:
                  //                             const AlwaysStoppedAnimation<
                  //                                 Color>(
                  //                                 CustomColors
                  //                                     .text_color_light),
                  //                             value: 0.8,
                  //                           )))),
                  //               Flexible(
                  //                   flex: 1,
                  //                   child: Container(
                  //                       margin: EdgeInsets.only(
                  //                           left: 5, top: 8),
                  //                       child: Text("5",
                  //                           style:
                  //                           TextStyle(fontSize: 12)))),
                  //             ],
                  //           ),
                  //           Row(
                  //             children: [
                  //               Flexible(
                  //                   flex: 1,
                  //                   child: Container(
                  //                       margin: EdgeInsets.only(
                  //                           right: 5, top: 8),
                  //                       child: Text("5",
                  //                           style:
                  //                           TextStyle(fontSize: 12)))),
                  //               Flexible(
                  //                 flex: 1,
                  //                 child: Container(
                  //                     margin:
                  //                     EdgeInsets.only(right: 3, top: 8),
                  //                     child: SvgPicture.asset(
                  //                         "assets/images/star.svg")),
                  //               ),
                  //               Flexible(
                  //                   flex: 20,
                  //                   child: Container(
                  //                       margin: EdgeInsets.only(
                  //                           right: 3, top: 8),
                  //                       child: SizedBox(
                  //                           child: LinearProgressIndicator(
                  //                             backgroundColor: Colors.grey,
                  //                             valueColor:
                  //                             const AlwaysStoppedAnimation<
                  //                                 Color>(
                  //                                 CustomColors
                  //                                     .text_color_light),
                  //                             value: 0.8,
                  //                           )))),
                  //               Flexible(
                  //                   flex: 1,
                  //                   child: Container(
                  //                       margin: EdgeInsets.only(
                  //                           left: 5, top: 8),
                  //                       child: Text("5",
                  //                           style:
                  //                           TextStyle(fontSize: 12)))),
                  //             ],
                  //           ),
                  //           Row(
                  //             children: [
                  //               Flexible(
                  //                   flex: 1,
                  //                   child: Container(
                  //                       margin: EdgeInsets.only(
                  //                           right: 5, top: 8),
                  //                       child: Text("5",
                  //                           style:
                  //                           TextStyle(fontSize: 12)))),
                  //               Flexible(
                  //                 flex: 1,
                  //                 child: Container(
                  //                     margin:
                  //                     EdgeInsets.only(right: 3, top: 8),
                  //                     child: SvgPicture.asset(
                  //                         "assets/images/star.svg")),
                  //               ),
                  //               Flexible(
                  //                   flex: 20,
                  //                   child: Container(
                  //                       margin: EdgeInsets.only(
                  //                           right: 3, top: 8),
                  //                       child: SizedBox(
                  //                           child: LinearProgressIndicator(
                  //                             backgroundColor: Colors.grey,
                  //                             valueColor:
                  //                             const AlwaysStoppedAnimation<
                  //                                 Color>(
                  //                                 CustomColors
                  //                                     .text_color_light),
                  //                             value: 0.8,
                  //                           )))),
                  //               Flexible(
                  //                   flex: 1,
                  //                   child: Container(
                  //                       margin: EdgeInsets.only(
                  //                           left: 5, top: 8),
                  //                       child: Text("5",
                  //                           style:
                  //                           TextStyle(fontSize: 12)))),
                  //             ],
                  //           ),
                  //           Row(
                  //             children: [
                  //               Flexible(
                  //                   flex: 1,
                  //                   child: Container(
                  //                       margin: EdgeInsets.only(
                  //                           right: 5, top: 8),
                  //                       child: Text("5",
                  //                           style:
                  //                           TextStyle(fontSize: 12)))),
                  //               Flexible(
                  //                 flex: 1,
                  //                 child: Container(
                  //                     margin:
                  //                     EdgeInsets.only(right: 3, top: 8),
                  //                     child: SvgPicture.asset(
                  //                         "assets/images/star.svg")),
                  //               ),
                  //               Flexible(
                  //                   flex: 20,
                  //                   child: Container(
                  //                       margin: EdgeInsets.only(
                  //                           right: 3, top: 8),
                  //                       child: SizedBox(
                  //                           child: LinearProgressIndicator(
                  //                             backgroundColor: Colors.grey,
                  //                             valueColor:
                  //                             const AlwaysStoppedAnimation<
                  //                                 Color>(
                  //                                 CustomColors
                  //                                     .text_color_light),
                  //                             value: 0.8,
                  //                           )))),
                  //               Flexible(
                  //                   flex: 1,
                  //                   child: Container(
                  //                       margin: EdgeInsets.only(
                  //                           left: 5, top: 8),
                  //                       child: Text("5",
                  //                           style:
                  //                           TextStyle(fontSize: 12)))),
                  //             ],
                  //           ),
                  //         ])),
                  // const Divider(thickness: 1, color: CustomColors.divider),
                  // Container(
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: 15, vertical: 10),
                  //     child: Text(
                  //       "Customer Reviews",
                  //       style: TextStyle(fontWeight: FontWeight.bold),
                  //     )),
                  // Container(
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: 15, vertical: 10),
                  //     child: listItemCustomerReview()),
                  // const Divider(thickness: 1, color: CustomColors.divider),
                  // Container(
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: 15, vertical: 0),
                  //     child: listItemCustomerReview()),
                  // Container(
                  //     margin: const EdgeInsets.only(
                  //         top: 10, left: 20, right: 20),
                  //     child: ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //         minimumSize: const Size.fromHeight(40),
                  //         primary: CustomColors.text_color_light,
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius:
                  //           BorderRadius.circular(5), // <-- Radius
                  //         ),
                  //       ),
                  //       child: const Text('View All Reviews'),
                  //       onPressed: () {},
                  //     )),
                  // const Divider(thickness: 1, color: CustomColors.divider),
                  // getBody(),
                ])),
        // Positioned(
        //     right: 15,
        //     top: 15,
        //     child: SvgPicture.asset("assets/images/ic_share.svg")),
      ]),
      SizedBox(
        height: 50,
      )
    ]);
  }

  var _isLoading = false;

  Widget showWidget(ProductDetailsViewModel vs) {
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
          opacity: _isLoading ? 0.5 : 1,
          // You can reduce this when loading to give different effect
          child: AbsorbPointer(
            absorbing: _isLoading,
            child: Container(child: buildView()),
          ),
        ),
        Opacity(
            opacity: _isLoading ? 1 : 0,
            child: const Center(
              child: CircularProgressIndicator(),
            )),
      ],
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

  deliveryDetails() {
    Column(children: [
      Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text("Delivery Details",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 8,
            ),
            const Text(
              "Enter Pincode to Check Delivery Date / Pickup Option",
              style: TextStyle(
                  color: CustomColors.text_color_light,
                  fontWeight: FontWeight.normal,
                  fontSize: 13),
            ),
            const SizedBox(
              height: 8,
            ),
            Stack(children: const [
              SizedBox(
                  height: 40,
                  child: TextField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: CustomColors.text_color_light, width: 1.0),
                      ),
                      hintStyle: TextStyle(fontSize: 13),
                      hintText: "Please enter a valid pincode",
                    ),
                  )),
              Positioned(
                  right: 15,
                  top: 13,
                  child: Text(
                    "Check",
                    style: TextStyle(color: Colors.red, fontSize: 13),
                  ))
            ]),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset("assets/images/truck.svg"),
                const SizedBox(
                  width: 8,
                ),
                const Text(
                  "Delivery by 27th May",
                  style: TextStyle(
                      color: CustomColors.text_color_light,
                      fontWeight: FontWeight.normal,
                      fontSize: 10),
                ),
                const SizedBox(width: 10),
                SvgPicture.asset("assets/images/line.svg"),
                const SizedBox(width: 10),
                SvgPicture.asset("assets/images/cash.svg"),
                const SizedBox(
                  width: 8,
                ),
                const Text(
                  "Cash on delivery available",
                  style: TextStyle(
                      color: CustomColors.text_color_light,
                      fontWeight: FontWeight.normal,
                      fontSize: 10),
                ),
              ],
            )
          ])),
      const Divider(thickness: 1, color: CustomColors.divider),
      // Container(
      //     height: 120,
      //     padding: const EdgeInsets.symmetric(
      //         horizontal: 15, vertical: 10),
      //     child: Column(
      //         mainAxisAlignment: MainAxisAlignment.start,
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           const Expanded(
      //             child: Text(
      //               "Design Details",
      //               style:
      //                   TextStyle(fontWeight: FontWeight.bold),
      //             ),
      //             flex: 1,
      //           ),
      //           Expanded(
      //             child: ListView.builder(
      //               scrollDirection: Axis.vertical,
      //               shrinkWrap: true,
      //               itemCount: 4,
      //               itemBuilder:
      //                   (BuildContext context, int index) {
      //                 return listItem(context, index);
      //               },
      //             ),
      //             flex: 5,
      //           )
      //         ])),
      const Divider(thickness: 1, color: CustomColors.divider)
    ]);
  }
}
