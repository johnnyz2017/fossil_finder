import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fossils_finder/config/global_config.dart';
import 'package:fossils_finder/utils/local_info_utils.dart';
import 'package:fossils_finder/widgets/helper_widgets.dart';

Future<Response> request(url, {formData}) async{
  try{
    print('start to request data from ${url}');
    String _token = await getToken();

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
    return response;
  }catch(e){
    print(e);
    // Fluttertoast.showToast(
    //   msg: "网络获取失败，请检查网络和服务器状态",
    //   gravity: ToastGravity.CENTER,
    //   textColor: Colors.red
    // );
    errorToast("网络获取失败，请检查网络和服务器状态");
    return null;
  }
}