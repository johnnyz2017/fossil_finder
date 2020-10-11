import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class PostUploadPage extends StatefulWidget {
  @override
  _PostUploadPageState createState() => _PostUploadPageState();
}

class _PostUploadPageState extends State<PostUploadPage> {
  File _image;

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
        title: Text('Image Picker Example'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 200,
            child: Center(
              child: _image == null
                  ? Text('No image selected.')
                  : Image.file(_image),
            ),
          ),
          Divider(),
          Text("选择上图进行发布"),
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
          TextField(
            decoration: InputDecoration(
              icon: Icon(Icons.my_location),
            ),
          ),
          Divider(),
          CalendarDatePicker(
            initialDate: DateTime.now(), 
            firstDate: DateTime.parse("2020-10-01"), 
            lastDate: DateTime.parse("2020-11-20"), 
            onDateChanged: (value)=>{
              print("changed to $value")
            }
          ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
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
    var respone = await dio.post<String>("http://localhost:8000/api/v1/post", data: formData, options: options);
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