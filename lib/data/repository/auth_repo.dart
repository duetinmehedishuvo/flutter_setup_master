
import 'package:dio/dio.dart';
import 'package:ecommerce_ael/data/datasource/remote/dio/dio_client.dart';
import 'package:ecommerce_ael/data/datasource/remote/exception/api_error_handler.dart';
import 'package:ecommerce_ael/data/model/body/login_model.dart';
import 'package:ecommerce_ael/data/model/body/register_model.dart';
import 'package:ecommerce_ael/data/model/response/base/api_response.dart';
import 'package:ecommerce_ael/utill/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({@required this.dioClient, @required this.sharedPreferences});

  Future<ApiResponse> registration(RegisterModel register) async {
    try {
      Response response = await dioClient.post(
        AppConstants.REGISTRATION_URI,
        data: register.toJson(),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> login(LoginModel loginBody) async {
    try {
      Response response = await dioClient.post(
        AppConstants.LOGIN_URI,
        data: loginBody.toJson(),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  // for  user token
  Future<void> saveUserToken(String token) async {
      dioClient.token = token;
      dioClient.dio.options.headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      };

    try {
      await sharedPreferences.setString(AppConstants.TOKEN, token);
    } catch (e) {
      throw e;
    }
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.TOKEN) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.TOKEN);
  }

  Future<bool> clearSharedData() async {
    sharedPreferences.remove(AppConstants.CART_LIST);
    sharedPreferences.remove(AppConstants.CURRENCY);
    sharedPreferences.remove(AppConstants.TOKEN);
    sharedPreferences.remove(AppConstants.USER);
    return sharedPreferences.clear();
  }


  // for  Remember Email
  Future<void> saveUserEmailAndPassword(String email, String password) async {
    try {
      await sharedPreferences.setString(AppConstants.USER_PASSWORD, password);
      await sharedPreferences.setString(AppConstants.USER_EMAIL, email);
    } catch (e) {
      throw e;
    }
  }

  String getUserEmail() {
    return sharedPreferences.getString(AppConstants.USER_EMAIL) ?? "";
  }

  String getUserPassword() {
    return sharedPreferences.getString(AppConstants.USER_PASSWORD) ?? "";
  }

  Future<bool> clearUserEmailAndPassword() async {
    await sharedPreferences.remove(AppConstants.USER_PASSWORD);
    return await sharedPreferences.remove(AppConstants.USER_EMAIL);
  }

  Future<ApiResponse> forgetPassword(String email) async {
    try {
      Response response = await dioClient.post(AppConstants.FORGET_PASSWORD_URI, data: {"email": email});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}
