import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fossils_finder/api/service_method.dart';
import 'package:fossils_finder/config/global_config.dart';
import 'package:fossils_finder/model/user.dart';
import 'package:fossils_finder/pages/profile/local_list_page.dart';
import 'package:fossils_finder/pages/profile/private_list_page.dart';
import 'package:fossils_finder/pages/profile/public_list_page.dart';

class MemberPage extends StatefulWidget {
  final String title;

  const MemberPage({Key key, this.title}) : super(key: key);

  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> with AutomaticKeepAliveClientMixin{

  User user;

  Future loadPostFromServer() async{
    var _content = await request('${serviceUrl}/api/v1/self');
    if(_content.statusCode != 200){
      if(_content.statusCode == 401){
        print('#### unauthenticated, need back to login page ${_content.statusCode}');
      }
      print('#### Network Connection Failed: ${_content.statusCode}');

      return;
    }
    var _jsonData = jsonDecode(_content.toString());
    // print('get json data is  ${_jsonData}');
    var _postJson = _jsonData['data'];
    User _user = User.fromJson(_postJson);
    print('user name is ${_user.name}');
    setState(() {
      user = _user;
    });
  }

  @override
  void initState() {
    super.initState();
    loadPostFromServer();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("会员中心")
      ),
      body: ListView(
        children: <Widget>[
          _topHeader(),
          _actionList()
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget _topHeader(){
    String userName = user == null ? "未命名" : user.name;
    String profileUrl = user == null ? 'images/icons/user.png' : user.avatar;

    return Container(
      // width: MediaQuery.of(context),
      padding: EdgeInsets.all(20),
      color: Colors.grey,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20),
            child: ClipOval(
              child: 
                profileUrl.startsWith('http') ? CachedNetworkImage(
                        height: 100,
                        width: 100,
                        imageUrl: profileUrl,
                        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      )
                 : Image.asset(profileUrl, height: 100, width: 100,),
            )
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(userName),
          )
        ],
      ),
    );
  }

  Widget _myListTile(String title, Function onTapCallback){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.black12)
        )
      ),
      child: ListTile(
        leading: Icon(Icons.blur_circular),
        title: Text(title),
        trailing: Icon(Icons.arrow_right),
        onTap: onTapCallback,
      ),
    );
  }

  Widget _actionList(){
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          _myListTile('已公开发布', (){
            print('public clicked');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) {
                return PublisPostsPage();
              }) 
            );
          }),
          _myListTile('已私有发布', (){
            print('private clicked');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) {
                return PrivatePostsPage();
              }) 
            );
          }),
          _myListTile('尚未发布', (){
            print('local clicked');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) {
                return LocalPostsPage();
              }) 
            );
          }),
        ],
      ),
    );
  }
}