import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostUploadPage extends StatefulWidget {
  @override
  _PostUploadPageState createState() => _PostUploadPageState();
}

class _PostUploadPageState extends State<PostUploadPage> {
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    // _upLoadImage(image);//上传图片
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
}