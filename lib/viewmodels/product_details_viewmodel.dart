import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vstextile/models/cart/AddToCartResponse.dart';
import 'package:vstextile/models/product/product_details.dart';
import 'package:vstextile/services/web_service.dart';


enum LoadingStatus {
  completed,
  searching,
  empty,
}

class ProductDetailsViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;
  List<String> articles = <String>[];

  Future<ProductDetails> getProductDetails(BuildContext context,int productID) async {
    this.loadingStatus = LoadingStatus.searching;
    notifyListeners();
    final user = FirebaseAuth.instance.currentUser!;
    final idToken = await user.getIdToken();
    debugPrint("token " + idToken);
    dynamic result = await WebService().getProductDetails(idToken, context,productID);

    if (result != null && result is ProductDetails) {
      this.loadingStatus = LoadingStatus.completed;
      return result;
    } else {
      this.loadingStatus = LoadingStatus.empty;
    }

    notifyListeners();
    return result;
  }



  dynamic addToCart(BuildContext context,int id,int quantity) async {
    debugPrint("Quantity $quantity");
    this.loadingStatus = LoadingStatus.searching;
    notifyListeners();

    var params = {
      "component_id":id,
      "quantity": quantity,
    };
    final user = FirebaseAuth.instance.currentUser!;
    final idToken = await user.getIdToken();
    dynamic result = await WebService().addToCart(context,idToken,params);
    dynamic finalData;

    if(result == null || result is String){
      finalData = result;
    }else if (result is AddToCartResponse){
      finalData = result;
    }else {
      Map<String, dynamic> data = Map<String, dynamic>.from(
          result as Map<dynamic, dynamic>);
      finalData = AddToCartResponse.fromJson(data);
    }

    if (result == null || result is String) {
      this.loadingStatus = LoadingStatus.empty;
    } else {
      this.loadingStatus = LoadingStatus.completed;
    }

    this.loadingStatus = LoadingStatus.completed;
    notifyListeners();
    return finalData;
  }
}
