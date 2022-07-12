import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:vstextile/screen/product_details_screen.dart';
import 'package:vstextile/utils/amplitude.dart';
import 'package:vstextile/utils/colors.dart';
import 'package:vstextile/utils/constant.dart';
import 'package:vstextile/viewmodels/cart_viewmodel.dart';
import 'package:vstextile/widgets/quantity.dart';

import '../models/cart/Cart.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Cart? cart;

  @override
  void initState() {
    super.initState();
    callCartAPI();
  }

  Future<void> callCartAPI() async {
    Future.delayed(const Duration(milliseconds: 200), () async {
      var vs = Provider.of<CartViewModel>(context, listen: false);
      var result = await vs.getCart(context);
      if (result is Cart) {
        analytics.logEvent(cart_checkout,
            eventProperties: {amount: cart?.totalPrice});

        setState(() {
          cart = result;
          var length = cart?.cartData?.length ?? 0;
          if (length == 0) {
            vs.loadingStatus = LoadingStatus.empty;
          }
        });
      }
    });
  }

  void removeFromCart(int id) async {
    var vs = Provider.of<CartViewModel>(context, listen: false);
    var result = await vs.removeCart(context, id);
    if (result is Cart) {
      if (result.error == false) {
        CartData? rmproduct =
            cart?.cartData?.firstWhere((element) => element.cartItemId == id);
        String amountchange = ((double.parse(rmproduct!.price.toString()) /
                    double.parse(cart!.totalPrice.toString())) *
                100)
            .toStringAsFixed(2);
        setState(() {
          cart = result;
          analytics.logEvent(remove_item_cart, eventProperties: {
            amount: rmproduct.price ?? "",
            source: "cart"
          });

          analytics.logEvent(percentage_amount_changed,
              eventProperties: {percentage: amountchange});
          var length = cart?.cartData?.length ?? 0;
          if (length == 0) {
            Navigator.pop(context, true);
          }
        });
        Fluttertoast.showToast(
            msg: "Item removed from cart successfully!",
            toastLength: Toast.LENGTH_SHORT,
            textColor: Colors.white);
      }
    }
  }

  void updateFromCart(int? id, int? quantity) async {
    var vs = Provider.of<CartViewModel>(context, listen: false);
    var result = await vs.updateCart(context, id ?? 0, quantity ?? 0);
    if (result is Cart) {
      analytics
          .logEvent(cart_checkout, eventProperties: {amount: cart?.totalPrice});

      if (result.error == false) {
        setState(() {
          // cart = result;
        });
        Fluttertoast.showToast(
            msg: "Item update in cart successfully!",
            toastLength: Toast.LENGTH_SHORT,
            textColor: Colors.white);
      }
    }
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
                child: const Icon(Icons.arrow_back_ios),
                margin: const EdgeInsets.only(left: 15),
              )),
          title: const Text("Cart"),
          centerTitle: false,
          actions: [],
          //IconButton
        ), //AppBar
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 15),
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "${cart?.cartData?.length ?? 0} Items in your cart",
                style: const TextStyle(fontSize: 17),
              )),
          Expanded(
              child: Container(
                  height: double.infinity,
                  margin: const EdgeInsets.all(10),
                  child: showWidget(context.watch<CartViewModel>()))),
        ]),
        bottomNavigationBar: Container(
            decoration: const BoxDecoration(
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
                    color: CustomColors.app_secondary_color,
                    child: InkWell(
                      onTap: () {
                        analytics.logEvent(proceed_to_checkout,
                            eventProperties: {
                              amount: cart?.totalPrice ?? "",
                              total_items: cart?.cartData?.length
                            });

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const CheckOutScreen(null, null);
                            },
                          ),
                        ).then((value) {
                          callCartAPI();
                        });
                      },
                      child: const SizedBox(
                        height: kToolbarHeight,
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            'Proceed To Checkout',
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

  createCartList() {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, position) {
        return _listItem(cart?.cartData?[position]);
      },
      itemCount: cart?.cartData?.length,
    );
  }

  Widget _listItem(CartData? cartData) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    const ProductDetailsScreen(0),
              ));
        },
        child: Container(
            margin: const EdgeInsets.only(left: 1, right: 1, top: 12),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CachedNetworkImage(
                      fit: BoxFit.fitWidth,
                      imageBuilder: (context, imageProvider) => Container(
                        margin: const EdgeInsets.only(
                            right: 8, left: 8, top: 8, bottom: 8),
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      imageUrl: cartData?.thumbnail?.data?.first.url ?? "",
                      placeholder: (context, url) => Container(
                          margin: const EdgeInsets.only(
                              right: 8, left: 8, top: 8, bottom: 8),
                          child:
                              SvgPicture.asset("assets/images/ic_gallery.svg")),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
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
                                  padding:
                                      const EdgeInsets.only(right: 8, top: 4),
                                  child: Text(
                                    cartData?.title ?? "",
                                    maxLines: 1,
                                    softWrap: true,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  cartData?.sizeName ?? "",
                                  style: const TextStyle(
                                      color: CustomColors.text_color_light,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 10),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Text("\₹" + "${cartData?.finalPrice}",
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal)),
                              ],
                            ),
                          ),
                          // Align(
                          //   alignment: Alignment.centerRight,
                          //   child: Container(
                          //     width: 20,
                          //     height: 60,
                          //     alignment: Alignment.centerRight,
                          //     margin: EdgeInsets.only(right: 10, top: 8),
                          //     child: Icon(
                          //       Icons.arrow_forward_ios_rounded,
                          //       size: 20,
                          //     ),
                          //   ),
                          // )
                        ],
                      ),
                      flex: 100,
                    )
                  ],
                ),
                Row(children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Row(
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: CustomColors.divider,
                              ),
                              borderRadius: const BorderRadius.all(
                                  const Radius.circular(5))),
                          child: const Icon(
                            Icons.remove,
                            size: 15,
                            color: Colors.black,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            if (cartData?.itemQuantity != 1) {
                              analytics.logEvent(quantity_changed_cart,
                                  eventProperties: {
                                    type: "decreased",
                                    source: "cart"
                                  });
                              cartData?.removeQuantity();
                              updateFromCart(
                                  cartData?.cartItemId, cartData?.itemQuantity);
                            } else {
                              removeFromCart(cartData?.cartItemId ?? 0);
                            }
                          });
                        },
                      ),
                      const SizedBox(width: 15),
                      Text(
                        "${cartData?.itemQuantity}",
                      ),
                      const SizedBox(width: 15),
                      GestureDetector(
                        child: Container(
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: CustomColors.divider,
                              ),
                              borderRadius: const BorderRadius.all(
                                  const Radius.circular(5))),
                          child: const Icon(
                            Icons.add,
                            size: 15,
                            color: Colors.black,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            cartData?.addQuantity();
                            analytics.logEvent(quantity_changed_cart,
                                eventProperties: {
                                  type: "increased",
                                  source: "cart"
                                });
                            updateFromCart(
                                cartData?.cartItemId, cartData?.itemQuantity);
                          });
                        },
                      ),
                    ],
                  )),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                      child: Stack(children: <Widget>[
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {
                        removeFromCart(cartData?.cartItemId ?? 0);
                      },
                      child: Row(
                        children: <Widget>[
                          Align(
                              alignment: Alignment.centerLeft,
                              child: SvgPicture.asset(
                                  "assets/images/remove_cart.svg")),
                          const SizedBox(
                            width: 6,
                          ),
                          const Align(
                            child: Text(
                              'Remove From Cart',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: CustomColors.app_secondary_color),
                            ),
                          )
                        ],
                      ),
                    ),
                  ])),
                  const SizedBox(
                    width: 10,
                  ),
                ])
              ],
            )));
  }

  var _isLoading = false;

  Widget showWidget(CartViewModel vs) {
    // switch (vs.loadingStatus) {
    //   case LoadingStatus.searching:
    //     _isLoading = true;
    //     break;
    //   case LoadingStatus.completed:
    //     _isLoading = false;
    //     break;
    //   case LoadingStatus.empty:
    //     _isLoading = false;
    //     break;
    //   default:
    //     _isLoading = false;
    // }
    // return Stack(
    //   children: <Widget>[
    //     Opacity(
    //       opacity: _isLoading ? 0.5 : 1,
    //       // You can reduce this when loading to give different effect
    //       child: AbsorbPointer(
    //         absorbing: _isLoading,
    //         child: Container(child: createCartList()),
    //       ),
    //     ),
    //     Opacity(
    //         opacity: _isLoading ? 1 : 0,
    //         child: const Center(
    //           child: CircularProgressIndicator(),
    //         )),
    //   ],
    // );

    switch (vs.loadingStatus) {
      case LoadingStatus.searching:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case LoadingStatus.completed:
        return Container(child: createCartList());
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
