import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fossils_finder/main_app.dart';
import 'package:fossils_finder/pages/home/home_page.dart';
import 'package:fossils_finder/pages/index_page.dart';
import 'package:fossils_finder/pages/login/login_page.dart';
import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:fossils_finder/utils/db_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'api/service_method.dart';
import 'config/global_config.dart';

SharedPreferences localStorage;

void MapInit() async{
  final provider = DbProvider();
  await provider.init();
  
  // localStorage = await SharedPreferences.getInstance();
  // String _token = localStorage.get('token');
  // print('token is ${_token}');

  await enableFluttifyLog(false);
  await AmapService.init(
    iosKey: '442bcb9df9178d4e0e1d30370c485907',
    androidKey: 'cf2c5badb6669ff95b26030d9e77f490',
  );
}

void main(){
  runApp(
    FossilApp()
  );
  MapInit();
}

class FossilApp extends StatefulWidget {

  @override
  _FossilAppState createState() => _FossilAppState();
}

class _FossilAppState extends State<FossilApp> {

  bool isLoggedIn = false;

  void init() async{
    localStorage = await SharedPreferences.getInstance();
    String _token = localStorage.get('token');
    // print('token is ${_token}');
    if(_token != null && !(_token.isEmpty)){
      var _content = await request(servicePath['testauth']);
      if(_content.statusCode != 200){
        if(_content.statusCode == 401){
          print('#### unauthenticated, need back to login page ${_content.statusCode}');
        }
        print('#### Network Connection Failed: ${_content.statusCode}');
        return;
      }

      setState(() {
        isLoggedIn = true;
      });      
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Fossil Finder",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo, accentColor: Colors.blue),
      home: isLoggedIn ? IndexPage() : LoginScreen(),
      // home: IndexPage(),
    );
  }
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Fossil Finder",
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(primarySwatch: Colors.indigo, accentColor: Colors.blue),
      home: LoginScreen(),
    );
  }
}