import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vstextile/models/home/HomeData.dart';
import 'package:vstextile/models/categories/categories_data.dart';
import 'package:vstextile/models/news_article.dart';
import 'package:vstextile/services/web_service.dart';

enum LoadingStatus {
  completed,
  searching,
  empty,
}

class OrdersViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;
  List<String> articles = <String>[];

  Future<CategoriesData> getOrders(BuildContext context) async {
    this.loadingStatus = LoadingStatus.searching;
    notifyListeners();
    final user = await FirebaseAuth.instance.currentUser!;
    final idToken = await user.getIdToken();
    debugPrint("token " + idToken);
    dynamic result = await WebService().getOrders(idToken, context);

    if (result != null && result is CategoriesData) {
      this.loadingStatus = LoadingStatus.completed;
      return result;
    } else {
      this.loadingStatus = LoadingStatus.empty;
    }

    notifyListeners();
    return result;
  }
}