import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vstextile/models/home/HomeData.dart';
import 'package:vstextile/models/categories/categories_data.dart';
import 'package:vstextile/models/news_article.dart';
import 'package:vstextile/services/web_service.dart';

import '../models/product/product_list_data.dart';

enum LoadingStatus {
  completed,
  searching,
  empty,
}

class ProductListingViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;
  List<String> articles = <String>[];

  Future<ProductListData> getProductListing(BuildContext context,int categoryID) async {
    this.loadingStatus = LoadingStatus.searching;
    notifyListeners();
    final user = await FirebaseAuth.instance.currentUser!;
    final idToken = await user.getIdToken();
    debugPrint("token " + idToken);
    dynamic result = await WebService().getProductListing(idToken, context,categoryID);

    if (result != null && result is ProductListData) {
      this.loadingStatus = LoadingStatus.completed;
      return result;
    } else {
      this.loadingStatus = LoadingStatus.empty;
    }

    notifyListeners();
    return result;
  }
}
