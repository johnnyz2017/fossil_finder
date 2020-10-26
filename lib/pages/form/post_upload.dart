import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'package:amap_map_fluttify/amap_map_fluttify.dart';

class PostUploadPage extends StatefulWidget {
  final LatLng latLng;

  const PostUploadPage({Key key, this.latLng}) : super(key: key);
  @override
  _PostUploadPageState createState() => _PostUploadPageState();
}

class _PostUploadPageState extends State<PostUploadPage> {
  File _image;

  var _latTextController = new TextEditingController();
  var _lngTextController = new TextEditingController();

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    _upLoadImage(image);//上传图片
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('发布页面'),
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 200,
                  child: Center(
                    child: _image == null
                        ? Text('没有选择图片加入')
                        : Image.file(_image),
                  ),
                ),
              
              ),
              FloatingActionButton(
                  onPressed: getImage,
                  tooltip: '获取图片',
                  child: Icon(Icons.add_a_photo),
              ),
            ],
          ),
          
          Divider(),
          // Text("选择上图进行发布"),
          // Row(
          //   children: <Widget>[
          //     Text("经度： "),
          //     EditableText(
          //       controller: new TextEditingController(), 
          //       backgroundCursorColor: Colors.green, 
          //       focusNode: null, 
          //       cursorColor: Colors.red, 
          //       style: null,
          //     )
          //   ],
          // ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('经度: '),
              Expanded(child: TextField(controller: _lngTextController,)),
              Text('纬度: '),
              Expanded(child: TextField(controller: _latTextController,)),
              IconButton(
                iconSize: 20, 
                icon: Icon(Icons.my_location), 
                onPressed: () async { 
                  //AmapService.navigateDrive(LatLng(36.547901, 104.258354));
                  setState(() {
                    _latTextController.text = widget.latLng.latitude.toString();
                    _lngTextController.text = widget.latLng.longitude.toString();
                  });
                },
              )
            ],
          ),
          Divider(),
          // CalendarDatePicker(
          //   initialDate: DateTime.now(), 
          //   firstDate: DateTime.parse("2020-10-01"), 
          //   lastDate: DateTime.parse("2020-11-20"), 
          //   onDateChanged: (value)=>{
          //     print("changed to $value")
          //   }
          // ),
          // Row(
          //   children: <Widget>[
          //     Text("纬度： "),
          //     TextField(
          //       decoration: InputDecoration(icon: Icon(Icons.my_location),),
          //     )
          // ],
          // )
        ],
      ),
      // floatingActionButton: Positioned(
      //   top: 50,
      //   right: 10,
      //   child: FloatingActionButton(
      //     onPressed: getImage,
      //     tooltip: 'Pick Image',
      //     child: Icon(Icons.add_a_photo),
      //   ),
      // ),
    );
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
    var respone = await dio.post<String>("http://localhost:8000/api/v1/posts", data: formData, options: options);
    print(respone);
    if (respone.statusCode == 200) {

      var responseJson = json.decode(respone.data);
      print('response: ${respone.data} - ${responseJson['statusCode']}');

      var status = responseJson['statusCode'] as int;
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
  
}