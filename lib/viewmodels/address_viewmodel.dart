import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vstextile/models/address/Address.dart';
import 'package:vstextile/services/web_service.dart';
import 'package:vstextile/utils/amplitude.dart';

import '../models/address/DeliveryAddress.dart';

enum LoadingStatus {
  completed,
  searching,
  empty,
}

class AddressViewModel with ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;
  List<String> articles = <String>[];

  Future<DeliveryAddress?> getAddress(BuildContext context) async {
    this.loadingStatus = LoadingStatus.searching;
    notifyListeners();
    final user = FirebaseAuth.instance.currentUser!;
    final idToken = await user.getIdToken();
    debugPrint("token " + idToken);
    dynamic result = await WebService().getAddress(idToken, context);
    if (result != null && result is DeliveryAddress) {
      this.loadingStatus = LoadingStatus.completed;
      return result;
    } else {
      this.loadingStatus = LoadingStatus.empty;
    }

    notifyListeners();
    return result;
  }

  Future<Address> removeAddress(BuildContext context, int id) async {
    this.loadingStatus = LoadingStatus.searching;
    notifyListeners();
                                analytics.logEvent(remove_address);

    final user = FirebaseAuth.instance.currentUser!;
    final idToken = await user.getIdToken();
    debugPrint("token " + idToken);
    dynamic result = await WebService().removeAddres(idToken, context, id);
    this.loadingStatus = LoadingStatus.completed;
    notifyListeners();
    return result;
  }

  dynamic addAddress(
    BuildContext context,
    String name,
    String city,
    String state,
    String locality,
    String flatNo,
    String phoneNumber,
    String pincode,
    int addressType,
    bool defaultAddress,
  ) async {
    this.loadingStatus = LoadingStatus.searching;
    notifyListeners();
    analytics.logEvent(save_address, eventProperties: {type: "Add"});

    var params = {
      "name": name,
      "city": city,
      "state": state,
      "locality": locality,
      "flat_no": flatNo,
      "phone_number": phoneNumber,
      "pincode": pincode,
      "address_type": addressType,
      "default_address": defaultAddress,
    };

    debugPrint("params $params");
    final user = FirebaseAuth.instance.currentUser!;
    final idToken = await user.getIdToken();
    dynamic result = await WebService().addAddress(context, idToken, params);
    dynamic finalData;

    if (result == null || result is String) {
      finalData = result;
    } else if (result is DeliveryAddress) {
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

  dynamic updateAddress(
    BuildContext context,
    int addressId,
    String name,
    String city,
    String state,
    String locality,
    String flatNo,
    String phoneNumber,
    String pincode,
    int addressType,
    bool defaultAddress,
  ) async {
    this.loadingStatus = LoadingStatus.searching;
    notifyListeners();
    analytics.logEvent(save_address, eventProperties: {type: "Update"});

    var params = {
      "address_id": addressId,
      "name": name,
      "city": city,
      "state": state,
      "locality": locality,
      "flat_no": flatNo,
      "phone_number": phoneNumber,
      "pincode": pincode,
      "address_type": addressType,
      "default_address": defaultAddress,
    };

    debugPrint("params $params");
    final user = FirebaseAuth.instance.currentUser!;
    final idToken = await user.getIdToken();
    dynamic result = await WebService().updateAddress(context, idToken, params);
    dynamic finalData;

    if (result == null || result is String) {
      finalData = result;
    } else if (result is DeliveryAddress) {
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
