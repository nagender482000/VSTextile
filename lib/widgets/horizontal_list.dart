import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vstextile/models/product/variant.dart';
import 'package:vstextile/utils/amplitude.dart';
import 'package:vstextile/utils/constant.dart';

import '../utils/colors.dart';
import 'color_list.dart';

class HorizontalList extends StatefulWidget {
  final Variant? variant;
  VariantData? selectedVariant;

  HorizontalList(this.variant, this.selectedVariant);

  @override
  _HorizontalList createState() => _HorizontalList();
}

class _HorizontalList extends State<HorizontalList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 60,
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: widget.variant?.data.length ?? 0,
              itemBuilder: (BuildContext context, int index) => InkWell(
                  onTap: () {
                    setState(() {
                      removeAllSelection(widget.variant?.data ?? []);
                      widget.selectedVariant = widget.variant?.data[index];
                      widget.variant?.data[index].isSelected = true;
                    });
                    analytics.logEvent(select_size_click, eventProperties: {
                      size: widget.selectedVariant?.sizes.data[0].name ?? "",
                      variant_quantity: widget.selectedVariant?.quantity ?? "",
                    });
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.only(right: 10, top: 11, bottom: 15),
                    padding: const EdgeInsets.all(10),
                    decoration: widget.variant?.data[index].isSelected ?? false
                        ? const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: CustomColors.app_secondary_color,
                          )
                        : BoxDecoration(
                            border: Border.all(
                              color: CustomColors.divider,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5))),
                    child: Text(
                        widget.variant?.data[index].sizes.data.first.name ?? "",
                        style: const TextStyle(fontSize: 12)),
                  ))),
        ),
        // if (widget.selectedVariant != null)
        // Container(
        //   height: 60,
        //     child:
        //         Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        //       Text(
        //         "Colors",
        //         style: TextStyle(fontWeight: FontWeight.bold),
        //       ),
        //
        //         Expanded(child: ColorList(widget.selectedVariant)),
        //     ])),
      ],
    );
  }

  void removeAllSelection(List<VariantData> data) {
    for (int i = 0; i < data.length; i++) {
      data[i].isSelected = false;
    }
  }
}
