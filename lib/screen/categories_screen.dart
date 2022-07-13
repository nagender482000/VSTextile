import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vstextile/models/categories/categories_data.dart';
import 'package:vstextile/screen/product_listing_screen.dart';
import 'package:vstextile/utils/colors.dart';

import '../viewmodels/categories_viewmodel.dart';
import 'cart_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  CategoriesData? categoriesData;

  @override
  void initState() {
    super.initState();
    callApi();
  }

  Future<void> callApi() async {
    Future.delayed(const Duration(milliseconds: 200), () async {
      var vs = Provider.of<CategoriesViewModel>(context, listen: false);
      var result = await vs.getCategories(context);
      if (result is CategoriesData) {
        setState(() {
          categoriesData = result;
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
          title: const Text("Top Trending"),
          centerTitle: false,
          actions: [
            IconButton(
              icon: SvgPicture.asset("assets/images/cart.svg"),
              onPressed: () {Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return CartScreen();
                  },
                ),
              );},
              color: Colors.white,
            ),

          ],
          //IconButton
        ), //AppBar
        body: showWidget(context.watch<CategoriesViewModel>()));
  }

  Widget getBody() {
    if (categoriesData == null) return Container();
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.zero,
      children: List.generate(categoriesData?.categories.length ?? 0, (index) {
        return Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 10),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ProductListingScreen(
                        categoriesData?.categories[index].id,
                        categoriesData?.categories[index].name),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 130,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(categoriesData
                                      ?.categories[index].images.data.first.url
                                      .toString() ??
                                  ""),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        categoriesData?.categories[index].name.toString() ?? "",
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    )
                  ],
                ),
              ),
            ));
      }),
    );
  }

  Widget showWidget(CategoriesViewModel vs) {
    switch (vs.loadingStatus) {
      case LoadingStatus.searching:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case LoadingStatus.completed:
        return Container(margin: const EdgeInsets.all(15), child: getBody());
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
