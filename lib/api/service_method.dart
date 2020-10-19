
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
    // print('api url is ' + dio.options.baseUrl);
    print(response);

    // List _jsonList = json.decode(response.data);
    // print('json decode raw response is ${_jsonList[0]}');
    // // print(_jsonCotent[0]);
    // List<Post> postList = _jsonList[0].map((item) => Post.fromJson(item)).toList();
    // print('#####load post list ${postList.length}');



    // var data = json.decode(response.toString());
    // var d =jsonDecode(response.toString());
    // print('get json data: ');
    // print(d['data']['current_page']);
    // print(d['data']['data']);
    return response;
    // dio.options = options;
    // dio.options.contentType = ContentType.parse("application/x-www-form-urlencoded").toString();
    // if(formData == null){
    //   response = await dio.get(service_path[url], options: options);
    // }
  }catch(e){
    print(e);
  }
}