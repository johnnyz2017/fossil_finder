import 'dart:convert';
import 'package:fossils_finder/config/global_config.dart';
import 'package:fossils_finder/pages/index_page.dart';
import 'package:fossils_finder/utils/local_info_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

SharedPreferences localStorage;

class LoginScreen extends StatelessWidget {

  static Future init() async{
    localStorage = await SharedPreferences.getInstance();
  }

  static var uri = apiUrl;
  static BaseOptions options = BaseOptions(
      baseUrl: uri,
      responseType: ResponseType.plain,
      connectTimeout: 30000,
      receiveTimeout: 30000,
      validateStatus: (code) {
        if (code >= 200) {
          return true;
        }
      });
  static Dio dio = Dio(options);

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String> _login(LoginData data) async{
    print('Name: ${data.email}, Password: ${data.password}');

    try {
      Options options = Options(
        contentType: 'application/json',
      );
      Response response = await dio.post('/login',
          data: {"email": data.email, "password": data.password}, options: options);
      
      print("status code == ${response.statusCode}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseJson = json.decode(response.data);
        // print('response: ${response.data} - ${responseJson['statusCode']}');

        var status = responseJson['statusCode'] as int;
        if(status == 200){
          String _token = responseJson['token'];
          await setToken(_token);
          int userId = responseJson['user']['id'];
          await setUserId(userId);
          int i = await getUserId();
          print('get user id from local storage ${i}');
          return null;
        }else{
          print("status != 200");
          return 'Username or Password wrong';
        }
      } else if (response.statusCode == 401) {
        return 'Incorrect Email/Password';
      } else
        return 'Authentication Error';
    } on DioError catch (exception) {
      print('DIO error: ${exception.toString()}');

      if (exception == null ||
          exception.toString().contains('SocketException')) {
        // throw Exception("Network Error");
        return 'Network Error';
      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
          exception.type == DioErrorType.CONNECT_TIMEOUT) {
        // throw Exception(
        //     "Could'nt connect, please ensure you have a stable network.");
        return 'Could not connect, please ensure you have a stable network.';
      } else {
        return 'Network IO Error!';
      }
    }
  }

  Future<String> _register(LoginData data) async{
    print('Email: ${data.email}, UserName: ${data.username}, Password: ${data.password}');
    
    try {
      Options options = Options(
        contentType: 'application/json',
      );
      Response response = await dio.post('/register',
          data: {"email": data.email, "password": data.password, "name": data.username}, options: options);
      
      print("status code == ${response.statusCode}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseJson = json.decode(response.data);
        print('response: ${response.data} - ${responseJson['statusCode']}');

        var status = responseJson['statusCode'] as int;
        if(status == 200){
          print("status == 200");
          String _token = responseJson['token'];
          await setToken(_token);
          int userId = responseJson['data']['id'];
          await setUserId(userId);
          int i = await getUserId();
          print('get user id from local storage ${i}');
          return null;
        }else{
          print("status != 200");
          return '注册失败';
        }
      } else if (response.statusCode == 401) {
        return '注册失败，请检查网络';
      } else
        return 'Authentication Error';
    } on DioError catch (exception) {
      print('DIO error: ${exception.toString()}');

      if (exception == null ||
          exception.toString().contains('SocketException')) {
        return 'Network Error';
      } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
          exception.type == DioErrorType.CONNECT_TIMEOUT) {
        return 'Could not connect, please ensure you have a stable network.';
      } else {
        return 'Network IO Error!';
      }
    }
  }

  Future<String> _recoverPassword(String name) {
    print('Name: $name');
    return Future.delayed(loginTime).then((_) {
      print('TBD - recover password');
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.grey[500],
        accentColor: Colors.grey[100]
      ),
      child: FlutterLogin(
        title: 'Fossil Hunter',
        logo: 'images/icons/fossil_icon_512.png',
        onLogin: _login,
        onSignup: _register,
        onSubmitAnimationCompleted: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => IndexPage(),
          ));
        },
        onRecoverPassword: _recoverPassword,
      ),
    );
  }
}