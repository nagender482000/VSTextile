import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:vstextile/models/address/Address.dart';
import 'package:vstextile/screen/address_screen.dart';
import 'package:vstextile/utils/amplitude.dart';
import 'package:vstextile/utils/colors.dart';
import 'package:vstextile/viewmodels/address_viewmodel.dart';

import '../models/address/DeliveryAddress.dart';

class AddressListScreen extends StatefulWidget {
  const AddressListScreen({Key? key}) : super(key: key);

  @override
  _AddressListScreenState createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  Address? address;

  @override
  void initState() {
    super.initState();
    callCartAPI();
  }

  Future<void> callCartAPI() async {
    Future.delayed(const Duration(milliseconds: 200), () async {
      var vs = Provider.of<AddressViewModel>(context, listen: false);
      var result = await vs.getAddress(context);
      if (result is DeliveryAddress) {
        setState(() {
          address = result.deliveryAddresses;
        });
      }
    });
  }

  void removeAddress(AddressData? data) async {
    var vs = Provider.of<AddressViewModel>(context, listen: false);
    var result = await vs.removeAddress(context, data?.id ?? 0);
    if (result is Address) {
      if (result.error == false) {
        setState(() {
          address?.data?.remove(data);
        });
        Fluttertoast.showToast(
            msg: "Address removed successfully!",
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
        title: const Text("My Addresses"),
        centerTitle: false,
        actions: [],
        //IconButton
      ), //AppBar
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 15),
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              "${address?.data?.length ?? 0} Addresses",
              style: const TextStyle(fontSize: 17),
            )),
        Expanded(
            child: Container(
                height: double.infinity,
                margin: const EdgeInsets.all(10),
                child: showWidget(context.watch<AddressViewModel>()))),
      ]),
      // bottomNavigationBar: Container(
      //     decoration: BoxDecoration(
      //       color: Colors.white,
      //       boxShadow: <BoxShadow>[
      //         BoxShadow(
      //           color: Colors.grey,
      //           blurRadius: 10,
      //         ),
      //       ],
      //     ),
      //     height: 50,
      //     child: Row(
      //       children: [
      //         Expanded(
      //           child: Material(
      //             color: CustomColors.app_secondary_color,
      //             child: InkWell(
      //               onTap: () {
      //                 Navigator.push(
      //                   context,
      //                   MaterialPageRoute(
      //                     builder: (context) {
      //                       return CheckOutScreen(null,null);
      //                     },
      //                   ),
      //                 ).then((value) {
      //                   callCartAPI();
      //                 });
      //               },
      //               child: const SizedBox(
      //                 height: kToolbarHeight,
      //                 width: double.infinity,
      //                 child: Center(
      //                   child: Text(
      //                     'Proceed To Checkout',
      //                     style: TextStyle(
      //                         fontWeight: FontWeight.bold,
      //                         color: Colors.white),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ),
      //       ],
      //     ))
    );
  }

  createAddressList() {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, position) {
        return _listItem(address?.data![position]);
      },
      itemCount: address?.data?.length,
    );
  }

  Widget _listItem(AddressData? data) {
    return GestureDetector(
        onTap: () {
          Navigator.pop(context, data);
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
                                    data?.name ?? "",
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
                                  data?.getFullAddress() ?? "",
                                  style: const TextStyle(
                                      color: CustomColors.text_color_light,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 10),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                              ],
                            ),
                          ),
                          Align(
                              alignment: Alignment.topRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color:
                                            CustomColors.app_secondary_color),
                                    onPressed: () {
                                      analytics.logEvent(edit_address);

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return AddressScreen(data);
                                          },
                                        ),
                                      ).then((value) {
                                        callCartAPI();
                                      });
                                    },
                                  ),
                                ],
                              ))
                        ],
                      ),
                      flex: 100,
                    )
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(
                        width: 10,
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

                              removeAddress(data);
                            },
                            child: const Text(
                              'Remove Address',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: CustomColors.app_secondary_color),
                            )),
                      ])),
                      const SizedBox(
                        width: 10,
                      ),
                    ])
              ],
            )));
  }

  var _isLoading = false;

  Widget showWidget(AddressViewModel vs) {
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
        return Container(child: createAddressList());
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
