import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fossils_finder/config/global_config.dart';
import 'package:fossils_finder/model/category.dart';
import 'package:fossils_finder/model/post.dart';
import 'package:fossils_finder/pages/list/category_select.dart';
import 'package:fossils_finder/pages/map/map_show.dart';
import 'package:fossils_finder/utils/db_helper.dart';
import 'package:fossils_finder/utils/qiniu_image_upload.dart';
import 'package:fossils_finder/utils/strings.dart';
import 'package:fossils_finder/widgets/helper_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

class LocalPostEditblePage extends StatefulWidget {
  final Post post;

  const LocalPostEditblePage({Key key, this.post}) : super(key: key);

  @override
  _LocalPostEditblePageState createState() => _LocalPostEditblePageState();
}

class _LocalPostEditblePageState extends State<LocalPostEditblePage> {
  LatLng centerPos;
  DatabaseHelper dbhelper = DatabaseHelper();
  bool editmode = false;
  final _formKey = GlobalKey<FormState>();
  // File _image;
  Image _image;
  List<String> _imgsPath = [];
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

  List systemList;
  String _currentSystem;
  String _currentSystemName;

  String stateInfoUrl = '${apiUrl}/system';
  Future<String> _getSystemList() async {
    await http.get(stateInfoUrl, headers: {
      'Accept': 'application/json'
    }).then((response) {
      var data = json.decode(response.body);

     print(data);
      setState(() {
        systemList = data['data'];
      });
    });
  }

  // Get State information by API
  List seriesList;
  String _currentSeries;
  String _currentSeriesName;
  Future<String> _getSeriesList(int id) async {
    String cityInfoUrl = '${apiUrl}/system/${id}/series';
    await http.get(cityInfoUrl, headers: {
      'Accept': 'application/json'
    }).then((response) {
      var data = json.decode(response.body);
      print('series: ${data}');
      setState(() {
        seriesList = data['data'];
      });
    });
  }

  List stagesList;
  String _currentStage;
  String _currentStageName;
  Future<String> _getStagesList(int id) async {
    String cityInfoUrl = '${apiUrl}/series/${id}/stages';
    await http.get(cityInfoUrl, headers: {
      'Accept': 'application/json'
    }).then((response) {
      var data = json.decode(response.body);
      print('stages: ${data}');
      setState(() {
        stagesList = data['data'];
      });
    });
  }

  Future uploadImages() async{
    for(int i =0; i < _imgsPath.length; i++){
      if(_imgsPath[i].startsWith('http')) continue;
      print('upload ${_imgsPath[i]}');
      if(_uploadedStatus[_imgsPath[i]]) continue;
      // _doUploadImage(_imgsPath[i], '');
      print('try to upload ${_imgsPath[i]}');
      File f = File(_imgsPath[i]);
      _doUploadImage(f, '');
    }
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(image == null) return;
    setState(() {
      _imgsPath.add(image.path);
      _uploadedStatus[image.path] = false;
      _uploadingStatus[image.path] = false;
      print('images files size: ${_imgsPath.length}  ${image.path}');
    });
    print('get image ${image.uri} ');
    // _doUploadImage(image, "");//上传图片

  }

