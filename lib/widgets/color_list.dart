import 'package:flutter/material.dart';
import 'package:vstextile/models/product/variant.dart';

import '../utils/colors.dart';

class ColorList extends StatefulWidget {
  final VariantData? varaint;

  ColorList(this.varaint);

  @override
  _ColorList createState() => _ColorList();
}

class _ColorList extends State<ColorList> {
  @override
  Widget build(BuildContext context) {
    debugPrint("${widget.varaint?.colors.data.length ?? 0.toString()}");
    return  ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: widget.varaint?.colors.data.length ?? 0,
          itemBuilder: (BuildContext context, int index) => InkWell(
              onTap: () {
                setState(() {});
              },
              child: Container(
                height: 45,
                width: 25,
                  margin: const EdgeInsets.only(left:10,right: 10, top: 11, bottom: 15),
                  padding: const EdgeInsets.all(18),
                  decoration: const BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(0)),
                    color: CustomColors.app_secondary_color,
                  ),child: const Text(""),)),
    );
  }
}
