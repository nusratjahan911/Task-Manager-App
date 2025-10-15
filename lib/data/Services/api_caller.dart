import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:task_manager/app.dart';
import 'package:task_manager/ui/controller/auth_controller.dart';
import 'package:task_manager/ui/screens/login_screen.dart';

class ApiCaller {
   static final Logger _logger = Logger();


/// For get reqyest
  static Future<ApiResponse> getRequest({required String url}) async {
    try {
      Uri uri = Uri.parse(url);
      
      _logRequest(url); ///Response pawar age request
      ///
      Response response = await get(uri, headers: {
        'token':AuthController.accessToken ?? ''
      }); /// awiting for response
      
      _logResponse(url, response);
      
      final int statusCode = response.statusCode;
      if (statusCode == 200) {
        ///for success
        final decodedData = jsonDecode(response.body);
        return ApiResponse(
            isSuccess: true,
            responseCode: statusCode,
            responseData: decodedData);
      } else if(statusCode == 401){
        await _moveToLogin();
        return ApiResponse(
          isSuccess: false,
          responseCode: statusCode,
          responseData: null,
          errorMessage: 'un-authorize',
        );
      }else {
        ///Failed
        final decodedData = jsonDecode(response.body);
        return ApiResponse(
            isSuccess: false,
            responseCode: statusCode,
            responseData: decodedData,
          errorMessage: decodedData['data'],
        );
      }
    } on Exception catch (e) {
      return ApiResponse(
          isSuccess: false,
          responseCode: -1,
          responseData: null,
        errorMessage: e.toString()
      );
    }
  }

/// for Post Request
  static Future<ApiResponse> postRequest({required String url, Map<String, dynamic>? body }) async {
    try {
      Uri uri = Uri.parse(url);

      _logRequest(url, body: body); ///Response pawar age request
      ///
      Response response = await post(uri,
          headers: {
        'content-type' : 'application/json' ,
            'token': AuthController.accessToken ?? ''
          },
          body: jsonEncode(body)
      ); /// awiting for response

      _logResponse(url, response);

      final int statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        ///for success
        final decodedData = jsonDecode(response.body);
        return ApiResponse(
            isSuccess: true,
            responseCode: statusCode,
            responseData: decodedData);
      } else if(statusCode == 401){
        await _moveToLogin();
        return ApiResponse(
          isSuccess: false,
          responseCode: statusCode,
          responseData: null,
          errorMessage: 'un-authorize',
        );
      }else {
        ///Failed
        final decodedData = jsonDecode(response.body);
        return ApiResponse(
          isSuccess: false,
          responseCode: statusCode,
          responseData: decodedData,
          errorMessage: decodedData['data'],
        );
      }
    } on Exception catch (e) {
      return ApiResponse(
          isSuccess: false,
          responseCode: -1,
          responseData: null,
          errorMessage: e.toString()
      );
    }
  }


  /// Printing response in console uses this logger
 ///for log request
  static void _logRequest(String url, {Map<String, dynamic>? body}){
    _logger.i('URL => $url\n'
    'Request Body: $body');
  }

  ///for log response
static void _logResponse(String url, Response response){
    _logger.i('URL => $url\n'
        'Status Code: ${response.statusCode}\n'
        'Body : ${response.body}');
    }

static Future<void> _moveToLogin() async{
    await AuthController.clearUserData();
    Navigator.pushNamedAndRemoveUntil(TaskManager.navigator.currentContext!, LoginScreen.name, (predicate)=> false);
}


}

class ApiResponse {
  final bool isSuccess;
  final int responseCode;
  final dynamic responseData;
  final String? errorMessage;

  ApiResponse(
      {required this.isSuccess,
      required this.responseCode,
      required this.responseData,
      this.errorMessage});
}
