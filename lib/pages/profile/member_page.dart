import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fossils_finder/api/service_method.dart';
import 'package:fossils_finder/config/global_config.dart';
import 'package:fossils_finder/model/user.dart';
import 'package:fossils_finder/pages/form/password_update.dart';
import 'package:fossils_finder/pages/form/profile_update.dart';
import 'package:fossils_finder/pages/login/login_page.dart';
import 'package:fossils_finder/pages/profile/local_list_page.dart';
import 'package:fossils_finder/pages/profile/private_list_page.dart';
import 'package:fossils_finder/pages/profile/public_list_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemberPage extends StatefulWidget {
  final String title;

  const MemberPage({Key key, this.title}) : super(key: key);

  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> with AutomaticKeepAliveClientMixin{

  User user;

  Future loadUserFromServer() async{
    var _content = await request('${serviceUrl}/api/v1/self');
    if(_content.statusCode != 200){
      if(_content.statusCode == 401){
        print('#### unauthenticated, need back to login page ${_content.statusCode}');
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.remove('token');
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ));
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
    loadUserFromServer();
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
          _actionList(),
          // Divider(),
          // Expanded(
          //   child: Align(
          //     alignment: FractionalOffset.bottomCenter,
          //     child: 
          //   ),
          // ),
          SizedBox(height: 200,),
          ListTile(
            leading: Icon(Icons.settings),
              title: Text("个人设置"),
              onTap: (){
                var ret = Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MemberProfileUpdatePage(user: user,),
                ));

                ret.then((value){
                  print('return from navi : ${value}');
                  if(value == true){
                    loadUserFromServer();
                  }
                });
              },
          ),
          ListTile(
            leading: Icon(Icons.change_history),
              title: Text("修改密码"),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PasswordUpdatePage(user: user,),
                ));
              },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
              title: Text("退出登陆"),
              onTap: (){
                logout();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ));
              },
          ),
        ],
      ),
    );
  }

  logout() async{
    if(localStorage == null) localStorage = await SharedPreferences.getInstance();
    localStorage.remove('token');
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
          Row(children: <Widget>[
            Column(
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
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text('记录发布数：'),
                      Text('0')
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text('类别发布数：'),
                      Text('0')
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text('评论发布数：'),
                      Text('0')
                    ],
                  ),
                ],
              ),
            ),
          ],) 
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
          _myListTile('已公开发布记录', (){
            print('public clicked');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) {
                return PublisPostsPage();
              }) 
            );
          }),
          _myListTile('私有标本记录', (){
            print('private clicked');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) {
                return PrivatePostsPage();
              }) 
            );
          }),
          _myListTile('尚未发布记录', (){
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