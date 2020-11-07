
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fossils_finder/model/category.dart';
import 'package:fossils_finder/model/post.dart';
import 'package:fossils_finder/pages/list/category_select.dart';
import 'package:fossils_finder/utils/strings.dart';

class CommentUploadPage extends StatefulWidget {
  final Post post;

  const CommentUploadPage({Key key, this.post}) : super(key: key);
  @override
  _CommentUploadPageState createState() => _CommentUploadPageState();
}

class _CommentUploadPageState extends State<CommentUploadPage> {
  final _formKey = GlobalKey<FormState>();

  int _pid;
  String _title;
  String _content;
  int _categoryId;

  TextEditingController _categoryTextController = new TextEditingController();
  CategoryNode category;

  @override
  void initState() {
    super.initState();
    if(widget.post != null)
      _pid = widget.post.id;
    else
      _pid = -1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("发表评论"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: '标题：',
                ),
                initialValue: "回复： ${widget.post.title}",
                validator: (String value){
                  if(value.isEmpty)
                    return '标题不能为空';
                  return null;

                },
                onSaved: (String value){
                  _title = value;
                },
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: _categoryTextController,
                      decoration: InputDecoration(
                        labelText: "分类： "
                      ),
                      readOnly: true,
                      validator: (value){
                        if(value.isEmpty){
                          return '请选择一个分类';
                        }

                        return null;
                      },
                    ),
                  ),

                  IconButton(
                    iconSize: 20, 
                    icon: Icon(Icons.category), 
                    onPressed: () async {
                      category = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) {
                          return CategorySelector(treeJson: "",);
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

                  
                ],
              ),

              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: '内容：',
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  validator: (String value){
                    if(value.isEmpty)
                      return '内容不能为空';
                    return null;

                  },
                  onSaved: (String value){
                    _content = value;
                  },
                ),
              ),

              

              RaisedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, otherwise false.
                  if (_formKey.currentState.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.

                    Scaffold
                        .of(context)
                        .showSnackBar(SnackBar(content: Text('数据处理中')));
                    
                    _submitPost();
                  }
                },
                child: Text('提交'),
              ),
            ],
          ),
        ),
      ),
    );
  }



  _submitPost() async{

    FormData formData = new FormData.fromMap({
      // "user_id": 1,
      "title" : _title,
      "content" : _content,
      'category_id' : _categoryId
    });

    Dio dio = new Dio();
    Options options = Options(
        contentType: 'application/json',
    );
    var respone = await dio.post<String>("http://localhost:8000/api/v1/posts", data: formData, options: options);
    print(respone);
    if (respone.statusCode == 200) {

      var responseJson = json.decode(respone.data);
      print('response: ${respone.data} - ${responseJson['message']}');

      var status = responseJson['statusCode'] as int;
      if(status == 200){
        Fluttertoast.showToast(
            msg: "提交成功",
            gravity: ToastGravity.CENTER,
            textColor: Colors.grey);
      }else{
        Fluttertoast.showToast(
            msg: "提交失败，暂存在本地数据库中！",
            gravity: ToastGravity.CENTER,
            textColor: Colors.red);
      }
    }
  }
}