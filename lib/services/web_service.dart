
import 'package:dio/dio.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vstextile/models/cart/AddToCartResponse.dart';
import 'package:vstextile/models/cart/CheckOutResponse.dart';
import 'package:vstextile/models/product/product_details.dart';
import 'package:vstextile/models/product/product_list_data.dart';
import 'package:vstextile/models/profile/UserData.dart';
import 'package:vstextile/utils/constants.dart';

import '../models/address/Address.dart';
import '../models/address/DeliveryAddress.dart';
import '../models/cart/Cart.dart';
import '../models/home/HomeData.dart';
import '../models/categories/categories_data.dart';
import '../utils/dio_exceptions.dart';

class WebService {
  var dio = new Dio();

  void initDio() {
    dio.interceptors.add(InterceptorsWrapper(onError: (e, handler) {
      print("error ======>>>> " + e.message);
      handler.next(e);
    }, onRequest: (r, handler) {
      print(r.method);
      print(r.path);
      handler.next(r);
    }, onResponse: (r, handler) {
      print(r.data);
      handler.next(r);
    }));
  }

  Future<dynamic> getProfile(String token, BuildContext context) async {
    try {
      initDio();
      dio.options.headers["authorization"] = "Bearer $token";
      final response = await dio.get(Constants.getProfile());
      if (response.statusCode == 200) {
        final result = response.data;
        return result;
      } else {
        throw Exception("Failled to get data");
      }
    } catch (e) {
      return handleException(e, context);
    }
    return [];
  }

  Future<dynamic> getCategories(String token, BuildContext context) async {
    dynamic finalData;
    try {
      initDio();
      dio.options.headers["authorization"] = "Bearer $token";
      dio.options.queryParameters["limit"] = "10";
      dio.options.queryParameters["offset"] = "0";
      final response = await dio.get(Constants.getCategories());
      if (response.statusCode == 200) {
        final result = response.data;
        if (result is String) {
          finalData = result;
        }
        else{
          Map<String, dynamic> data =
          Map<String, dynamic>.from(result as Map<dynamic, dynamic>);
          finalData = CategoriesData.fromJson(data);
        }
      } else {
        throw Exception("Failled to get data");
      }
    } catch (e) {
      handleException(e, context);
    }
    return finalData;
  }


  Future<dynamic> getCart(String token, BuildContext context) async {
    dynamic finalData;
    try {
      initDio();
      dio.options.headers["authorization"] = "Bearer $token";
      final response = await dio.get(Constants.getCart());
      if (response.statusCode == 200) {
        final result = response.data;
        if (result is String) {
          finalData = result;
        }
        else{
          Map<String, dynamic> data =
          Map<String, dynamic>.from(result as Map<dynamic, dynamic>);
          finalData = Cart.fromJson(data);
        }
      } else {
        throw Exception("Failled to get data");
      }
    } catch (e,s) {
    debugPrint("stacktrace ::  " + s.toString());
      await handleException(e, context);
    }
    return finalData;
  }

  Future<dynamic> removeCart(String token, BuildContext context,int id) async {
    dynamic finalData;
    try {
      initDio();
      dio.options.headers["authorization"] = "Bearer $token";
      final response = await dio.delete(Constants.removeCart(id));
      if (response.statusCode == 200) {
        final result = response.data;
        if (result is String) {
          finalData = result;
        }
        else{
          Map<String, dynamic> data =
          Map<String, dynamic>.from(result as Map<dynamic, dynamic>);
          finalData = Cart.fromJson(data);
        }
      } else {
        throw Exception("Failled to get data");
      }
    } catch (e) {
      await handleException(e, context);
    }
    return finalData;
  }

  Future<dynamic> removeAddres(String token, BuildContext context,int id) async {
    dynamic finalData;
    try {
      initDio();
      dio.options.headers["authorization"] = "Bearer $token";
      final response = await dio.delete(Constants.removeAddress(id));
      if (response.statusCode == 200) {
        final result = response.data;
        if (result is String) {
          finalData = result;
        }
        else{
          Map<String, dynamic> data =
          Map<String, dynamic>.from(result as Map<dynamic, dynamic>);
          finalData = Address.fromJson(data);
        }
      } else {
        throw Exception("Failled to get data");
      }
    } catch (e) {
      await handleException(e, context);
    }
    return finalData;
  }
  Future<dynamic> updateCart(String token, BuildContext context,int cartID,int quantity) async {
    dynamic finalData;
    try {
      initDio();
      dio.options.headers["authorization"] = "Bearer $token";
      final response = await dio.patch(Constants.updateCart(cartID,quantity));
      if (response.statusCode == 200) {
        final result = response.data;
        if (result is String) {
          finalData = result;
        }
        else{
          Map<String, dynamic> data =
          Map<String, dynamic>.from(result as Map<dynamic, dynamic>);
          finalData = Cart.fromJson(data);
        }
      } else {
        throw Exception("Failled to get data");
      }
    } catch (e) {
      await handleException(e, context);
    }
    return finalData;
  }

