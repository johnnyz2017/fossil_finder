import 'dart:convert';

import 'package:fossils_finder/api/service_method.dart';
import 'package:fossils_finder/config/global_config.dart';


class PostService{
  static getPost() async{
    await request(servicePath['posts']).then((value){
      // var data = json.decode(value.toString()); //wrong
      var data = jsonDecode(value.toString());
      print('get posts: ${data}');
    });
  }
}