import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vstextile/models/home/HomeData.dart';
import 'package:vstextile/models/news_article.dart';
import 'package:vstextile/services/web_service.dart';

enum LoadingStatus {
  completed,
  searching,
  empty,
}

class HomeViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;
  List<String> articles = <String>[];

  Future<HomeData?> getHomeFeed(BuildContext context) async {
    this.loadingStatus = LoadingStatus.searching;
    notifyListeners();
    final user = await FirebaseAuth.instance.currentUser!;
    final idToken = await user.getIdToken();
    debugPrint("token " + idToken);
    dynamic result = await WebService().getHomeFeed(idToken,context);
    if(result != null && result is HomeData){
      this.loadingStatus = LoadingStatus.completed;
      return result;
    }else{
      this.loadingStatus = LoadingStatus.empty;
    }

    notifyListeners();
    return result;
  }


}
