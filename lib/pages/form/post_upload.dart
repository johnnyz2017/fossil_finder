import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fossils_finder/config/global_config.dart';
import 'package:fossils_finder/model/category.dart';
import 'package:fossils_finder/model/post.dart';
import 'package:fossils_finder/pages/list/category_select.dart';
import 'package:fossils_finder/utils/db_helper.dart';
import 'package:fossils_finder/utils/image_upload.dart';
import 'package:fossils_finder/utils/qiniu_image_upload.dart';
import 'package:fossils_finder/utils/strings.dart';
import 'package:image_picker/image_picker.dart';

import 'package:amap_map_fluttify/amap_map_fluttify.dart';

import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class PostUploadPage extends StatefulWidget {
  final LatLng center;

  const PostUploadPage({Key key, this.center}) : super(key: key);
  @override
  _PostUploadPageState createState() => _PostUploadPageState();
}

class _PostUploadPageState extends State<PostUploadPage> {

  DatabaseHelper dbhelper = DatabaseHelper();
  final _formKey = GlobalKey<FormState>();
  // File _image;
  Image _image;
  List<String> _imgsPath = [];
  CategoryNode category;
  int _category = -1;
  bool _private = true;

  TextEditingController _latTextController = new TextEditingController();
  TextEditingController _lngTextController = new TextEditingController();
  TextEditingController _altTextController = new TextEditingController();
  TextEditingController _addrTextController = new TextEditingController();
  TextEditingController _titleTextController = new TextEditingController();
  TextEditingController _contentTextController = new TextEditingController();
  TextEditingController _categoryTextController = new TextEditingController();

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    _doUploadImage(image, "");//上传图片
  }

  @override
  void initState() {
    super.initState();
    // final Future<Database> dbFuture = dbhelper.initializeDatabase();
    // dbFuture.then((db){
    //   print('after db init');
    //   Future<List<Post>> postListFuture = dbhelper.getPostList();
    //   postListFuture.then((noteList) {
    //     print('get post list ${noteList.length} ');
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    print('center got : ${widget.center.latitude}, ${widget.center.longitude}');
    return Scaffold(
      appBar: AppBar(
        title: Text('发布页面'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: (){
                _savePost();
            },
          ),
          IconButton(
            icon: Icon(Icons.done),
            onPressed: (){
              if (_formKey.currentState.validate()) {
                _submitPost(context);
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
                child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                
                Container(
                  height: 150,
                  child: Expanded(
                    child: _imgsPath.length > 0 ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index){
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          // child: Image.network(_imgsPath[index],),
                          child: CachedNetworkImage(
                            // height: 150,
                            // width: 150,
                            imageUrl: _imgsPath[index],
                            placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                            // progressIndicatorBuilder: (context, url, downloadProgress) => 
                            // CircularProgressIndicator(value: downloadProgress.progress),
                          ),
                        );
                      },
                      itemCount: _imgsPath.length,
                    ) : Center(child: Text("未上传图片")),
                   
                    ),
                ),
                RaisedButton(
                  child: Text('选择图片上传'),
                  onPressed: (){
                    getImage();
                  },
                ),

                Row(
                  children: <Widget>[
                    Text('标题: '),
                    Expanded(child: TextFormField(
                      controller: _titleTextController,
                      validator: (value){
                          if(value.isEmpty){
                            return '标题没有填写';
                          }

                          return null;
                        },
                      ))
                  ],
                ),

                Row(
                  children: <Widget>[
                    Text('描述: '),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        controller: _contentTextController,
                        validator: (value){
                          if(value.isEmpty){
                            return '描述内容没有填写';
                          }

                          return null;
                        },
                        ),
                    )
                  ],
                ),
             
                Divider(),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('经度: '),
                    Expanded(child: TextFormField(
                      inputFormatters: [
                        WhitelistingTextInputFormatter(RegExp("[.,0-9]"))
                      ],
                      controller: _lngTextController,
                      validator: (value){
                          if(value.isEmpty){
                            return '经度没有填写';
                          }
                          return null;
                        },
                      )),
                    Text('纬度: '),
                    Expanded(child: TextFormField(
                      inputFormatters: [
                        WhitelistingTextInputFormatter(RegExp("[.,0-9]"))
                      ],
                      controller: _latTextController,
                      validator: (value){
                          if(value.isEmpty){
                            return '纬度没有填写';
                          }
                          return null;
                        },
                    )),
                    IconButton(
                      iconSize: 20, 
                      icon: Icon(Icons.my_location), 
                      onPressed: () async { 
                        //AmapService.navigateDrive(LatLng(36.547901, 104.258354));
                        setState(() {
                          _latTextController.text = widget.center.latitude.toStringAsFixed(6);
                          _lngTextController.text = widget.center.longitude.toStringAsFixed(6);
                        });
                      },
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('海拔: '),
                    Expanded(child: TextFormField(
                      inputFormatters: [
                        WhitelistingTextInputFormatter(RegExp("[.,0-9]"))
                      ],
                      //WhitelistingTextInputFormatter(RegExp("[a-z,A-Z,0-9]"))
                      controller: _altTextController,
                      validator: (value){
                          if(value.isEmpty){
                            return '海拔没有填写';
                          }
                          return null;
                        },
                      ),)
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('地址: '),
                    Expanded(child: TextFormField(
                      controller: _addrTextController,
                      validator: (value){
                        if(value.isEmpty){
                          return '地址没有填写';
                        }
                        return null;
                      },
                    ),)
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('分类: '),
                    Expanded(
                      child: TextFormField(
                        controller: _categoryTextController,
                        readOnly: true,
                        // validator: (value){
                        //   if(value.isEmpty){
                        //     return '请选择一个分类';
                        //   }
                        //   return null;
                        // },
                        onTap: () async{
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
                              _category = int.parse(_key.split('_')[1]);
                              print('got category id ${_category}');
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),

                Row(
                  children: <Widget>[
                    Text('是否私有：'),
                    Switch(
                      value: _private, 
                      onChanged: (value){
                        // _private = value;
                        setState(() {
                          _private = value;
                        });
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _savePost() async{
    String _images = list2String(_imgsPath, ',');
    print('get images path string: ${_images}');

    Post post = new Post.fromMapObject({
      "user_id" : null,
      "auth_user_id" : null,
      "temp_id" : "",
      "perm_id" : "",
      "title" : _titleTextController.text,
      "images" : _images,
      "content" : _contentTextController.text,
      "private" : _private ? 1 : 0,
      "published" : 0,
      "category_id" : null,
      "final_category_id" : null,
      "final_category_id_from" : null,
      "coordinate_latitude" : double.parse(_latTextController.text),
      "coordinate_longitude" : double.parse(_lngTextController.text),
      "coordinate_altitude" : double.parse(_altTextController.text),
      "address" : _addrTextController.text,
      "created_at" : null,
      "updated_at" : null,
      "author" : 'test author' //TBD get from local
    });

    var ret =  await dbhelper.insertPost(post);
    print('#### after insert post into local database - result: ${ret}');

    if(ret > 0){
      Fluttertoast.showToast(
          msg: "本地保存成功",
          gravity: ToastGravity.CENTER,
          textColor: Colors.grey);
      
      Navigator.pop(context, true);
    }else{
      Fluttertoast.showToast(
          msg: "本地保存失败，请检查表单各属性，程序权限授予等。",
          gravity: ToastGravity.CENTER,
          textColor: Colors.red);
    }
  }

  _submitPost(BuildContext context) async{
    
    String _images = list2String(_imgsPath, ',');
    print('get images path string: ${_images}');

    FormData formData = new FormData.fromMap({
      "images" : _images,
      "title" : _titleTextController.text,
      "content" : _contentTextController.text,
      "coordinate_latitude" : double.parse(_latTextController.text),
      "coordinate_longitude" : double.parse(_lngTextController.text),
      "coordinate_altitude" : double.parse(_altTextController.text),
      "address" : _addrTextController.text,
      'category_id' : _category,
      'private' : _private ? 1 : 0
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
        HttpHeaders.authorizationHeader : 'Bearer $_token'
      }
    );

    Dio dio = new Dio(baseOptions);
    Options options = Options(
        contentType: 'application/json',
        headers: {
          HttpHeaders.authorizationHeader : 'Bearer $_token'
        }
    );
    var respone = await dio.post<String>(servicePath['posts'], data: formData, options: options);
    print(respone);
    if (respone.statusCode == 200) {
      var responseJson = json.decode(respone.data);
      print('response: ${respone.data} - ${responseJson['message']}');

      var status = responseJson['code'] as int;
      if(status == 200){
        Fluttertoast.showToast(
            timeInSecForIosWeb: 5,
            msg: "提交成功",
            gravity: ToastGravity.CENTER,
            textColor: Colors.grey);
        Navigator.pop(context, true);
      }else{
        Fluttertoast.showToast(
            msg: "提交失败，请暂存在本地数据库中！",
            gravity: ToastGravity.CENTER,
            textColor: Colors.red);
      }
    }
  }

  _upLoadImage(File image) async {
    String path = image.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    var suffix = name.substring(name.lastIndexOf(".") + 1, name.length);
    FormData formData = new FormData.fromMap({
      "userId": "1",
      // "image": new UploadFileInfo(new File(path), name,
      //     contentType: ContentType.parse("image/$suffix"))
      "image": await MultipartFile.fromFile(path, filename: name),
    });

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
      // headers: {
      //   HttpHeaders.authorizationHeader : 'Bearer $_token'
      // }
    );
    Dio dio = new Dio(baseOptions);
    Options options = Options(
        contentType: 'application/json',
    );
    var respone = await dio.post<String>(servicePath['posts'], data: formData, options: options);
    print(respone);
    if (respone.statusCode == 200) {

      var responseJson = json.decode(respone.data);
      print('response: ${respone.data} - ${responseJson['statusCode']}');

      var status = responseJson['code'] as int;
      if(status == 200){
        Fluttertoast.showToast(
            msg: "图片上传成功",
            gravity: ToastGravity.CENTER,
            textColor: Colors.grey);
      }else{
        Fluttertoast.showToast(
            msg: "图片上传失败！",
            gravity: ToastGravity.CENTER,
            textColor: Colors.red);
      }
    }
  }
  


  /// 根据配置上传图片
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
          _imgsPath.add(uploadedItem.path);
        });
        // _view.uploadSuccess(uploadedItem.path);
      } else {
        print('failed to upload ...');
        // _view.uploadFaild('上传失败！请重试');
      }
    } on DioError catch (e) {
      debugPrint(e.toString());
      print('dio error ${e.message}');
      // _view.uploadFaild('${e.message}');
    } catch (e) {
      debugPrint(e.toString());
      // _view.uploadFaild('$e');
    }
  }
}