  @override
  void initState() {
    super.initState();
    _private = widget.post.private;
    _category = widget.post.categoryId;
    centerPos = LatLng(widget.post.coordinateLatitude, widget.post.coordinateLongitude);

    _getSystemList();
    
    _imgsPath = widget.post.images == null ? [] : widget.post.images.map((e) => e.url).toList(); //TBD
    // print('get image path: ${_imgsPath[0]}');
    for(int i =0; i < _imgsPath.length; i++){
      if(_imgsPath[i].startsWith('http')){
        _uploadedStatus[_imgsPath[i]] = true;
        _uploadingStatus[_imgsPath[i]] = false;
      }else{   
        _uploadedStatus[_imgsPath[i]] = false;
        _uploadingStatus[_imgsPath[i]] = false;
      }
    }

    _latTextController.text = centerPos.latitude.toStringAsFixed(6);
    _lngTextController.text = centerPos.longitude.toStringAsFixed(6);
    _altTextController.text = widget.post.coordinateAltitude?.toStringAsFixed(6);
    _addrTextController.text = widget.post.address;
    _titleTextController.text = widget.post.title;
    _contentTextController.text = widget.post.content;
    _categoryTextController.text = widget.post.categoryName;

    print('system: ${widget.post.system} - ${widget.post.series} - ${widget.post.stage}');
    if(widget.post.system != null){
      _currentSystem = widget.post.system;
      _currentSeries = widget.post.series;
      _currentStage = widget.post.stage;
      int systemId = int.parse(_currentSystem);
      _getSeriesList(systemId);
      int stageId = int.parse(_currentSeries);
      _getStagesList(stageId);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('发布页面'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: (){
              setState(() {
                editmode = true;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: (){
              if(!editmode) return;
              _savePost();
            },
          ),
          IconButton(
            icon: Icon(Icons.done),
            onPressed: (){
              // if(!editmode) return;
              int len = _imgsPath.length;
              if(len < 1) {
                print('no pictures selected');
                AlertDialog(title: Text('没有选择图片'),);
              }
              for(int i = 0; i < len; i++){
                String path = _imgsPath[i];
                if(path.startsWith('http')) continue;
                if(!_uploadedStatus[path]){
                  print('still have some not been uploaded');
                  
                  // Fluttertoast.showToast(
                  //   msg: "还有图片未上传！",
                  //   gravity: ToastGravity.CENTER,
                  //   textColor: Colors.red);
                  // errorToast("还有图片未上传！");
                  AlertDialog(title: Text('还有图片未上传'),);
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
        padding: const EdgeInsets.all(DMARGIN),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                
                Container(
                  height: 150,
                  child: _imgsPath.length > 0 ? ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index){
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Visibility(
                              child: LimitedBox(
                                maxHeight: 150,
                                maxWidth: 150,
                                child: _imgsPath[index].startsWith('http')? 
                                  Image.network('${_imgsPath[index]}')
                                  : Image.file(File(_imgsPath[index])),
                              ),),
                            Visibility(
                              visible: editmode,
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
                    itemCount: _imgsPath.length,
                  ) : Center(child: Text("未上传图片")),
                ),
                Visibility(
                  visible: editmode,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        child: Text('选择图片'),
                        onPressed: (){
                          if(editmode)
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
                ),

                Row(
                  children: <Widget>[
                    Text('标题: '),
                    Expanded(child: TextFormField(
                      readOnly: !editmode,
                      // initialValue: widget.post.title,
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
                        readOnly: !editmode,
                        // initialValue: widget.post.content,
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
                    Text('纬度: '),
                    Expanded(child: TextFormField(
                      inputFormatters: [
                        WhitelistingTextInputFormatter(RegExp("[.,0-9]"))
                      ],
                      readOnly: !editmode,
                      // initialValue: widget.post.latitude.toString(),
                      controller: _latTextController,
                      autovalidate: true,
                      validator: (value){
                          if(value.isEmpty){
                            return '纬度没有填写';
                          }
                          return null;
                        },
                    )),
                    Text('经度: '),
                    Expanded(child: TextFormField(
                      inputFormatters: [
                        WhitelistingTextInputFormatter(RegExp("[.,0-9]"))
                      ],
                      readOnly: !editmode,
                      // initialValue: widget.post.longitude.toString(),
                      controller: _lngTextController,
                      autovalidate: true,
                      validator: (value){
                          if(value.isEmpty){
                            return '经度没有填写';
                          }
                          return null;
                        },
                      )),
                    IconButton(
                      iconSize: 21, 
                      icon: Image.asset(
                        'images/icons/target_gray.png',
                        width: 21,
                        height: 21,
                        fit: BoxFit.fill
                      ), 
                      onPressed: editmode ? () async {
                        var pos = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) {
                            return MapShowPage(
                              coord: centerPos,
                              selectable: true,
                            );
                          })
                        );
                        if(pos != null){
                          print('pos get: ${pos.latitude} - ${pos.longitude}');
                          setState(() {
                            centerPos = pos;
                            _latTextController.text = pos.latitude.toStringAsFixed(6);
                            _lngTextController.text = pos.longitude.toStringAsFixed(6);
                          });
                        }
                      } : null,
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('海拔: '),
                    Expanded(child: TextFormField(
                      inputFormatters: [
                        // WhitelistingTextInputFormatter(RegExp("[.,0-9]"))
                        FilteringTextInputFormatter.allow(RegExp(r'^-?(?:-?(?:[0-9]+))?(?:.[0-9]*)?(?:[eE][+-]?(?:[0-9]+))?'))
                      ],
                      readOnly: !editmode,
                      // initialValue: widget.post.altitude.toString(),
                      controller: _altTextController,
                      // validator: (value){
                      //     if(value.isEmpty){
                      //       return '海拔没有填写';
                      //     }
                      //     return null;
                      //   },
                      ),)
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('地址: '),
                    Expanded(child: TextFormField(
                      readOnly: !editmode,
                      // initialValue: widget.post.address,
                      controller: _addrTextController,
                      // validator: (value){
                      //     if(value.isEmpty){
                      //       return '地址没有填写';
                      //     }
                      //     return null;
                      //   },
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
                        // initialValue: widget.post.category_id.toString(), //TBD
                        // validator: (value){
                        //   if(value.isEmpty || value.contains('null')){
                        //     return '请选择一个分类';
                        //   }
                        //   return null;
                        // },
                        onSaved: (value){
                          //
                        },
                        onTap: ()async{
                          if(editmode){
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
                          }
                        },
                      ),
                    ),

                    // IconButton(
                    //   iconSize: 20, 
                    //   icon: Icon(Icons.category), 
                    //   onPressed: () async {
                    //     if(editmode){
                    //       category = await Navigator.push(
                    //         context,
                    //         MaterialPageRoute(builder: (BuildContext context) {
                    //           return CategorySelector(treeJson: "",);
                    //         }) 
                    //       );

                    //       if(category != null){
                    //         print('result: ${category.key} - ${category.label}');
                    //         _categoryTextController.text = category.label;
                            
                    //         String _key = category.key;
                    //         String _type = _key.split('_')[0];
                    //         if(_type.isNotEmpty || _type == "c"){
                    //           _category = int.parse(_key.split('_')[1]);
                    //           print('got category id ${_category}');
                    //         }
                    //       }
                    //     }             
                    //   },
                    // )
                  ],
                ),

                Container(
                  // padding: EdgeInsets.only(left: 8, right: 8, top: 5),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        // alignment: Alignment.centerRight,
                        width: 80,
                        child: Text('System / Period: ')),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton<String>(
                              disabledHint: Text('非编辑模式或空列表'),
                              value: _currentSystem,
                              iconSize: 30,
                              icon: (null),
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                              hint: Text('Select System'),
                              onChanged: !editmode ? null : (String newValue) {
                                setState(() {
                                  _currentSystem = newValue;
                                  int sid = int.parse(_currentSystem);
                                  var item = systemList.firstWhere((element) => element['id'] == sid, orElse: () {
                                    return null;
                                  },);
                                  _currentSystemName = item['name'];
                                  // print('_currentSystem ${_currentSystemName} - name : ${systemList.where((element) => element['id'] == sid)}');
                                  _getSeriesList(sid);
                                });
                              },
                              items: systemList?.map((item) {
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
                      Container(
                        // alignment: Alignment.centerRight,
                        width: 80,
                        child: Text('Series / Epoch: ')),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton<String>(
                              disabledHint: Text('非编辑模式或空列表'),
                              value: _currentSeries,
                              iconSize: 30,
                              icon: (null),
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                              hint: Text('Select Series'),
                              onChanged: !editmode ? null : (String newValue) {
                                setState(() {
                                  _currentSeries = newValue;
                                  int _sid = int.parse(_currentSeries);
                                  var item = seriesList.firstWhere((element) => element['id'] == _sid, orElse: () {
                                    return null;
                                  },);
                                  _currentSeriesName = item['name'];
                                  print(_currentSeries);
                                  _getStagesList(_sid);
                                });
                              },
                              items: seriesList?.map((item) {
                                    print("map item ${item}");
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
                      Container(
                        // alignment: Alignment.centerRight,
                        width: 80,
                        child: Text('Stage / Age: ')),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton<String>(
                              disabledHint: Text('非编辑模式或空列表'),
                              value: _currentStage,
                              iconSize: 30,
                              icon: (null),
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                              hint: Text('Select Stage'),
                              onChanged: !editmode ? null : (String newValue) {
                                setState(() {
                                  _currentStage = newValue;
                                  int sid = int.parse(_currentStage);
                                  var item = systemList.firstWhere((element) => element['id'] == sid, orElse: () {
                                    return null;
                                  },);
                                  _currentStageName = item['name'];
                                  print(_currentStage);
                                });
                              },
                              items: stagesList?.map((item) {
                                    print("map item ${item}");
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

                Row(
                  children: <Widget>[
                    Text('是否私有：'),
                    Theme(
                      data: ThemeData(
                        primaryColor: Colors.blueAccent
                      ),
                      child: Switch(
                        value: _private, 
                        onChanged: editmode ? (value){
                          setState(() {
                            _private = value;
                          });
                        } : null,
                      ),
                    )
                  ],
                ),

                // Row(
                //   children: <Widget>[
                //     Text('提交时间: '),
                //     Expanded(child: TextFormField(
                //       readOnly: !editmode,
                //       initialValue: widget.post.createdAt.toString(),
                //       // controller: _altTextController,
                //       validator: (value){
                //           if(value.isEmpty){
                //             return '提交时间为空';
                //           }
                //           return null;
                //         },
                //       ),)
                //   ],
                // ),
                RaisedButton(
                  color: Colors.redAccent,
                  child: Text('删除记录'),
                  onPressed: (){
                    showDialog(
                      context: context,
                      builder: (context){
                        return AlertDialog(
                          title: Text("提示信息"),
                          content: Text("您确定要删除吗"),
                          actions: <Widget>[
                            RaisedButton(
                              child: Text("取消"),
                              color: Colors.blue,
                              textColor: Colors.white,
                              onPressed: (){
                                print("取消");
                                Navigator.pop(context);
                              },
                            ),
                            RaisedButton(
                              child: Text("确定"),
                              color: Colors.blue,
                              textColor: Colors.white,
                              onPressed: ()async{
                                print("确定");
                                Navigator.pop(context,"ok");
                                // Fluttertoast.showToast(
                                //     msg: "删除成功",
                                //     gravity: ToastGravity.CENTER,
                                //     textColor: Colors.grey);
                                successToast("删除成功");

                                dbhelper.deletePost(widget.post.id);

                                Navigator.pop(context, true);
                              },
                            ),
                          ],
                        );
                      }
                    );
                  }
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //
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
    Post _post = new Post.fromMapObject({
      'id' : widget.post.id,
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

    var ret =  await dbhelper.updatePost(_post);
    print('#### after insert post into local database - result: ${ret}');

    if(ret > 0){
      // Fluttertoast.showToast(
      //     msg: "本地保存成功",
      //     gravity: ToastGravity.CENTER,
      //     textColor: Colors.grey);
      successToast("本地保存成功");
      
      Navigator.pop(context, true);
    }else{
      // Fluttertoast.showToast(
      //     msg: "本地保存失败，请检查表单各属性，程序权限授予等。",
      //     gravity: ToastGravity.CENTER,
      //     textColor: Colors.red);
      errorToast("本地保存失败，请检查表单各属性，程序权限授予等。");
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
        // Fluttertoast.showToast(
        //     msg: "发布成功",
        //     gravity: ToastGravity.CENTER,
        //     textColor: Colors.grey);
        successToast("发布成功");

        dbhelper.deletePost(widget.post.id);

        Navigator.pop(context, true);
      }else{
        // Fluttertoast.showToast(
        //     msg: "发布失败，继续保存在本地数据库中！",
        //     gravity: ToastGravity.CENTER,
        //     textColor: Colors.red);
        errorToast("发布失败，继续保存在本地数据库中！");
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

    Dio dio = new Dio();
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
        // Fluttertoast.showToast(
        //     msg: "图片上传成功",
        //     gravity: ToastGravity.CENTER,
        //     textColor: Colors.grey);
        successToast("图片上传成功");
      }else{
        // Fluttertoast.showToast(
        //     msg: "图片上传失败！",
        //     gravity: ToastGravity.CENTER,
        //     textColor: Colors.red);
        errorToast("图片上传失败！");
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
          _uploadedStatus[file.path] = true;
          _uploadedPath[file.path] = uploadedItem.path;
        });
      } else {
        print('failed to upload ...');
      }
    } on DioError catch (e) {
      // debugPrint(e.toString());
      print('dio error ${e.message}');
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}