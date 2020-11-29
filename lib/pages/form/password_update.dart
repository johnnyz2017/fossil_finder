import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fossils_finder/config/global_config.dart';
import 'package:fossils_finder/model/user.dart';
import 'package:fossils_finder/utils/qiniu_image_upload.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';


class PasswordUpdatePage extends StatefulWidget {
  final User user;

  const PasswordUpdatePage({Key key, this.user}) : super(key: key);
  
  @override
  _PasswordUpdatePageState createState() => _PasswordUpdatePageState();
}

class _PasswordUpdatePageState extends State<PasswordUpdatePage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _passwordTextController = new TextEditingController();
  TextEditingController _confirmPasswordTextController = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("修改密码"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done),
            onPressed: (){
              if (_formKey.currentState.validate()) {
                _submitPassword(context);
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(children: <Widget>[
              TextFormField(
                controller: _passwordTextController,
                decoration: new InputDecoration(
                  labelText: '新密码',
                ),
                obscureText: true,
                validator: (value){
                  if(value.isEmpty || value.length < 6){
                    return '密码少于6位';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: new InputDecoration(
                  labelText: '确认新密码',
                ),
                obscureText: true,
                validator: (value){
                  if(value.isEmpty || value != _passwordTextController.text){
                    return '密码确认不一致';
                  }
                  return null;
                },
              ),
            ],)
          ),
        ),
      ),
    );
  }

  _submitPassword(BuildContext context) async{

    FormData formData = new FormData.fromMap({
      "password" : _passwordTextController.text
    });

    SharedPreferences localStorage;
    localStorage = await SharedPreferences.getInstance();
    String _token = localStorage.get('token');

    BaseOptions baseOptions = BaseOptions(
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

    Dio dio = new Dio(baseOptions);
    Options options = Options(
        contentType: 'application/json',
        headers: {
          HttpHeaders.authorizationHeader : 'Bearer $_token',
          HttpHeaders.acceptHeader : 'application/json'
        }
    );
    String updateUrl = apiUrl+servicePath['changepw'];
    var respone = await dio.post<String>(updateUrl, data: formData, options: options);
    print(respone);
    if (respone.statusCode == 200) {
      var responseJson = json.decode(respone.data);
      print('response: ${respone.data} - ${responseJson['message']}');

      var status = responseJson['code'] as int;
      if(status == 200){
        Fluttertoast.showToast(
          timeInSecForIosWeb: 2,
          msg: "密码更新成功",
          gravity: ToastGravity.CENTER,
          textColor: Colors.grey);
        
        Navigator.pop(context, true);
      }else{
        Fluttertoast.showToast(
          timeInSecForIosWeb: 2,
          msg: "密码更新失败，请检查网络重试一下！",
          gravity: ToastGravity.CENTER,
          textColor: Colors.red);
      }
    }
  }
}