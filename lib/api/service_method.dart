
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:fossils_finder/config/global_config.dart';
import 'package:fossils_finder/model/post.dart';

Future request(url, {formData}) async{
  try{
    print('start to request data');
    BaseOptions options = BaseOptions(
      baseUrl: apiUrl,
      responseType: ResponseType.plain,
      connectTimeout: 30000,
      receiveTimeout: 30000,
      validateStatus: (code) {
        if (code >= 200) {
          return true;
        }
      }
    );
    Response response;
    Dio dio = new Dio(options);
    Options ops = Options(
      contentType: 'application/json',
    );
    // print('api url is ' + dio.options.baseUrl);
    // print('url is ' + url);
    response = await dio.get(url, options: ops);
    // print('get response : ${response}');
    return response;
    // dio.options = options;
    // dio.options.contentType = ContentType.parse("application/x-www-form-urlencoded").toString();
    // if(formData == null){
    //   response = await dio.get(service_path[url], options: options);
    // }
  }catch(e){
    // print('ERRRRRRRROR  ########################################');
    print(e);
    return null;
  }
}