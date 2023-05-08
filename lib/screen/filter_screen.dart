import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vstextile/utils/colors.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  List<String> filterType = [
    "Price-₹",
    "Margin-%",
    "Supplier City",
    "Brand",
    "Fabric",
    "Size",
    "Color",
    "Clothing Design",
    "Rating",
  ];

  List<String> filterSubType = [
    "Ahmedabad",
    "Banglore",
    "Bengaluru",
    "Delhi",
    "Faridabad",
    "Gautam Buddha Nagar",
    "Gaziabad",
    "Indore",
    "Jaipur",
    "Jalandhar",
    "Kalyan",
    "Kanpur",
    "Kolkata",
    "West Bengal",
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool checkBoxValue = false;
    return Scaffold(
        backgroundColor: Colors.white,
        //AppBar
        body: Container(
            child: Column(
          children: [
            Flexible(child: _buildFilterWidgets(MediaQuery.of(context).size)),
            Expanded(
                flex: 8,
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        color: CustomColors.filter_bg,
                        child: ListView.separated(
                          itemCount: filterType.length,
                          itemBuilder: (_, i) =>
                              ListTile(title: Text(filterType[i])),
                          separatorBuilder: (context, index) {
                            return const Divider(
                              height: 0.1,
                            );
                          },
                        ),
                      ),
                      flex: 4,
                    ),
                    Flexible(
                      child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          color: Colors.white,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: filterSubType.length,
                                    // The list items
                                    itemBuilder: (context, index) {
                                      return Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          border: index == 0
                                              ? const Border() // This will create no border for the first item
                                              : const Border(
                                                  top: BorderSide(
                                                      width: 1,
                                                      color: CustomColors
                                                          .divider)), // This will create top borders for the rest
                                        ),
                                        child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              checkboxTile(filterSubType[index],
                                                  checkBoxValue),
                                            ]),
                                      );
                                    },
                                  ),
                                ),
                                Stack(children: <Widget>[
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size.fromHeight(40), backgroundColor: CustomColors.app_secondary_color,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            5), // <-- Radius
                                      ),
                                    ),
                                    onPressed: () {},
                                    child: const Text('Apply'),
                                  ),
                                  Positioned(
                                      left: 65,
                                      top: 17,
                                      child: SvgPicture.asset(
                                          "assets/images/ic_thumb.svg")),
                                ])
                              ])),
                      flex: 5,
                    ),
                  ],
                ))
          ],
        )));
  }

  Widget checkboxTile(String title, bool checked) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
              height: 24.0,
              width: 0.0,
              child: Checkbox(
                  value: checked,
                  onChanged: (value) => setState(() {
                        checked = value!;
                      }))),
          const SizedBox(
            width: 15,
          ),
          Text(title),
        ]);
  }

  _buildFilterWidgets(Size screenSize) {
    return Container(
      margin: const EdgeInsets.only(top: 35),
      color: Colors.white,
      width: screenSize.width,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              onTap: () {},
              child: Container(
                  margin: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: <Widget>[
                      SvgPicture.asset("assets/images/filter.svg"),
                      const SizedBox(
                        width: 2.0,
                      ),
                      const Text(
                        "Filters",
                        textAlign: TextAlign.left,
                      ),
                    ],
                  )),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                  margin: const EdgeInsets.only(right: 15),
                  child: const Text(
                    "Cancel",
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: Colors.red),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
