import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fossils_finder/api/service_method.dart';
import 'package:fossils_finder/config/global_config.dart';
import 'package:fossils_finder/model/user.dart';
import 'package:fossils_finder/pages/list/custom_list_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharePostPage extends StatefulWidget {
  final int postId;

  const SharePostPage({Key key, this.postId}) : super(key: key);
  @override
  _SharePostPageState createState() => _SharePostPageState();
}

class _SharePostPageState extends State<SharePostPage> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController();
  TextEditingController _userEmailTextController = new TextEditingController();
  List<User> sharedUsers = new List<User>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadSharedUsersFromServer(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('分享记录'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(DMARGIN),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _userEmailTextController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Email：',
                ),
                validator: (String value){
                  final email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
                  if (value.isEmpty || !email.hasMatch(value)) {
                    return '无效邮箱';
                  }
                  return null;

                },
              ),

              RaisedButton(
                color: Colors.greenAccent,
                child: Text('分享'),
                onPressed: () async{
                  if (_formKey.currentState.validate()) {
                    await _sharePost(context, widget.postId, _userEmailTextController.text, true);
                    loadSharedUsersFromServer(widget.postId);
                  }
                }
              ),

              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Text('已分享用户')
              ),
              SizedBox(
                height: 5,
              ),
              Divider(height: 1.0,indent: 0.0,color: Colors.grey,),
              Expanded(
                child: ListView.separated(
                  // shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index){
                    User u = sharedUsers[index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(u.email),
                        // Expanded(child: ),
                        RaisedButton(
                          color: Colors.redAccent,
                          child: Text('取消分享'),
                          onPressed: () async{
                            print('try to cancel share to ${u.email}');
                            await _sharePost(context, widget.postId, u.email, false);
                            loadSharedUsersFromServer(widget.postId);
                          }
                        )
                      ],
                    );
                  }, 
                  separatorBuilder: (context, index) => Divider(
                    height: 30,
                  ), 
                  itemCount: sharedUsers?.length ?? 0
                ),
              )
            ],
          ),
        ),
      )
    );
  }


  Future loadSharedUsersFromServer(int postId) async{
    var _content = await request( apiUrl+servicePath['posts']+'/${postId}/sharedusers');
    var _jsonData = jsonDecode(_content.toString());
    var _listJson;
    _listJson = _jsonData['data'];
    
    print('get json data is  ${_jsonData}');
    
    List _jsonList = _listJson as List;
    List<User> sharedUserList = _jsonList.map((item) => User.fromJson(item)).toList();
    print('postList: ${sharedUserList}');
    setState(() {
      sharedUsers = sharedUserList;
    });
  }

  Future<void> _sharePost(BuildContext context, int postId, String userEmail, [bool share = true]) async {

    FormData formData = new FormData.fromMap({
      "email" : userEmail,
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
        }else{
          return false;
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
    String updateUrl;
    if(share)
      updateUrl = apiUrl+servicePath['posts']+'/${postId}/addsharedusers';
    else
      updateUrl = apiUrl+servicePath['posts']+'/${postId}/removesharedusers';
    var respone = await dio.post<String>(updateUrl, data: formData, options: options);
    print(respone);
    if (respone.statusCode == 200) {
      var responseJson = json.decode(respone.data);
      print('response: ${respone.data} - ${responseJson['message']}');

      var status = responseJson['code'] as int;
      if(status == 200){
        Fluttertoast.showToast(
            msg: share? "分享成功" : "取消分享成功",
            gravity: ToastGravity.CENTER,
            textColor: Colors.grey);
        
        // Navigator.pop(context, true);
      }else{
        Fluttertoast.showToast(
            // msg: "分享失败失败，请检查被分享用户邮箱",
            msg: '${responseJson['message']}',
            gravity: ToastGravity.CENTER,
            textColor: Colors.red);
      }
    }
  }
}