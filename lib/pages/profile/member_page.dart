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

import 'package:ali_icons/ali_icons.dart';

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
    String userName = user == null ? "未命名" : user.name;
    String profileUrl = user == null ? 'images/icons/user.png' : user.avatar;

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: (){
            },
          )
        ],
        title: Row(
          children: <Widget>[
            Container(
                margin: EdgeInsets.fromLTRB(0, 8, 10, 8),
                child: ClipOval(
                  child: 
                      profileUrl.startsWith('http') ? CachedNetworkImage(
                              height: 50,
                              width: 50,
                              imageUrl: profileUrl,
                              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            )
                      : Image.asset(profileUrl, height: 50, width: 50,),
                ),
                decoration: new BoxDecoration(
                  border: new Border.all(
                    color: Colors.orange,
                    width: 1.0,
                  ),
                  borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
                )),
            Container(
              child: Text(
                userName,
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            Container(
              child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: (){
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
            )
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
        child: ListView(
          children: <Widget>[
            _topHeader0(),
            // _infoPanel(),
            // _actionButons(),
            _actionList(),
            SizedBox(height: 300,),
            // ListTile(
            //   leading: Icon(Icons.settings),
            //     title: Text("个人设置"),
            //     onTap: (){
            //       var ret = Navigator.of(context).push(MaterialPageRoute(
            //         builder: (context) => MemberProfileUpdatePage(user: user,),
            //       ));

            //       ret.then((value){
            //         print('return from navi : ${value}');
            //         if(value == true){
            //           loadUserFromServer();
            //         }
            //       });
            //     },
            // ),
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
      ),
    );
  }

  logout() async{
    if(localStorage == null) localStorage = await SharedPreferences.getInstance();
    localStorage.remove('token');
  }

  @override
  bool get wantKeepAlive => true;

  Widget _infoPanel(){
    return Card(
      color: Colors.red,
      shadowColor: Colors.grey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
        Column(
          children: <Widget>[
            Text('${user.postsCount}'),
            Text('记录'),
          ],
        ),
        Column(
          children: <Widget>[
            Text('${user.categoriesCount}'),
            Text('类别'),
          ],
        ),
        Column(
          children: <Widget>[
            Text('${user.commentsCount}'),
            Text('鉴定'),
          ],
        ),
      ],),
    );
  }

  Widget _actionButons(){
    return SizedBox(
      height: 100,
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
            IconButton(
              icon: Icon(Icons.access_alarm), 
              onPressed: (){
                print('public clicked');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return PublisPostsPage();
                  }) 
                );
              }),
            InkWell(
              onTap: (){
                print('public clicked');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return PublisPostsPage();
                  }) 
                );
              },
              child: Column(
                children: <Widget>[
                  Icon(AliIcons.user_outline),
                  Text('公开'),
                ],
              ),
            ),
            Column(
              children: <Widget>[
                Icon(AliIcons.android),
                Text('私有'),
              ],
            ),
            Column(
              children: <Widget>[
                Icon(Icons.record_voice_over),
                Text('未发布'),
              ],
            ),
            Column(
              children: <Widget>[
                Icon(Icons.record_voice_over),
                Text('鉴定'),
              ],
            ),
          ],),
        ),
      ),
    );
  }
  Widget _topHeader0(){
    String userName = user == null ? "未命名" : user.name;
    String userEmail = user == null ? '' : user.email;

    return Card(
      elevation: 5.0,
      color: Colors.white60,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14.0))),
      // shadowColor: Colors.green,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: <Widget>[
                Container(
                 child: Text('超级管理员', 
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    )
                  ),
                ),
                Text(userEmail, style: TextStyle(fontStyle: FontStyle.italic),),
                SizedBox(height: 50,),
              ],
              ),
            ),
            

            SizedBox(
              height: 60,
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text('${user.postsCount}'),
                        Text('记录'),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text('${user.categoriesCount}'),
                        Text('类别'),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text('${user.commentsCount}'),
                        Text('鉴定'),
                      ],
                    ),
                  ],),
                ),
              ),
            )
          ],
        ),
    );
  }

  Widget _topHeader(){
    String userName = user == null ? "未命名" : user.name;
    String profileUrl = user == null ? 'images/icons/user.png' : user.avatar;
    String userEmail = user == null ? '' : user.email;

    return Card(
      color: Colors.white60,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
            Container(
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
            SizedBox(width: 20,),
            Column(
              children: <Widget>[
                Text(
                  userName, 
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  )
                ),

                Text(userEmail, style: TextStyle(fontStyle: FontStyle.italic),)
              ],
            ),
          ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
            Column(
              children: <Widget>[
                Text('${user.postsCount}'),
                Text('记录'),
              ],
            ),
            Column(
              children: <Widget>[
                Text('${user.categoriesCount}'),
                Text('类别'),
              ],
            ),
            Column(
              children: <Widget>[
                Text('${user.commentsCount}'),
                Text('鉴定'),
              ],
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