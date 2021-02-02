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

import 'package:http/http.dart' as http;

class PostUploadPage extends StatefulWidget {
  final LatLng center;

  const PostUploadPage({Key key, this.center}) : super(key: key);
  @override
  _PostUploadPageState createState() => _PostUploadPageState();
}

class _PostUploadPageState extends State<PostUploadPage> {

  DatabaseHelper dbhelper = DatabaseHelper();
  final _formKey = GlobalKey<FormState>();
  Image _image;
  List<String> _imgsPath = [];
  List<File> _imgsFile = [];
  List<bool> _imgsUploaded = [];
  Map<String, String> _uploadedPath = new Map();
  Map<String, bool> _uploadedStatus = new Map();
  Map<String, bool> _uploadingStatus = new Map();
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

  List statesList;
  String _myState;

  String stateInfoUrl = 'http://cleanions.bestweb.my/api/location/get_state';
  Future<String> _getStateList() async {
    await http.post(stateInfoUrl, headers: {
      'Content-Type': 'application/x-www-form-urlencoded'
    }, body: {
      "api_key": '25d55ad283aa400af464c76d713c07ad',
    }).then((response) {
      var data = json.decode(response.body);

     print(data);
      setState(() {
        statesList = data['state'];
      });
    });
  }

  // Get State information by API
  List citiesList;
  String _myCity;

  String cityInfoUrl =
      'http://cleanions.bestweb.my/api/location/get_city_by_state_id';
  Future<String> _getCitiesList() async {
    await http.post(cityInfoUrl, headers: {
      'Content-Type': 'application/x-www-form-urlencoded'
    }, body: {
      "api_key": '25d55ad283aa400af464c76d713c07ad',
      "state_id": _myState,
    }).then((response) {
      var data = json.decode(response.body);
      print('cities: ${data}');
      setState(() {
        citiesList = data['cities'];
      });
    });
  }

  Future _getStateListFromJson() async{
    // PostService.getPost();
    String _content = await rootBundle.loadString('assets/data/system_series_stage_table.json');
    print('get states from json  ${_content}');
    var _jsonContent = json.decode(_content);
    // print("after json decode list size is: ${_jsonContent}"); //OK
    // print(_jsonContent);
    // List<Post> postList = _jsonContent.map((item) => Post.fromJson(item)).toList();
    setState(() {
      statesList = _jsonContent['state'];
    });
  }

  Future _getCitiesListFromJson(int sid) async{
    // PostService.getPost();
    String _content = await rootBundle.loadString('assets/data/system_series_stage_table.json');
    print('get states from json  ${_content}');
    var _jsonContent = json.decode(_content);
    var _cList = _jsonContent['cities'];
    print('cites : ${_cList}');
    // var _cities = _jsonContent['cities'].filter((item) => item.state_id == sid);
    //AllMovies.where((i) => i.isAnimated).toList();
    // _jsonContent['cities'].where((item) => item.state_id == sid);
    // var _cities = _jsonContent['cities'].where((item) => item.state_id == sid).toList();
    _cList.forEach((item) => print('${item["id"]}'));
    var _cities = _cList.where((item) => item['state_id'] == sid).toList();
    print('_cities: ${_cities}');
    // List<Post> postList = _jsonContent.map((item) => Post.fromJson(item)).toList();

    setState(() {
      // statesList = _cities;
      citiesList = _cities;
    });
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(image == null) return;
    setState(() {
      _imgsPath.add(image.path);
      _imgsFile.add(image);
      _imgsUploaded.add(false);
      _uploadedStatus[image.path] = false;
      _uploadingStatus[image.path] = false;
      print('images files size: ${_imgsFile.length}  ${image.path}');
    });
    print('get image ${image.uri} ');
    //_doUploadImage(image, "");//上传图片
  }

