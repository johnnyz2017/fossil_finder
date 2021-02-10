import 'dart:convert';
import 'dart:io';
import 'dart:io';
import 'dart:io';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fossils_finder/api/service_method.dart';
import 'package:fossils_finder/config/global_config.dart';
import 'package:fossils_finder/model/category.dart';
import 'package:fossils_finder/pages/list/category_select.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryUpdatePage extends StatefulWidget {
  final CategoryNode categoryNode;

  const CategoryUpdatePage({Key key, this.categoryNode}) : super(key: key);
  @override
  _CategoryUpdatePageState createState() => _CategoryUpdatePageState();
}

class _CategoryUpdatePageState extends State<CategoryUpdatePage> {
  final _formKey = GlobalKey<FormState>();

  int _categoryId;

  TextEditingController _categoryTextController = new TextEditingController();
  TextEditingController _titleTextController = new TextEditingController();
  TextEditingController _contentTextController = new TextEditingController();

  CategoryNode parentCategory;

  CategoryItem categoryItem;

  Future loadPostFromServer() async{
    var _content = await request('${serviceUrl}/api/v1/categories/${widget.categoryNode.id}');
    var _jsonData = jsonDecode(_content.toString());
    print('get json data is  ${_jsonData}');
    var _categoryJson = _jsonData['data'];
    CategoryItem _category = CategoryItem.fromJson(_categoryJson);

    var _pContent = await request('${serviceUrl}/api/v1/categories/${_category.parentId}');
    var _pJsonData = jsonDecode(_pContent.toString());
    print('get json data is  ${_pJsonData}');
    var _pCategoryJson = _pJsonData['data'];
    CategoryItem _pCategory = CategoryItem.fromJson(_pCategoryJson);

    setState(() {
      categoryItem = _category;
      _titleTextController.text = categoryItem.title;
      _contentTextController.text = categoryItem.description;
      _categoryTextController.text = _pCategory.title;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadPostFromServer();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("发表鉴定"),
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
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _titleTextController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: '鉴定标题：',
                ),
                validator: (String value){
                  if(value.isEmpty)
                    return '标题不能为空';
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
                        labelText: "父类别："
                      ),
                      readOnly: true,
                      onTap: ()async{
                        parentCategory = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) {
                            return CategorySelector(treeJson: "", editable: false, sid: widget.categoryNode.id,);
                          }) 
                        );

                        if(parentCategory != null){
                          print('result: ${parentCategory.key} - ${parentCategory.label}');
                          _categoryTextController.text = parentCategory.label;
                          
                          String _key = parentCategory.key;
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

              Expanded(
                child: TextFormField(
                  controller: _contentTextController,
                  decoration: InputDecoration(
                    labelText: '鉴定描述：',
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
              ),
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

    FormData formData = new FormData.fromMap({
      "title" : _titleTextController.text ?? "",
      "content" : _contentTextController.text ?? "",
      'parent_id' : _categoryId,
      'id' : categoryItem.id
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

    var respone = await dio.post<String>(servicePath['categories'] + '/${categoryItem.id}', data: formData, options: options);
    print(respone);
    if (respone.statusCode == 200) {

      var responseJson = json.decode(respone.data);
      print('response: ${respone.data} - ${responseJson['message']}');

      var status = responseJson['code'] as int;
      if(status == 200){
        Fluttertoast.showToast(
            msg: "提交成功",
            gravity: ToastGravity.CENTER,
            textColor: Colors.grey);

        Navigator.pop(context, true);
      }else{
        Fluttertoast.showToast(
            msg: "提交失败！",
            gravity: ToastGravity.CENTER,
            textColor: Colors.red);

        Navigator.pop(context, false);
      }
    }
  }
}