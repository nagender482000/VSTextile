//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import 'package:flutter/material.dart';
import 'package:vstextile/screen/product_details_screen.dart';

//FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

class FirebaseDynamicLinkService {
  static Future<String> createDynamicLink(bool short, id) async {
    String _linkMessage;

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://vstextile.page.link',
      link: Uri.parse('https://vstextile.co/product?id=$id'),
      androidParameters: AndroidParameters(
        packageName: 'co.vstextile',
        minimumVersion: 1,
      ),
      //iosParameters: const IOSParameters(bundleId: "com.example.app.ios"),
    );

    Uri url;
    if (short) {
      final shortLink =
          await FirebaseDynamicLinks.instance.buildShortLink(parameters);
      url = shortLink.shortUrl;
    } else {
      url = await FirebaseDynamicLinks.instance.buildLink(parameters);
    }

    _linkMessage = url.toString();
    return _linkMessage;
  }

  static Future<void> initDynamicLink(BuildContext context) async {
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      final Uri deepLink = dynamicLinkData.link;
      print("deeplink " + deepLink.toString());
      try {
        // var isid = deepLink.pathSegments.contains('id');
        // print(isid);
        // if (isid) {
        String sid = deepLink.queryParameters['id'].toString();
        print(sid);

        int id = int.parse(sid.toString());
        print(id);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ProductDetailsScreen(id)));
        //}
      } catch (e) {
        print("3 " + e.toString());
      }
    }).onError((error) {
      print('link error' + error.toString());
    });

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    print(data);

    try {
      final Uri deepLink = data!.link;
      print("link " + deepLink.toString());
      try {
        // var isid = deepLink.pathSegments.contains('id');
        // if (isid) {
        int id = int.parse(deepLink.queryParameters['id'].toString());
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ProductDetailsScreen(id)));
        //}
      } catch (e) {
        print("1 " + e.toString());
      }
    } catch (e) {
      print("2 " + e.toString());
    }
  }
}
