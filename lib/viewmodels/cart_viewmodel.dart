import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vstextile/models/cart/Cart.dart';
import 'package:vstextile/models/home/HomeData.dart';
import 'package:vstextile/models/categories/categories_data.dart';
import 'package:vstextile/models/news_article.dart';
import 'package:vstextile/services/web_service.dart';

import '../models/address/Address.dart';
import '../models/address/DeliveryAddress.dart';
import '../models/cart/CheckOutResponse.dart';

enum LoadingStatus {
  completed,
  searching,
  empty,
}

class CartViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;

  Future<Cart> getCart(BuildContext context) async {
    this.loadingStatus = LoadingStatus.searching;
    notifyListeners();
    final user = await FirebaseAuth.instance.currentUser!;
    final idToken = await user.getIdToken();
    debugPrint("token " + idToken);
    dynamic result = await WebService().getCart(idToken, context);
    debugPrint("result ${result.toString()}" );
    if(result ==null)
      this.loadingStatus = LoadingStatus.empty;
      else
    this.loadingStatus = LoadingStatus.completed;
    notifyListeners();
    return result;
  }
  Future<Cart> removeCart(BuildContext context,int id) async {
    this.loadingStatus = LoadingStatus.searching;
    notifyListeners();
    final user = await FirebaseAuth.instance.currentUser!;
    final idToken = await user.getIdToken();
    debugPrint("token " + idToken);
    dynamic result = await WebService().removeCart(idToken, context,id);
    this.loadingStatus = LoadingStatus.completed;
    notifyListeners();
    return result;
  }

  Future<Cart> updateCart(BuildContext context,int cartID, int quantity) async {
    this.loadingStatus = LoadingStatus.searching;
    notifyListeners();
    final user = await FirebaseAuth.instance.currentUser!;
    final idToken = await user.getIdToken();
    debugPrint("token " + idToken);
    dynamic result = await WebService().updateCart(idToken, context,cartID,quantity);
    this.loadingStatus = LoadingStatus.completed;
    notifyListeners();
    return result;
  }


  Future<DeliveryAddress?> getAddress(BuildContext context) async {
    this.loadingStatus = LoadingStatus.searching;
    notifyListeners();
    final user = await FirebaseAuth.instance.currentUser!;
    final idToken = await user.getIdToken();
    debugPrint("token " + idToken);
    dynamic result = await WebService().getAddress(idToken,context);

    debugPrint("result " + result.toString());
    if(result != null && result is DeliveryAddress){
      this.loadingStatus = LoadingStatus.completed;
      if(result.deliveryAddresses.error == true){
        Fluttertoast.showToast(
            msg: result.deliveryAddresses.message?[0]??"",
            toastLength: Toast.LENGTH_SHORT,
            textColor: Colors.white);
      }
      return result;
    }else{
      this.loadingStatus = LoadingStatus.empty;
    }

    notifyListeners();
    return result;
  }


  dynamic productcheckOut(BuildContext context,String amount,int varaint,int quantity,int address_id) async {

    this.loadingStatus = LoadingStatus.searching;
    notifyListeners();

    var params = {
      "address_id":address_id,
      "varaint":varaint,
      "quantity": quantity,
      "amount": amount,
    };

    debugPrint("params $params");
    final user = await FirebaseAuth.instance.currentUser!;
    final idToken = await user.getIdToken();
    dynamic result = await WebService().productCheckout(context,idToken,params);
    dynamic finalData;

    if(result == null || result is String){
      finalData = result;
    }else if (result is CheckOutResponse){
      finalData = result;
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

  dynamic checkoutcart(BuildContext context,String amount,int address_id) async {

    this.loadingStatus = LoadingStatus.searching;
    notifyListeners();

    var params = {
      "address_id":address_id,
      "amount": amount,
    };

    debugPrint("params $params");
    final user = await FirebaseAuth.instance.currentUser!;
    final idToken = await user.getIdToken();
    dynamic result = await WebService().checkoutcart(context,idToken,params);
    dynamic finalData;

    if(result == null || result is String){
      finalData = result;
    }else if (result is CheckOutResponse){
      finalData = result;
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
