import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vstextile/models/categories/categories_data.dart';
import 'package:vstextile/models/home/carousel.dart';
import 'package:vstextile/providers/firebase_dynamic_link.dart';
import 'package:vstextile/utils/amplitude.dart';

class CustomeCarouselHomePage extends StatefulWidget {
  final List<CarouselItemData> items;
  final bool enLargeCenter;
  final CarouselController _controller = CarouselController();

  CustomeCarouselHomePage({required this.items, required this.enLargeCenter});

  @override
  _CustomeCarouselHomePageState createState() =>
      _CustomeCarouselHomePageState();
}

class _CustomeCarouselHomePageState extends State<CustomeCarouselHomePage> {
  int _current = 0;
  late final List<Widget> imageSliders;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    imageSliders = widget.items
        .map((item) => Container(
              child: Container(
                padding: EdgeInsets.only(top: 20),
                margin: EdgeInsets.all(2.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.network(item.images.url,
                            fit: BoxFit.cover, width: 1000.0),
                      ],
                    )),
              ),
            ))
        .toList();
  }

  final CarouselController _controller = CarouselController();

  setActiveDot(index) {
    setState(() {
      _current = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        GestureDetector(
            onTap: () {
              debugPrint("CLicked ==============================");
              analytics.logEvent(banner_click, eventProperties: {
                position: _current + 1,
                total: widget.items.length
              });
              launchURL(widget.items[_current].url);
            },
            child: Container(
              margin: EdgeInsets.all(15),
              width: MediaQuery.of(context).size.width,
              child: CarouselSlider(
                carouselController: _controller,
                options: CarouselOptions(
                    autoPlay: false,
                    enlargeCenterPage: widget.enLargeCenter,
                    aspectRatio: 2.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }),
                items: imageSliders,
              ),
            )),
        Positioned(
          left: 0,
          right: 0,
          bottom: -10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.items.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: 18.0,
                  height: 3.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 3.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      shape: BoxShape.rectangle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black)
                          .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  launchURL(url) async {
    try {
      await launch(
        url,
        forceSafariVC: true,
        enableJavaScript: true,
      );
    } catch (e, s) {
      s.toString();
    }
  }
}

class BasicDemo extends StatefulWidget {
  final List<ImageArrayData> items;
  final String id;
  BasicDemo({required this.items, required this.id});

  @override
  _BasicDemo createState() => _BasicDemo();
}

class _BasicDemo extends State<BasicDemo> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.none, children: <Widget>[
      Container(
        child: CarouselSlider(
          options: CarouselOptions(
              aspectRatio: 1,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              onPageChanged: ((index, reason) => {
                    setState(() {
                      _current = index;
                    })
                  })),
          items: widget.items
              .map(
                (item) => Container(
                  width: double.infinity,
                  child: CachedNetworkImage(
                    maxHeightDiskCache: 900,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.fill),
                      ),
                    ),
                    imageUrl: item.url,
                    placeholder: (context, url) =>
                        SvgPicture.asset("assets/images/ic_gallery.svg"),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              )
              .toList(),
        ),
      ),
      Positioned(
        left: 0,
        right: 0,
        bottom: -20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.items.asMap().entries.map((entry) {
            return GestureDetector(
              child: Container(
                width: 18.0,
                height: 3.0,
                margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    shape: BoxShape.rectangle,
                    color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black)
                        .withOpacity(_current == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList(),
        ),
      ),
      Positioned(
          right: 15,
          bottom: 15,
          child: GestureDetector(
              onTap: () async {
                analytics.logEvent(share_product);
                var link = await FirebaseDynamicLinkService.createDynamicLink(
                    true, widget.id);
                Share.share(link);
              },
              child: SvgPicture.asset("assets/images/ic_share.svg"))),
    ]);
  }
}
