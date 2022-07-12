import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vstextile/models/cart/Cart.dart';
import 'package:vstextile/screen/product_details_screen.dart';

import '../utils/colors.dart';
typedef void QuantityCallback(int val);
class Quantity extends StatefulWidget {
  CartData? cartData;
  int currentAmount=0;
  final QuantityCallback callback;


  Quantity(this.cartData,{required this.callback});

  @override
  _Quantity createState() => _Quantity();
}

class _Quantity extends State<Quantity> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.cartData != null) {
    //   setState(() {
    //     debugPrint("Setstate");
    //     widget.currentAmount = widget.cartData?.itemQuantity ?? 0;
    //   });
    // }
    return Row(
      children: <Widget>[
        GestureDetector(
          child: Container(
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                border: Border.all(
                  color: CustomColors.divider,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            child: const Icon(
              Icons.remove,
              size: 15,
              color: Colors.black,
            ),
          ),
          onTap: () {
            setState(() {
              if (widget.currentAmount != 0) widget.currentAmount -= 1;
            });
          },
        ),
        const SizedBox(width: 15),
        Text(
          "${widget.currentAmount}",
        ),
        const SizedBox(width: 15),
        GestureDetector(
          child: Container(
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                border: Border.all(
                  color: CustomColors.divider,
                ),
                borderRadius: const BorderRadius.all(const Radius.circular(5))),
            child: const Icon(
              Icons.add,
              size: 15,
              color: Colors.black,
            ),
          ),
          onTap: () {
            setState(() {
              widget.currentAmount += 1;
              // int? quantity =ProductDetailsScreen.of(context)?.getQuantity();
              // ProductDetailsScreen.of(context)?.quantity =quantity??0 + 1;
            });
          },
        ),
      ],
    );
  }
}
