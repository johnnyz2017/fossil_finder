
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _themes = <MaterialColor>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.red,
];

class Global{
  static SharedPreferences _prefs;

  // static Profile profile = Profile();
  // static NetCache netCache = NetCache();

  static List<MaterialColor> get themes => _themes;
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  static Future init() async {
    // _prefs = await SharedPreferences.getInstance();
    // var _profile = _prefs.getString("profile");
    // if (_profile != null) {
    //   try {
    //     profile = Profile.fromJson(jsonDecode(_profile));
    //   } catch (e) {
    //     print(e);
    //   }
    // }

    // // 如果没有缓存策略，设置默认缓存策略
    // profile.cache = profile.cache ?? CacheConfig()
    //   ..enable = true
    //   ..maxAge = 3600
    //   ..maxCount = 100;

    // //初始化网络请求相关配置
    // Git.init();
  }

  // static saveProfile() =>
  //     _prefs.setString("profile", jsonEncode(profile.toJson()));
}

const String serviceUrl = 'http://localhost:8000';
// const String serviceUrl = 'http://foss-backend.herokuapp.com';
const String apiUrl = serviceUrl + '/api/v1';
const servicePath = {
  'posts' : '/posts',
  'categorieswithposts' : '/categories/allwithposts',
  'categorieswithoutposts' : '/categories/allwithoutposts'
};

const httpHeaders = {
  'Accept' : 'application/json, text/plain, */*',
  'Accept-Encoding' : 'gzpi, deflate, br',
  'Connection' : 'keep-alive',
  'Content-Type' : 'application/json'
};


const String TABLE_NAME_PBSETTING = 'pb_setting';
const String TABLE_NAME_UPLOADED = 'uploaded';