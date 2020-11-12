import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fossils_finder/config/global_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Response> request(url, {formData}) async{
  try{
    print('start to request data');
    
    SharedPreferences localStorage;
    localStorage = await SharedPreferences.getInstance();
    String _token = localStorage.get('token');

    BaseOptions options = BaseOptions(
      baseUrl: apiUrl,
      responseType: ResponseType.json,
      connectTimeout: 30000,
      receiveTimeout: 30000,
      validateStatus: (code) {
        if (code >= 200) {
          return true;
        }
      },
      headers: {
        HttpHeaders.authorizationHeader : 'Bearer $_token',
        HttpHeaders.acceptHeader : 'application/json'
      }
    );
    Response response;
    Dio dio = new Dio(options);
    Options ops = Options(
      contentType: 'application/json',
    );
    response = await dio.get(url, options: ops);
    // print('#### get response status code:  ${response.data}');
    return response;
  }catch(e){
    print(e);
    return null;
  }
}