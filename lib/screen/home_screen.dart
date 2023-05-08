import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vstextile/models/home/Categories.dart';
import 'package:vstextile/models/home/HomeData.dart';
import 'package:vstextile/models/home/collections.dart';
import 'package:vstextile/providers/firebase_dynamic_link.dart';
import 'package:vstextile/screen/product_details_screen.dart';
import 'package:vstextile/screen/product_listing_screen.dart';
import 'package:vstextile/utils/amplitude.dart';
import 'package:vstextile/utils/colors.dart';
import 'package:vstextile/utils/custom_slider.dart';
import 'package:vstextile/viewmodels/home_viewmodel.dart';

import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  static const route = '/HomeScreen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  HomeData? homeData;
  final FirebaseDynamicLinkService _dynamicLinkService =
      FirebaseDynamicLinkService();
  Timer? _timerLink;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _timerLink = new Timer(
        const Duration(milliseconds: 1000),
        () {
          FirebaseDynamicLinkService.initDynamicLink(context);
        },
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_timerLink != null) {
      _timerLink!.cancel();
    }
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();
    fetchTokenAndCallApi();
  }

  Future<void> fetchTokenAndCallApi() async {
    // await YourClass().exampleForAmplitude();
    Future.delayed(Duration(milliseconds: 200), () async {
      var vs = Provider.of<HomeViewModel>(context, listen: false);
      var result = await vs.getHomeFeed(context);
      if (result is HomeData) {
        setState(() {
          homeData = result;
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
          leading: Container(
              child: SvgPicture.asset("assets/images/logo.svg"),
              margin: EdgeInsets.only(left: 10)),
          title: Text("Textile"),
          centerTitle: false,
          actions: [
            IconButton(
              icon: SvgPicture.asset("assets/images/cart.svg"),
              onPressed: () {
                analytics
                    .logEvent(cart_click, eventProperties: {source: "home"});
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
        body: callApi(context.watch<HomeViewModel>()));
  }

  Widget getBody() {
    return SingleChildScrollView(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomeCarouselHomePage(
            items: homeData?.carousel.data.first.carouselItems.data ?? [],
            enLargeCenter: true),
        SizedBox(
          height: 25,
        ),
        if (homeData != null)
          SizedBox(
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: homeData?.collections.data.length ?? 0,
                  itemBuilder: (BuildContext context, int position) {
                    return Container(
                        child: buildCollectionItem(
                            homeData?.collections.data[position]));
                  })),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          child: Text("Categories",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          alignment: Alignment.topLeft,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            child: Row(
              children:
                  List.generate(homeData?.categories.data.length ?? 0, (index) {
                return buildCategories(homeData?.categories.data[index]);
              }),
            ),
            margin: EdgeInsets.symmetric(horizontal: 10),
          ),
        ),
        SizedBox(
          height: 25,
        ),
        if (homeData != null)
          SizedBox(
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: homeData?.categories.data.length ?? 0,
                  itemBuilder: (BuildContext context, int position) {
                    return Container(
                        child: buildSingleCategoryItem(
                            homeData?.categories.data[position]));
                  })),
      ],
    ));
  }

  Widget buildCollectionItem(Data? data) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(data?.name ?? "",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              GestureDetector(
                  onTap: () {
                    analytics.logEvent(view_all_section,
                        eventProperties: {section_name: data?.name ?? ""});

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ProductListingScreen(data?.id, data?.name),
                      ),
                    );
                  },
                  child: Row(
                    children: const [
                      Text("View All", style: TextStyle(color: Colors.grey)),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 16,
                      )
                    ],
                  ))
            ],
          ),
        ),
        Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child:
                Text(data?.description ?? "", style: TextStyle(fontSize: 13))),
        Container(
            alignment: Alignment.topLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                child: Row(
                  children:
                      List.generate(data?.products.data.length ?? 0, (index) {
                    return buildCollectionProductItem(
                        data?.products.data[index], data?.name ?? "");
                  }),
                ),
                margin: EdgeInsets.symmetric(horizontal: 10),
              ),
            )),
        SizedBox(
          height: 20,
        )
      ],
    );
  }

  Widget buildSingleCategoryItem(CategoriesItem? data) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 18, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(data?.name ?? "",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              GestureDetector(
                  onTap: () {
                    analytics.logEvent(view_all_section,
                        eventProperties: {section_name: data?.name ?? ""});
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ProductListingScreen(data?.id, data?.name),
                      ),
                    );
                  },
                  child: Row(
                    children: const [
                      Text("View All", style: TextStyle(color: Colors.grey)),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 16,
                      )
                    ],
                  ))
            ],
          ),
        ),
        Container(
            padding: EdgeInsets.only(top: 5),
            alignment: Alignment.topLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                child: Row(
                  children:
                      List.generate(data?.products.data.length ?? 0, (index) {
                    return buildCollectionProductItem(
                        data?.products.data[index], data?.name);
                  }),
                ),
                margin: EdgeInsets.symmetric(horizontal: 12),
              ),
            )),
        SizedBox(
          height: 20,
        )
      ],
    );
  }

  Widget buildCollectionProductItem(ProductData? data, secname) {
    return GestureDetector(
        onTap: () {
          analytics.logEvent(click_product_card, eventProperties: {
            source: "home",
            section_name: secname,
            sub_section: "collection"
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    ProductDetailsScreen(data?.id),
              ));
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 4, right: 4, top: 5),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Column(
              children: [
                if (data != null)
                  Container(
                    margin: EdgeInsets.all(1),
                    width: 150,
                    height: 120,
                    child: CachedNetworkImage(
                      fit: BoxFit.fitWidth,
                      imageBuilder: (context, imageProvider) => Container(
                        width: 150.0,
                        height: 120.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      imageUrl: data.image.data.url.toString(),
                      placeholder: (context, url) =>
                          SvgPicture.asset("assets/images/ic_gallery.svg"),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: 150,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            data?.title ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
                        data?.description ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                            height: 1),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("₹ ${data?.finalPrice ?? ""}",
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold)),
                            Container(
                              child: Text("₹ ${data?.price ?? ""}",
                                  style: TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 11,
                                      fontWeight: FontWeight.normal)),
                              margin: EdgeInsets.symmetric(horizontal: 10),
                            ),
                            // Text(
                            //   data?.getDiscount() ?? "",
                            //   style: const TextStyle(
                            //     fontWeight: FontWeight.bold,
                            //     color: Colors.grey,
                            //     fontSize: 11,
                            //   ),
                            // ),
                          ]),
                      const SizedBox(height: 15),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget buildCategories(CategoriesItem? data) {
    return Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 10),
        child: InkWell(
          onTap: () {
            analytics.logEvent(category_card_click,
                eventProperties: {category: data?.name ?? ""});
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    ProductListingScreen(data?.id, data?.name),
              ),
            );
          },
          child: Container(
            width: 140,
            height: 160,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              data?.images.data.first.url.toString() ?? ""),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(5)),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    data?.name.toString() ?? "",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget callApi(HomeViewModel vs) {
    switch (vs.loadingStatus) {
      case LoadingStatus.searching:
        return Center(
          child: CircularProgressIndicator(),
        );
      case LoadingStatus.completed:
        return getBody();
      case LoadingStatus.empty:
        return Center(
          child: Text("No results found"),
        );
      default:
        return Center(
          child: Text("No results found"),
        );
    }
  }
}
