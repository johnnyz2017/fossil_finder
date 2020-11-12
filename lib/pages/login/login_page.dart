import 'dart:convert';
import 'dart:io';
import 'package:fossils_finder/config/global_config.dart';
import 'package:fossils_finder/pages/index_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:fossils_finder/pages/home/home_page.dart';

const users = const {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
  'test@163.com': '111111'
};

SharedPreferences localStorage;

class LoginScreen extends StatelessWidget {

  static Future init() async{
    localStorage = await SharedPreferences.getInstance();
  }

  // static var uri = "http://localhost:8000/api/v1";
  // static var uri = "http://foss-backend.herokuapp.com/api/v1";
  // static var uri = "http://42.192.48.39:8080/api/v1";
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

  save(String _token) async{
    await init();
    localStorage.setString("token", _token);
  }

  Future<String> _login(LoginData data) async{
    print('Name: ${data.name}, Password: ${data.password}');

    try {
      Options options = Options(
        // contentType: ContentType.parse('application/json'),
        contentType: 'application/json',
      );
      Response response = await dio.post('/login',
          data: {"email": data.name, "password": data.password}, options: options);
      
      print("status code == ${response.statusCode}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseJson = json.decode(response.data);
        print('response: ${response.data} - ${responseJson['statusCode']}');

        var status = responseJson['statusCode'] as int;
        if(status == 200){
          print("status == 200");
          String _token = responseJson['token'];
          print('get token : ${_token}');
          await save(_token);
          return null;
        }else{
          print("status != 200");
          return 'Username or Password wrong';
        }
      } else if (response.statusCode == 401) {
        // throw Exception("Incorrect Email/Password");
        return 'Incorrect Email/Password';
      } else
        // throw Exception('Authentication Error');
        return 'Authentication Error';
    } on DioError catch (exception) {
      // if (exception == null ||
      //     exception.toString().contains('SocketException')) {
      //   throw Exception("Network Error");
      // } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
      //     exception.type == DioErrorType.CONNECT_TIMEOUT) {
      //   throw Exception(
      //       "Could'nt connect, please ensure you have a stable network.");
      // } else {
      //   return null;
      // }

      return 'Network IO Error!';
    }
  }

  Future<String> _register(LoginData data) async{
    print('Name: ${data.name}, Password: ${data.password}');
    
    try {
      Options options = Options(
        // contentType: ContentType.parse('application/json'),
        contentType: 'application/json',
      );
      Response response = await dio.post('/register',
          data: {"email": data.name, "password": data.password, "name": "undefined"}, options: options);
      
      print("status code == ${response.statusCode}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseJson = json.decode(response.data);
        print('response: ${response.data} - ${responseJson['statusCode']}');

        var status = responseJson['statusCode'] as int;
        if(status == 200){
          print("status == 200");
          return null;
        }else{
          print("status != 200");
          return 'Failed to register';
        }
      } else if (response.statusCode == 401) {
        // throw Exception("Incorrect Email/Password");
        return 'Failed to register 401';
      } else
        // throw Exception('Authentication Error');
        return 'Authentication Error';
    } on DioError catch (exception) {
      // if (exception == null ||
      //     exception.toString().contains('SocketException')) {
      //   throw Exception("Network Error");
      // } else if (exception.type == DioErrorType.RECEIVE_TIMEOUT ||
      //     exception.type == DioErrorType.CONNECT_TIMEOUT) {
      //   throw Exception(
      //       "Could'nt connect, please ensure you have a stable network.");
      // } else {
      //   return null;
      // }

      return 'Network IO Error!';
    }
  }

  Future<String> _authUser(LoginData data) {
    print('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(data.name)) {
        return 'Username not exists';
      }
      if (users[data.name] != data.password) {
        return 'Password does not match';
      }
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    print('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'Username not exists';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Fossil Finder',
      logo: 'images/icons/fossil_icon_512.png',
      onLogin: _login,
      // onLogin: _authUser, //test
      onSignup: _register,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          // builder: (context) => HomePage(),
          builder: (context) => IndexPage(),
        ));
        print("submit and need to navigate to other page");
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}