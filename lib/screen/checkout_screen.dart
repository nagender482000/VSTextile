import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vstextile/models/address/Address.dart';
import 'package:vstextile/models/address/DeliveryAddress.dart';
import 'package:vstextile/models/cart/CheckOutResponse.dart';
import 'package:vstextile/models/product/product_details.dart';
import 'package:vstextile/models/profile/UserData.dart';
import 'package:vstextile/screen/address_list_screen.dart';
import 'package:vstextile/screen/address_screen.dart';
import 'package:vstextile/screen/order_success_screen.dart';
import 'package:vstextile/screen/product_details_screen.dart';
import 'package:vstextile/utils/amplitude.dart';
import 'package:vstextile/utils/colors.dart';
import 'package:vstextile/viewmodels/cart_viewmodel.dart';

import '../models/cart/Cart.dart';

class CheckOutScreen extends StatefulWidget {
  final ProductDetails? productDetails;
  final int? quantity;

  const CheckOutScreen(this.productDetails, this.quantity, {Key? key})
      : super(key: key);

  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  Cart? cart;
  Address? address;

  Razorpay? _razorpay;

  @override
  void initState() {
    super.initState();

    if (widget.productDetails != null) {
      List<CartData> cartData = [];
      List<Data> thumbnailData = [];

      Data listData =
          Data(url: widget.productDetails?.product.images.data.first.url);
      thumbnailData.add(listData);
      totalAmount =
          double.parse(widget.productDetails?.product.finalPrice ?? "0");
      Thumbnail thumbnail = Thumbnail(data: thumbnailData, error: false);

      CartData data = CartData(
          itemQuantity: widget.quantity ?? 0,
          thumbnail: thumbnail,
          finalPrice: totalAmount.toString(),
          productId: widget.productDetails?.product.id,
          title: widget.productDetails?.product.title,
          sizeName: widget
              .productDetails?.product.selectedVariant?.sizes.data.first.name);
      cartData.add(data);
      cart = Cart(cartData: cartData, totalPrice: totalAmount);
      Future.delayed(const Duration(milliseconds: 200), () async {
        var vs = Provider.of<CartViewModel>(context, listen: false);

        vs.loadingStatus = LoadingStatus.completed;
        await getAddress(vs);
      });
    } else {
      Future.delayed(const Duration(milliseconds: 200), () async {
        var vs = Provider.of<CartViewModel>(context, listen: false);
        var result = await vs.getCart(context);
        var resultAddress = await vs.getAddress(context);
        if (result is Cart) {
          setState(() {
            totalAmount = result.totalPrice ?? 0.0;
            cart = result;
            var length = cart?.cartData?.length ?? 0;
            if (length == 0) {
              vs.loadingStatus = LoadingStatus.empty;
            }
          });
        }

        if (resultAddress is DeliveryAddress) {
          setState(() {
            addressID = resultAddress.deliveryAddresses.data?.first.id ?? 0;
            addressData = resultAddress.deliveryAddresses.data?.first;
            address = resultAddress.deliveryAddresses;
          });
        }
      });
    }

    _razorpay = Razorpay();
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<void> getAddress(CartViewModel vs) async {
    var resultAddress = await vs.getAddress(context);
    if (resultAddress is DeliveryAddress) {
      setState(() {
        addressID = resultAddress.deliveryAddresses.data?.first.id ?? 0;
        address = resultAddress.deliveryAddresses;
        addressData = resultAddress.deliveryAddresses.data?.first;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay?.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "SUCCESS: ${response.paymentId}",
        toastLength: Toast.LENGTH_SHORT,
        textColor: Colors.white);
    analytics.logEvent(payment_status, eventProperties: {
      status: "success",
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return OrderSuccessScreen();
        },
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint("ERROR: ${response.code.toString()} - ${response.message}");
    analytics.logEvent(payment_status, eventProperties: {
      status: "failure",
    });

    Fluttertoast.showToast(
        msg: "ERROR: ${response.code.toString()} - ${response.message}",
        toastLength: Toast.LENGTH_SHORT,
        textColor: Colors.white);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    analytics.logEvent(payment_status, eventProperties: {
      status: "EXTERNAL_WALLET",
    });
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: ${response.walletName}",
        toastLength: Toast.LENGTH_SHORT,
        textColor: Colors.white);
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
          totalAmount = result.totalPrice ?? 0;
          cart = result;

          analytics.logEvent(percentage_amount_changed,
              eventProperties: {percentage: amountchange});
          analytics.logEvent(remove_item_cart,
              eventProperties: {amount: totalAmount, source: "checkout"});
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
      if (result.error == false) {
        setState(() {
          totalAmount = result.totalPrice ?? 0;
          cart?.setTotalAmount(result.totalPrice);
          //cart = result;
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
          title: const Text("Checkout"),
          centerTitle: false,

          actions: [
            IconButton(
              icon: SvgPicture.asset("assets/images/cart.svg"),
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) {
                //       return HomeScreen();
                //     },
                //   ),
                // );
              },
              color: Colors.white,
            ),
          ],
          //IconButton
        ), //AppBar
        body: showWidget(context.watch<CartViewModel>()),
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
                        if (widget.productDetails != null) {
                          callProdcutCheckout();
                        } else
                          checkoutcart();
                      },
                      child: const SizedBox(
                        height: kToolbarHeight,
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            'Proceed To Pay',
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
                borderRadius: BorderRadius.all(Radius.circular(5))),
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
                if (widget.productDetails == null)
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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
                            child: const Icon(
                              Icons.remove,
                              size: 15,
                              color: Colors.black,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              if (cartData?.itemQuantity != 1) {
                                cartData?.removeQuantity();
                                analytics.logEvent(quantity_changed_cart,
                                    eventProperties: {
                                      type: "decreased",
                                      source: "checkout"
                                    });
                                updateFromCart(cartData?.cartItemId,
                                    cartData?.itemQuantity);
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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
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
                                    source: "checkout"
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

  double _currentSliderValue = 10;
  var totalAmount = 0.0;
  var tokenAmount = 0.0;
  var shippingFees = 69;

  Widget buildView(CartViewModel vs) {
    return SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      const SizedBox(height: 15),
      Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 12),
          child: const Text(
            "Secure Payment | Genuine Products | Easy Returns",
            style: TextStyle(fontSize: 12),
          )),
      const SizedBox(height: 10),
      addressContainer(),
      Container(
          alignment: Alignment.topLeft,
          margin: const EdgeInsets.only(left: 15, top: 10, bottom: 15),
          child: Text(
            "${cart?.cartData?.length ?? 0} Items in your cart",
            style: const TextStyle(fontSize: 14),
          )),
      Container(
          height: 280,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: createCartList()),
      Container(
          alignment: Alignment.topLeft,
          margin: const EdgeInsets.only(left: 15, top: 10),
          child: Text(
            "Pay $_currentSliderValue Percentage amount",
            style: const TextStyle(fontSize: 14),
          )),
      Slider(
        value: _currentSliderValue,
        max: 100,
        divisions: 10,
        label: _currentSliderValue.round().toString(),
        onChanged: (double value) {
          setState(() {
            if (value >= 10) _currentSliderValue = value;
          });
        },
      ),
      const Divider(
        thickness: 1,
        color: CustomColors.divider,
      ),
      Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text("Order Details",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Bag Total",
                  style: TextStyle(
                      color: CustomColors.text_color_light,
                      fontWeight: FontWeight.normal,
                      fontSize: 12),
                ),
                const SizedBox(width: 10),
                Text(
                  "\₹" + "${cart?.totalPrice.toString()}",
                  style: const TextStyle(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Token amount",
                  style: TextStyle(
                      color: CustomColors.text_color_light,
                      fontWeight: FontWeight.normal,
                      fontSize: 12),
                ),
                const SizedBox(width: 10),
                if (totalAmount > 0)
                  Text(
                    "- \₹" + "${(totalAmount * _currentSliderValue) / 100}",
                    style: const TextStyle(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Shipping Fees",
                  style: TextStyle(
                      color: CustomColors.text_color_light,
                      fontWeight: FontWeight.normal,
                      fontSize: 12),
                ),
                const SizedBox(width: 10),
                Text(
                  "+ \₹" + "${shippingFees.toString()}",
                  style: const TextStyle(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Remaining Amount",
                  style: TextStyle(
                      color: CustomColors.text_color_light,
                      fontWeight: FontWeight.normal,
                      fontSize: 12),
                ),
                const SizedBox(width: 10),
                Text(
                  "\₹" +
                      "${(totalAmount - ((totalAmount * _currentSliderValue) / 100) + 69)}",
                  style: const TextStyle(
                      color: CustomColors.text_color_light,
                      fontWeight: FontWeight.normal,
                      fontSize: 11),
                ),
              ],
            ),
            const Divider(thickness: 1, color: CustomColors.divider),
            Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 1),
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
                    Text(
                      "\₹" + "${(totalAmount + shippingFees)}",
                      style: const TextStyle(
                          color: CustomColors.text_color_light,
                          fontWeight: FontWeight.normal,
                          fontSize: 11),
                    ),
                  ],
                )),
          ])),
    ]));
  }


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
    //         child: Container(child: buildView()),
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
        debugPrint("Completed");
        return Container(child: buildView(vs));
      case LoadingStatus.empty:
        return const Center(
          child: Text("No results found"),
        );
      default:
        return const Center(
          child: Text("No results found"),
        );
    }
  }

  void openCheckout(String? orderId, int amount) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> userMap =
        jsonDecode(prefs.getString("user") ?? "") as Map<String, dynamic>;
    UserData user = UserData.fromJson(userMap);
    analytics.logEvent(payment_initiated, eventProperties: {
      order_id: orderId,
    });
    var options = {
      'key': 'rzp_test_MR6f35WPtlAo8o',
      'amount': amount * 100,
      'name': user.user?.username,
      'description': 'Payment',
      'order_id': orderId,
      'prefill': {
        'contact': user.user?.mobileNumber,
        'email': user.user?.email
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    debugPrint("user $options");

    try {
      _razorpay?.open(options);
    } catch (e, s) {
      debugPrint("Stacktrace : ${s.toString()}");
      debugPrint(e.toString());
    }
  }

  int addressID = 0;
  AddressData? addressData;

  Widget addressContainer() {
    var length = address?.data?.length ?? 0;
    if (address != null && length > 0)
      return Container(
          color: Colors.white,
          padding:
              const EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                SvgPicture.asset("assets/images/ic_location.svg"),
                Container(
                    margin: const EdgeInsets.only(left: 8),
                    child: const Text("Ship To:")),
                Container(
                    margin: const EdgeInsets.only(left: 3),
                    child: Text(addressData?.pincode ?? "")),
              ]),
              GestureDetector(
                  onTap: () {
                    _awaitReturnValueFromSecondScreen(context);
                    analytics.logEvent(change_address);
                  },
                  child: Container(
                      alignment: Alignment.topRight,
                      margin: const EdgeInsets.only(right: 3),
                      child: const Text(
                        "Change",
                        style:
                            TextStyle(color: CustomColors.app_secondary_color),
                      )))
            ],
          ));
    else {
      return GestureDetector(
          onTap: () {
            _awaitReturnValueFromAddAddressScreen(context);
            analytics.logEvent(add_address);
          },
          child: Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.only(
                  top: 15, left: 20, right: 20, bottom: 15),
              child: const Text(
                "Add Address",
                style: TextStyle(color: CustomColors.app_secondary_color),
              )));
    }
  }

  void _awaitReturnValueFromSecondScreen(BuildContext context) async {
    // start the SecondScreen and wait for it to finish with a result
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AddressListScreen(),
        ));

    // after the SecondScreen result comes back update the Text widget with it
    setState(() {
      addressID = (result as AddressData).id;
      addressData = result;

      var length = address?.data?.length ?? 0;
      if (length == 0) {
        address = Address(data: []);
        address?.data?.add(result);
      }
    });
  }

  void _awaitReturnValueFromAddAddressScreen(BuildContext context) async {
    // start the SecondScreen and wait for it to finish with a result
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AddressScreen(null),
        ));

    // after the SecondScreen result comes back update the Text widget with it
    setState(() {
      addressID =
          (result as DeliveryAddress).deliveryAddresses.data?.first.id ?? 0;
      addressData = (result).deliveryAddresses.data?.first;

      var length = address?.data?.length ?? 0;
      if (length == 0) {
        address = Address(data: []);
        address = result.deliveryAddresses;
      }
    });
  }

  void callProdcutCheckout() async {
    var vs = Provider.of<CartViewModel>(context, listen: false);
    var result = await vs.productcheckOut(
        context,
        totalAmount.toString(),
        widget.productDetails?.product.selectedVariant?.id ?? 0,
        widget.quantity ?? 0,
        addressID);
    if (result != null && result is CheckOutResponse) {
      analytics.logEvent(proceed_to_pay, eventProperties: {
        amount: result.amount,
        total_items: widget.quantity ?? 0
      });
      analytics.setUserProperties({order_amount: result.amount, order_items_count: widget.quantity});
      openCheckout(result.orderId, result.amount ?? 1);
    }
  }

  void checkoutcart() async {
    var vs = Provider.of<CartViewModel>(context, listen: false);
    var result =
        await vs.checkoutcart(context, totalAmount.toString(), addressID);
    if (result != null && result is CheckOutResponse) {
      openCheckout(result.orderId, result.amount ?? 1);
    }
  }
}