  Future<dynamic> updateAddress(
      BuildContext context, String token, Map<String, Object> params) async {
    dynamic finalData;
    try {
      initDio();
      dio.options.headers["authorization"] = "Bearer $token";
      dio.options.headers["Content-Type"] = "application/json";
      final response =
      await dio.patch(Constants.updateAddress(), data: params);
      if (response. statusCode == 200) {
        final result = response.data;
        if (result is String) {
          finalData = result;
        }
        else{
          Map<String, dynamic> data =
          Map<String, dynamic>.from(result as Map<dynamic, dynamic>);
          finalData = DeliveryAddress.fromJson(data);
        }
      } else {
        throw Exception("Failled to get data");
      }
    } catch (e) {
      await handleException(e, context);
    }
    return finalData;
  }

  Future<dynamic> getProductListing(
      String token, BuildContext context, int categoryID) async {
    dynamic finalData;
    try {
      initDio();
      dio.options.headers["authorization"] = "Bearer $token";
      dio.options.queryParameters["limit"] = "10";
      dio.options.queryParameters["offset"] = "0";
      final response = await dio.get(Constants.getProductListing(categoryID));
      if (response.statusCode == 200) {
        final result = response.data;
        if (result is String) {
          finalData = result;
        }
        else{
          Map<String, dynamic> data =
          Map<String, dynamic>.from(result as Map<dynamic, dynamic>);
          finalData = ProductListData.fromJson(data);
        }
      } else {
        throw Exception("Failled to get data");
      }
    } catch (e,s) {
      print('Stacktrace: ' + s.toString());
      handleException(e, context);
    }
    return finalData;
  }

  Future<dynamic> getProductDetails(
      String token, BuildContext context, int productID) async {
    dynamic finalData;
    try {
      initDio();
      dio.options.headers["authorization"] = "Bearer $token";
      final response = await dio.get(Constants.getProductDetails(productID));
      if (response.statusCode == 200) {
        final result = response.data;
        if (result is String) {
          finalData = result;
        }
        else{
          Map<String, dynamic> data =
          Map<String, dynamic>.from(result as Map<dynamic, dynamic>);
          finalData = ProductDetails.fromJson(data);
        }
      } else {
        throw Exception("Failled to get data");
      }
    } catch (e,s) {
      print('Stacktrace: ' + s.toString());
      handleException(e, context);
    }
    return finalData;
  }

  Future<dynamic> getHomeFeed(String token, context) async {
    dynamic finalData;
    try {
      initDio();
      dio.options.headers["authorization"] = "Bearer $token";
      final response = await dio.get(Constants.getHomeFeed());
      if (response.statusCode == 200) {
        final result = response.data;
        if (result is String) {
          finalData = result;
        }
       else{
          Map<String, dynamic> data =
              Map<String, dynamic>.from(result as Map<dynamic, dynamic>);
          finalData = HomeData.fromJson(data);
        }
      } else {
        throw Exception("Failled to get data");
      }
    } catch (e) {
      handleException(e, context);
    }
    return finalData;
  }

  Future<dynamic> getAddress(String token, context) async {
    dynamic finalData;
    try {
      initDio();
      dio.options.headers["authorization"] = "Bearer $token";
      final response = await dio.get(Constants.getAddress());
      if (response.statusCode == 200) {
        final result = response.data;
        if (result is String) {
          finalData = result;
        }
       else{
          Map<String, dynamic> data =
              Map<String, dynamic>.from(result as Map<dynamic, dynamic>);
          finalData = DeliveryAddress.fromJson(data);
        }
      } else {
        throw Exception("Failled to get data");
      }
    } catch (e) {
      handleException(e, context);
    }
    return finalData;
  }
  Future<dynamic> getOrders(String token, context) async {
    dynamic finalData;
    try {
      initDio();
      dio.options.headers["authorization"] = "Bearer $token";
      final response = await dio.get(Constants.getOrders());
      if (response.statusCode == 200) {
        final result = response.data;
        if (result is String) {
          finalData = result;
        }
       else{
          Map<String, dynamic> data =
              Map<String, dynamic>.from(result as Map<dynamic, dynamic>);
          finalData = Address.fromJson(data);
        }
      } else {
        throw Exception("Failled to get data");
      }
    } catch (e) {
      handleException(e, context);
    }
    return finalData;
  }

  Future<dynamic> editProfile(
      BuildContext context, String token, Map<String, Object> params) async {
    dynamic finalData;
    try {
      initDio();
      dio.options.headers["authorization"] = "Bearer $token";
      dio.options.headers["Content-Type"] = "application/json";
      final response =
          await dio.post(Constants.editProfile(token), data: params);
      if (response. statusCode == 200) {
        final result = response.data;
        if (result is String) {
          finalData = result;
        }
        else{
          Map<String, dynamic> data =
          Map<String, dynamic>.from(result as Map<dynamic, dynamic>);
          finalData = UserData.fromJson(data);
        }
      } else {
        throw Exception("Failled to get data");
      }
    } catch (e) {
      await handleException(e, context);
    }
    return finalData;
  }

