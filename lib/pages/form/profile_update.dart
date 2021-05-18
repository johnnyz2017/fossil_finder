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


class MemberProfileUpdatePage extends StatefulWidget {
  final User user;

  const MemberProfileUpdatePage({Key key, this.user}) : super(key: key);
  
  @override
  _MemberProfileUpdatePageState createState() => _MemberProfileUpdatePageState();
}

class _MemberProfileUpdatePageState extends State<MemberProfileUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  String _imgPath;

  TextEditingController _nameTextController = new TextEditingController();
  TextEditingController _descriptionTextController = new TextEditingController();

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    _doUploadImage(image, "");//上传图片
  }

  _doUploadImage(File file, String renameImage) async {
    // 读取配置
    try {
      String suffix = path.extension(file.path);
      String filename = path.basenameWithoutExtension(file.path);
      String _renameImage = '$filename$suffix';
      
      var uploader = QiniuImageUpload();
      var uploadedItem = await uploader.upload(file, _renameImage);
      if (uploadedItem != null) {
        print('upload success ....');
        setState(() {
          // _image = Image.network(uploadedItem.path, height: 200,); //OK
          _imgPath = uploadedItem.path;
        });
        // _view.uploadSuccess(uploadedItem.path);
      } else {
        print('failed to upload ...');
      }
    } on DioError catch (e) {
      debugPrint(e.toString());
      print('dio error ${e.message}');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _imgPath = widget.user.avatar;
    _nameTextController.text = widget.user.name;
    _descriptionTextController.text = widget.user.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("个人设置"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done),
            onPressed: (){
              if (_formKey.currentState.validate()) {
                _submitProfile(context);
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
              InkWell(
                onTap: ()async{
                  getImage();
                },
                child: CachedNetworkImage(
                  height: 200,
                  imageUrl: _imgPath,
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              // Row(children: <Widget>[
              //   Expanded(
              //     child: CachedNetworkImage(
              //       height: 200,
              //       imageUrl: _imgPath,
              //       placeholder: (context, url) => Center(child: CircularProgressIndicator()),
              //       errorWidget: (context, url, error) => Icon(Icons.error),
              //     ),
              //   ),
              //   IconButton(
              //     icon: Icon(Icons.picture_in_picture),
              //     onPressed: (){
              //       getImage();
              //     },
              //   )
              // ],),
              TextFormField(
                controller: _nameTextController,
                decoration: new InputDecoration(
                  labelText: '名字',
                ),
                validator: (value){
                  if(value.isEmpty || value.length < 3){
                    return '名字不能少于一个字符';
                  }

                  return null;
                },
                // initialValue: widget.user.name,
              ),
              TextFormField(
                controller: _descriptionTextController,
                decoration: new InputDecoration(
                  labelText: '个人描述',
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
              ),
            ],)
          ),
        ),
      ),
    );
  }

  _submitProfile(BuildContext context) async{

    FormData formData = new FormData.fromMap({
      "name" : _nameTextController.text,
      "profile_image" : _imgPath,
      "description" : _descriptionTextController.text,
    });

    print('submit profile description ${_descriptionTextController.text}');

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
    String updateUrl = apiUrl+servicePath['users']+'/${widget.user.id}';
    var respone = await dio.post<String>(updateUrl, data: formData, options: options);
    print(respone);
    if (respone.statusCode == 200) {
      var responseJson = json.decode(respone.data);
      print('response: ${respone.data} - ${responseJson['message']}');

      var status = responseJson['code'] as int;
      if(status == 200){
        Fluttertoast.showToast(
          timeInSecForIosWeb: 2,
          msg: "个人设置更新成功",
          gravity: ToastGravity.CENTER,
          textColor: Colors.grey);
        
        Navigator.pop(context, true);
      }else{
        Fluttertoast.showToast(
          timeInSecForIosWeb: 2,
          msg: "更新失败，请检查网络重试一下！",
          gravity: ToastGravity.CENTER,
          textColor: Colors.red);
      }
    }
  }
}