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
import 'package:fossils_finder/pages/profile/posts_of_comments_page.dart';
import 'package:fossils_finder/pages/profile/private_list_page.dart';
import 'package:fossils_finder/pages/profile/public_list_page.dart';
import 'package:fossils_finder/pages/profile/setting_page.dart';
import 'package:fossils_finder/widgets/custom_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ali_icons/ali_icons.dart';

class MemberPage extends StatefulWidget {
  final String title;

  const MemberPage({Key key, this.title}) : super(key: key);

  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> with AutomaticKeepAliveClientMixin{

  double _width = 400;

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
    // setState(() {
    //   _width = MediaQuery.of(context).size.width;
    // });
    String userName = user == null ? "未命名" : user.name;
    String profileUrl = user == null ? 'images/icons/user.png' : user.avatar;

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SettingPage(user: user,),
              ));
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
              child: Flexible(
                child: Text(
                  userName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 18.0),
                ),
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
      body: 
        ListView(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
              child:  _topHeader0(),
            ),
            // _actionList(),
            FListTile('images/icons/unlock_gray.png', '已公开记录', (){
              print('public clicked');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return PublisPostsPage();
                }) 
              );
            }),
            FListTile('images/icons/lock_gray.png', '私有记录', (){
              print('private clicked');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return PrivatePostsPage();
                }) 
              );
            }),
            FListTile('images/icons/sync_failed_gray.png', '未发布记录', (){
              print('local clicked');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return LocalPostsPage();
                }) 
              );
            }),
            FListTile('images/icons/comment_gray.png', '鉴定意见', (){
              print('comments clicked');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return PostsOfCommentsPage();
                }) 
              );
            }),
          ]
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
    String roleName = user == null ? '未知角色' : user.roleName;

    return SizedBox(
      width: _width * (1 - 2 * MARGIN),
      child: Card(
        elevation: 5.0,
        color: Colors.white60,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14.0))),
        margin: EdgeInsets.all(10),
        // shadowColor: Colors.green,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${roleName}', 
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
              Text('自${user.created.year}年${user.created.month}月${user.created.day}日加入fossil hunter以来，',textAlign: TextAlign.start,),
              Text('录入 ${user.postsCount} 标本条，',textAlign: TextAlign.start,),
              Text('涉及分类单元 ${user.categoriesCount} 个， ',textAlign: TextAlign.start,),
              Text('发表鉴定意见 ${user.commentsCount} 条',textAlign: TextAlign.start,),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topHeader10(){
    String userName = user == null ? "未命名" : user.name;
    String userEmail = user == null ? '' : user.email;
    String roleName = user == null ? '未知角色' : user.roleName;

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
                 child: Text('${roleName}', 
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

  Widget _actionList(){
    // var items = [
    //   FListTile('images/icons/unlock_gray.png', '已公开记录', (){
    //     print('public clicked');
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(builder: (BuildContext context) {
    //         return PublisPostsPage();
    //       }) 
    //     );
    //   }),
    //   FListTile('images/icons/lock_gray.png', '私有记录', (){
    //     print('private clicked');
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(builder: (BuildContext context) {
    //         return PrivatePostsPage();
    //       }) 
    //     );
    //   }),
    //   FListTile('images/icons/sync_failed_gray.png', '未发布记录', (){
    //     print('local clicked');
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(builder: (BuildContext context) {
    //         return LocalPostsPage();
    //       }) 
    //     );
    //   }),
    //   FListTile('images/icons/comment_gray.png', '鉴定意见', (){
    //     print('comments clicked');
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(builder: (BuildContext context) {
    //         return PostsOfCommentsPage();
    //       }) 
    //     );
    //   })
    // ];
    // return ListView.separated(
    //   itemBuilder: (BuildContext context, int index){
    //      return items[index];
    //   }, 
    //   separatorBuilder: (context, index) => Divider(
    //     height: 30,
    //   ),  
    //   itemCount: 4);
    return Column(
      children: <Widget>[
        FListTile('images/icons/unlock_gray.png', '已公开记录', (){
          print('public clicked');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) {
              return PublisPostsPage();
            }) 
          );
        }),
        FListTile('images/icons/lock_gray.png', '私有记录', (){
          print('private clicked');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) {
              return PrivatePostsPage();
            }) 
          );
        }),
        FListTile('images/icons/sync_failed_gray.png', '未发布记录', (){
          print('local clicked');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) {
              return LocalPostsPage();
            }) 
          );
        }),
        FListTile('images/icons/comment_gray.png', '鉴定意见', (){
          print('comments clicked');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) {
              return PostsOfCommentsPage();
            }) 
          );
        }),
      ],
    );
  }
}