  Future<dynamic> addProfile(
      BuildContext context, String token, Map<String, Object> params) async {
    dynamic finalData;
    try {
      initDio();
      dio.options.headers["authorization"] = "Bearer $token";
      dio.options.headers["Content-Type"] = "application/json";
      final response =
          await dio.post(Constants.addProfile(token), data: params);
      if (response.statusCode == 200) {
        final result = response.data;
        if (result is String) {
          finalData = result;
        }
        else{
          Map<String, dynamic> data =
          Map<String, dynamic>.from(result as Map<dynamic, dynamic>);
          finalData = UserData.fromJson(data);
        }
      } else {
        throw Exception("Failled to get data");
      }
    } catch (e) {
       await handleException(e, context);
    }
    return finalData;
  }

  Future<dynamic>   addToCart(
      BuildContext context, String token, Map<String, Object> params) async {
    dynamic finalData;
    try {
      initDio();
      dio.options.headers["authorization"] = "Bearer $token";
      dio.options.headers["Content-Type"] = "application/json";
      final response =
          await dio.post(Constants.addToCart(),data:params);
      if (response.statusCode == 200) {
        final result = response.data;
        if (result is String) {
          finalData = result;
        }
        else{
          Map<String, dynamic> data =
          Map<String, dynamic>.from(result as Map<dynamic, dynamic>);
          finalData = AddToCartResponse.fromJson(data);
        }
      } else {
        throw Exception("Failled to get data");
      }
    } catch (e) {
       await handleException(e, context);
    }
    return finalData;
  }

  Future<dynamic>   productCheckout(
      BuildContext context, String token, Map<String, Object> params) async {
    dynamic finalData;
    try {
      initDio();
      dio.options.headers["authorization"] = "Bearer $token";
      dio.options.headers["Content-Type"] = "application/json";
      final response =
          await dio.post(Constants.productCheckout(),data:params);
      if (response.statusCode == 200) {
        final result = response.data;
        if (result is String) {
          finalData = result;
        }
        else{
          Map<String, dynamic> data =
          Map<String, dynamic>.from(result as Map<dynamic, dynamic>);
          finalData = CheckOutResponse.fromJson(data);
        }
      } else {
        throw Exception("Failled to get data");
      }
    } catch (e) {
       await handleException(e, context);
    }
    return finalData;
  }


  Future<dynamic>   checkoutcart(
      BuildContext context, String token, Map<String, Object> params) async {
    dynamic finalData;
    try {
      initDio();
      dio.options.headers["authorization"] = "Bearer $token";
      dio.options.headers["Content-Type"] = "application/json";
      final response =
          await dio.post(Constants.checkoutcart(),data:params);
      if (response.statusCode == 200) {
        final result = response.data;
        if (result is String) {
          finalData = result;
        }
        else{
          Map<String, dynamic> data =
          Map<String, dynamic>.from(result as Map<dynamic, dynamic>);
          finalData = CheckOutResponse.fromJson(data);
        }
      } else {
        throw Exception("Failled to get data");
      }
    } catch (e) {
       await handleException(e, context);
    }
    return finalData;
  }

  dynamic checkForString(result) {
    dynamic finalData;
    if (result is String) {
      finalData = result;
    }
    return finalData;
  }


  Future<dynamic> addAddress(
      BuildContext context, String token, Map<String, Object> params) async {
    dynamic finalData;
    try {
      initDio();
      dio.options.headers["authorization"] = "Bearer $token";
      dio.options.headers["Content-Type"] = "application/json";
      final response =
      await dio.post(Constants.addAddress(), data: params);
      if (response. statusCode == 200) {
        final result = response.data;
        if (result is String) {
          finalData = result;
        }
        else{
          Map<String, dynamic> data =
          Map<String, dynamic>.from(result as Map<dynamic, dynamic>);
          finalData = DeliveryAddress.fromJson(data);
        }
      } else {
        throw Exception("Failled to get data");
      }
    } catch (e) {
      await handleException(e, context);
    }
    return finalData;
  }
  dynamic handleException( e, BuildContext context) {
    if (e is DioError) {
      final errorMessage =
          DioExceptions.fromDioError(e, context).toString();
      print(errorMessage);
      if (errorMessage != "User not found.")
        Fluttertoast.showToast(
            msg: errorMessage, // message
            toastLength: Toast.LENGTH_SHORT, // length
            gravity: ToastGravity.BOTTOM, // location
            timeInSecForIosWeb: 1 // duration

            );
      return errorMessage;
    } else {
      print("print exceptions == "+e.toString());
      return e.toString();
    }
  }
}
