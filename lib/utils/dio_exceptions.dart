

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vstextile/screen/login_screen.dart';

class DioExceptions implements Exception {
  var message = "";

  DioExceptions.fromDioError(DioError dioError, BuildContext context) {
    switch (dioError.type) {
      case DioErrorType.cancel:
        message = "Request to API server was cancelled";
        break;
      case DioErrorType.connectTimeout:
        message = "Connection timeout with API server";
        break;
      case DioErrorType.receiveTimeout:
        message = "Receive timeout in connection with API server";
        break;
      case DioErrorType.response:
        message =
            _handleError(dioError.response?.statusCode!, dioError.response?.data,context);
        break;
      case DioErrorType.sendTimeout:
        message = "Send timeout in connection with API server";
        break;
      default:
        message = "Something went wrong";
        break;
    }
  }

  String _handleError(int? statusCode, dynamic? error, BuildContext context) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 404:
        return error["message"].toString().replaceAll("[", "").replaceAll("]", "");
      case 403:
        if(error["message"].toString().toLowerCase().contains("invalid token"))
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen(),
          ),
        );
        if(error.toString().contains("invalid_fields")){
          Fluttertoast.showToast(
            msg: "Invalid ${error["invalid_fields"][0]}",
            toastLength: Toast.LENGTH_SHORT,
            fontSize: 14.0,
          );
        }
        return error["message"].toString().replaceAll("[", "").replaceAll("]", "");
      case 500:
        return 'Internal server error';
      default:
        return 'Oops something went wrong';
    }
  }

  @override
  String toString() => message;
}
