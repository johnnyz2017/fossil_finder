import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fossils_finder/config/global_config.dart';
import 'package:fossils_finder/model/category.dart';
import 'package:fossils_finder/pages/list/category_select.dart';
import 'package:fossils_finder/widgets/helper_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryNewPage extends StatefulWidget {
  @override
  _CategoryNewPageState createState() => _CategoryNewPageState();
}

class _CategoryNewPageState extends State<CategoryNewPage> {
  final _formKey = GlobalKey<FormState>();

  int _categoryId;

  TextEditingController _categoryTextController = new TextEditingController();
  TextEditingController _titleTextController = new TextEditingController();
  TextEditingController _contentTextController = new TextEditingController();
  bool _isGenus = false;

  CategoryNode category;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("编辑分类单元"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done),
            onPressed: (){
              if (_formKey.currentState.validate()) {
                    _submitCategory(context);
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(DMARGIN),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _titleTextController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: '分类单元名称：',
                ),
                validator: (String value){
                  if(value.isEmpty)
                    return '名称不能为空';
                  return null;

                },
                autovalidate: true,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: _categoryTextController,
                      decoration: InputDecoration(
                        labelText: "父级分类单元："
                      ),
                      readOnly: true,
                      onTap: ()async{
                        category = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) {
                            return CategorySelector(treeJson: "", editable: false,);
                          }) 
                        );

                        if(category != null){
                          print('result: ${category.key} - ${category.label}');
                          _categoryTextController.text = category.label;
                          
                          String _key = category.key;
                          String _type = _key.split('_')[0];
                          if(_type.isNotEmpty || _type == "c"){
                            _categoryId = int.parse(_key.split('_')[1]);
                            print('got category id ${_categoryId}');
                          }
                        }      
                      },
                    ),
                  ),
                ],
              ),

              Row(
                children: <Widget>[
                  Text('属级/种级：'),
                  Theme(
                    data: ThemeData(
                      primaryColor: Colors.blueAccent
                    ),
                    child: Switch(
                      value: _isGenus, 
                      onChanged: (value){
                        setState(() {
                          _isGenus = value;
                        });
                      },
                    ),
                  )
                ],
              ),

              Expanded(
                child: TextFormField(
                  controller: _contentTextController,
                  decoration: InputDecoration(
                    labelText: '分类单元评注：',
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
              ),
              // TextFormField(
              //   controller: _contentTextController,
              //   decoration: InputDecoration(
              //     labelText: '分类描述：',
              //   ),
              //   keyboardType: TextInputType.multiline,
              //   maxLines: null,
              // ),

              // Expanded(
              //   child: Row(
              //       children: <Widget>[
              //         Text('是否私有：'),
              //         Switch(
              //           value: false, 
              //           onChanged: (value){
              //             // _private = value;
              //             setState(() {
              //               // _private = value;
              //             });
              //           },
              //         )
              //       ],
              //     ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  _submitCategory(BuildContext context) async{

    print('title ${_titleTextController.text}');
    print('content ${_contentTextController.text}');
    print('category_id ${_categoryId}');
    print('is_genus ${_isGenus}');

    FormData formData = new FormData.fromMap({
      "title" : _titleTextController.text ?? "",
      "content" : _contentTextController.text ?? "",
      'parent_id' : _categoryId,
      'is_genus' : _isGenus ? 1 : 0
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
        return false;
      },
      headers: {
        HttpHeaders.authorizationHeader : 'Bearer $_token'
      }
    );

    Dio dio = new Dio(baseOptions);
    Options options = Options(
        contentType: 'application/json',
        followRedirects: false,
        validateStatus: (status) { return status < 500; },
        headers: {
          HttpHeaders.authorizationHeader : 'Bearer $_token'
        }
    );

    print('comments: ${servicePath['comments']}');
    var respone = await dio.post<String>(servicePath['categories'], data: formData, options: options);
    print(respone);
    if (respone.statusCode == 200) {

      var responseJson = json.decode(respone.data);
      print('response: ${respone.data} - ${responseJson['message']}');

      var status = responseJson['code'] as int;
      if(status == 200){
        // Fluttertoast.showToast(
        //     msg: "提交成功",
        //     gravity: ToastGravity.CENTER,
        //     textColor: Colors.grey);
        successToast("提交成功");

        Navigator.pop(context, true);
      }else{
        // Fluttertoast.showToast(
        //     msg: "提交失败！",
        //     gravity: ToastGravity.CENTER,
        //     textColor: Colors.red);
        // errorToast("提交失败");
        errorToast(responseJson['message']);

        // Navigator.pop(context, false);
      }
    }
  }
}