  Future uploadImages() async{
    for(int i =0; i < _imgsPath.length; i++){
      if(_imgsPath[i].startsWith('http')){
        // setState(() {
        //   _uploadingStatus[_imgsPath[i]] = true;
        // });
        continue;
      } 
      print('upload ${_imgsPath[i]}');
      if(_uploadedStatus[_imgsPath[i]]) continue;
      // _doUploadImage(_imgsPath[i], '');
      print('try to upload ${_imgsPath[i]}');
      setState(() {
          _uploadingStatus[_imgsPath[i]] = true;
      });
      File f = File(_imgsPath[i]);
      _doUploadImage(f, '');
    }
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
    //File f = new File("/Users/johnnyz/Library/Developer/CoreSimulator/Devices/132ABB73-6757-4EF6-B756-F98A551FEBE5/data/Containers/Data/Application/A5EF41B5-85CE-449D-9B93-067374341C1B/tmp/image_picker_35008CE8-0759-4B96-939E-D82F4A752583-77679-0003AD0C9976E1EA.jpg");
    // File f = File.fromUri(Uri(path: 'http://images.tornadory.com/1602602430178.jpg'));
    // File f = File('http://images.tornadory.com/1602602430178.jpg');
    // Image g = Image.network('http://images.tornadory.com/1602602430178.jpg');
    // setState(() {
      // _imgsFile.add(f);
      // _imgsPath.add('http://images.tornadory.com/1602602430178.jpg');
      // _imgsUploaded.add(true);
      // _uploadedStatus['http://images.tornadory.com/1602602430178.jpg'] = true;
      // print('images files size: ${_imgsFile.length} ');
    // });

    // _getStateList();
    _getStateListFromJson();
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
              int len = _imgsPath.length;
              if(len < 1) {
                print('no pictures selected');
                Fluttertoast.showToast(
                  msg: "没有选择图片！",
                  gravity: ToastGravity.CENTER,
                  textColor: Colors.red);
              }
              for(int i = 0; i < len; i++){
                String path = _imgsPath[i];
                if(path.startsWith('http')) continue;
                if(!_uploadedStatus[path]){
                  print('still have some not been uploaded');
                  Fluttertoast.showToast(
                    msg: "还有图片未上传！",
                    gravity: ToastGravity.CENTER,
                    textColor: Colors.red);
                  return;
                }
              }

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
                  //   child: _imgsFile.length > 0 ? ReorderableListView(
                  //     scrollDirection: Axis.horizontal,
                  //     onReorder: (oldIndex, newIndex){
                  //       setState(() {
                  //         //update
                  //       });
                  //     },
                  //     children: <Widget>[
                  //       for(final img in _imgsFile)
                  //         ListTile(
                  //           key: ValueKey(img),
                  //           leading: Stack(
                  //             alignment: Alignment.center,
                  //             children: <Widget>[
                  //               Image.file(
                  //                 img,width: 150, height: 150,
                  //               ),
                  //               Positioned(
                  //                 right: 0,
                  //                 top: 0,
                  //                 child: IconButton(
                  //                   icon: Icon(Icons.delete),
                  //                   onPressed: (){
                  //                     print('image remove icon clicked');
                  //                     setState(() {
                  //                       //_imgsFile.removeAt(index);
                  //                     });
                  //                   },
                  //                 ),
                  //               ),
                  //               CircularProgressIndicator()
                  //             ],
                  //           ),
                  //         )
                  //     ],
                  //   ) : Center(child: Text("未上传图片")),
                    // child: _imgsFile.length > 0 ? ListView.builder(
                    child: _imgsPath.length > 0 ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index){
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              _imgsPath[index].startsWith('http')? 
                                Image.network('${_imgsPath[index]}')
                                : Image.file(File(_imgsPath[index])),
                              Visibility(
                                visible: true,
                                child: Positioned(
                                  right: 0,
                                  top: 10.0,
                                  child: IconButton(
                                    icon: new Image.asset('images/icons/icons8-delete.png'),
                                    onPressed: (){
                                      print('image remove icon clicked');
                                      setState(() {
                                        _uploadedStatus.remove(_imgsPath[index]);
                                        _uploadingStatus.remove(_imgsPath[index]);
                                        _imgsPath.removeAt(index);
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: _uploadingStatus[_imgsPath[index]] || _uploadedStatus[_imgsPath[index]],
                                child: _uploadedStatus[_imgsPath[index]] ? Image.asset('images/icons/icons8-checkmark.png', width: 40, height: 40,) : CircularProgressIndicator(),
                              )
                            ],
                          ),
                        );
                      },
                      // itemCount: _imgsFile.length,
                      itemCount: _imgsPath.length,
                    ) : Center(child: Text("未上传图片")),                   
                    ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      child: Text('选择图片'),
                      onPressed: (){
                          getImage();
                      },
                    ),
                    RaisedButton(
                      child: Text('上传'),
                      onPressed: (){
                        uploadImages();
                      },
                    ),
                  ],),
                Row(
                  children: <Widget>[
                    Text('标题: '),
                    Expanded(child: TextFormField(
                      controller: _titleTextController,
                      autovalidate: true,
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
                        autovalidate: true,
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
                      autovalidate: true,
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
                      autovalidate: true,
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
                      // autovalidate: true,
                      // validator: (value){
                      //   if(value.isEmpty){
                      //     return '海拔没有填写';
                      //   }
                      //   return null;
                      // },
                      ),)
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('地址: '),
                    Expanded(child: TextFormField(
                      controller: _addrTextController,
                      // autovalidate: true,
                      // validator: (value){
                      //   if(value.isEmpty){
                      //     return '地址没有填写';
                      //   }
                      //   return null;
                      // },
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

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: <Widget>[
                //     Text('分类: '),
                //     Expanded(
                //       child: 
                //     ),
                //   ],
                // ),

                Container(
                  // padding: EdgeInsets.only(left: 8, right: 8, top: 5),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('State: '),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton<String>(
                              value: _myState,
                              // value: 'No',
                              iconSize: 30,
                              icon: (null),
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                              hint: Text('Select State'),
                              onChanged: (String newValue) {
                                setState(() {
                                  _myState = newValue;
                                  int sid = int.parse(_myState);
                                  print('_mystate ${_myState}');
                                  _getCitiesListFromJson(sid);
                                  // _myCity = "";
                                });
                              },
                              items: statesList?.map((item) {
                                    return new DropdownMenuItem(
                                      child: new Text(item['name']),
                                      value: item['id'].toString(),
                                    );
                                  })?.toList() ??
                                  [],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  // padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('City: '),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton<String>(
                              value: _myCity,
                              iconSize: 30,
                              icon: (null),
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                              hint: Text('Select City'),
                              onChanged: (String newValue) {
                                setState(() {
                                  _myCity = newValue;
                                  print(_myCity);
                                });
                              },
                              items: [],
                              // items: citiesList?.map((item) {
                              //       print("map item ${item}");
                              //       return new DropdownMenuItem(
                              //         child: new Text(item['name']),
                              //         value: item['id'].toString(),
                              //       );
                              //     })?.toList() ??
                              //     [],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
    for(int i =0; i < _imgsPath.length; i++){
      String path = _imgsPath[i];
      if(path.startsWith('http')) continue;
      if(_uploadedStatus[_imgsPath[i]]){
        _imgsPath[i] = _uploadedPath[_imgsPath[i]];
      }
    }
    String _images = list2String(_imgsPath, ',');
    print('get images path string: ${_images}');
    print('test ${_altTextController.text }');

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
      "category_id" : _category == -1 ? null : _category,
      "final_category_id" : null,
      "final_category_id_from" : null,
      "coordinate_latitude" : (_latTextController.text == null || _latTextController.text.isEmpty) ? null : double.parse(_latTextController.text),
      "coordinate_longitude" : (_lngTextController.text == null || _lngTextController.text.isEmpty ) ? null : double.parse(_lngTextController.text),
      "coordinate_altitude" : (_altTextController.text == null || _altTextController.text.isEmpty) ? null : double.parse(_altTextController.text),
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

  _submitPost2(BuildContext context) async{
    for(int i =0; i < _imgsPath.length; i++){
      String path = _imgsPath[i];
      if(path.startsWith('http')) continue;
      if(_uploadedStatus[_imgsPath[i]]){
        _imgsPath[i] = _uploadedPath[_imgsPath[i]];
      }
    }
    String _images = list2String(_imgsPath, ',');
    print('get images path string: ${_images}');

    FormData formData = new FormData.fromMap({
      "images" : _images,
      "title" : _titleTextController.text,
      "content" : _contentTextController.text,
      "coordinate_latitude" : (_latTextController.text == null || _latTextController.text.isEmpty) ? null : double.parse(_latTextController.text),
      "coordinate_longitude" : (_lngTextController.text == null || _lngTextController.text.isEmpty ) ? null : double.parse(_lngTextController.text),
      "coordinate_altitude" : (_altTextController.text == null || _altTextController.text.isEmpty) ? null : double.parse(_altTextController.text),
      "address" : _addrTextController.text,
      'category_id' : _category == -1 ? null : _category,
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
    String updateUrl = apiUrl+servicePath['posts'];
    var respone = await dio.post<String>(updateUrl, data: formData, options: options);
    print(respone);
    if (respone.statusCode == 200) {
      var responseJson = json.decode(respone.data);
      print('response: ${respone.data} - ${responseJson['message']}');

      var status = responseJson['code'] as int;
      if(status == 200){
        Fluttertoast.showToast(
            msg: "发布成功",
            gravity: ToastGravity.CENTER,
            textColor: Colors.grey);

        Navigator.pop(context, true);
      }else{
        Fluttertoast.showToast(
            msg: "发布失败，继续保存在本地数据库中！",
            gravity: ToastGravity.CENTER,
            textColor: Colors.red);
      }
    }
  }

  _submitPost(BuildContext context) async{
    for(int i =0; i < _imgsPath.length; i++){
      String path = _imgsPath[i];
      if(path.startsWith('http')) continue;
      if(_uploadedStatus[_imgsPath[i]]){
        _imgsPath[i] = _uploadedPath[_imgsPath[i]];
      }
    }
    String _images = list2String(_imgsPath, ',');
    print('get images path string: ${_images}');
    print('${_latTextController.text} _ ${_lngTextController.text}');

    FormData formData = new FormData.fromMap({
      "images" : _images,
      "title" : _titleTextController.text,
      "content" : _contentTextController.text,
      "coordinate_latitude" : (_latTextController.text == null || _latTextController.text.isEmpty) ? null : double.parse(_latTextController.text),
      "coordinate_longitude" : (_lngTextController.text == null || _lngTextController.text.isEmpty ) ? null : double.parse(_lngTextController.text),
      "coordinate_altitude" : (_altTextController.text == null || _altTextController.text.isEmpty) ? null : double.parse(_altTextController.text),
      "address" : _addrTextController.text,
      'category_id' : _category == -1 ? null : _category,
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
    String uploadUrl = apiUrl+servicePath['posts'];
    var respone = await dio.post<String>(uploadUrl, data: formData, options: options);
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
    }else{
      Fluttertoast.showToast(
          msg: "提交记录失败！",
          gravity: ToastGravity.CENTER,
          textColor: Colors.red);
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
          // _imgsPath.add(uploadedItem.path);

          _uploadedStatus[file.path] = true;
          _uploadedPath[file.path] = uploadedItem.path;
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