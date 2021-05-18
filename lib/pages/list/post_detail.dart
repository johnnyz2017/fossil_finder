import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fossils_finder/api/service_method.dart';
import 'package:fossils_finder/config/global_config.dart';
import 'package:fossils_finder/model/post.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fossils_finder/pages/form/comment_upload.dart';
import 'package:fossils_finder/pages/list/comment_submit.dart';
import 'package:fossils_finder/config/global_config.dart';

import 'package:fossils_finder/pages/map/map_show.dart';
import 'package:fossils_finder/utils/local_info_utils.dart';
import 'package:fossils_finder/utils/qr_generate_page.dart';
import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:fossils_finder/widgets/image_detail_widget.dart';
import 'package:share/share.dart';
// import 'package:amap_map_fluttify/amap_map_fluttify.dart';

import 'package:easy_localization/easy_localization.dart';

class PostDetailPage extends StatefulWidget {
  final int pid;

  const PostDetailPage({Key key, this.pid}) : super(key: key);
  
  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  Post post;
  int userId = -1;

  Future loadUserID() async {
    int i = await getUserId();
    setState(() {
      userId = i;
    });
  }

  Future loadPostFromServer() async{
    var _content = await request('${serviceUrl}/api/v1/posts/${widget.pid}');
    var _jsonData = jsonDecode(_content.toString());
    print('get json data is  ${_jsonData}');
    var status = _jsonData['code'] as int;
    if(status == 200){
      var _postJson = _jsonData['data'];
      Post _post = Post.fromJson(_postJson);
      setState(() {
        post = _post;
      });
    }else{
      print('no post get, return');
      Fluttertoast.showToast(
        msg: "获取记录失败，请检查网络或者记录ID是否正确",
        gravity: ToastGravity.CENTER,
        textColor: Colors.red);
      Navigator.pop(context, true);
    }
    
  }

  @override
  void initState() {
    super.initState();
    loadUserID();
    loadPostFromServer();
  }
  
  @override
  Widget build(BuildContext context) {
    if(post == null){
      return Center(child: CircularProgressIndicator());
    }
   
    return Scaffold(
      appBar: AppBar(
        title: Text("详情页"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: (){
              String content = '${serviceUrl}/post/${post.id}';
              Share.share('记录链接分享： ${content}');
            },
          ),
          IconButton(
            icon: new Image.asset(
              'images/icons/qrcode_check_gray.png',
              width: 21,
              height: 21,
              fit: BoxFit.fill
            ),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return QrCodeGeneratePage(qrString: '${serviceUrl}/posts/${post.id}',);
                }) 
              );
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: post.comments.length + 1,
        itemBuilder: (BuildContext context, int index){
          if(index == 0){                                            // post content
            return Container(
              padding: EdgeInsets.all(20),
              child: Card(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text('鉴定类别: ${post.categoryName}',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 25
                            ),                          
                          ),
                        ),
                        RaisedButton(
                          color: Colors.white70,
                          textColor: Colors.black87,
                          child: Text('添加鉴定'),
                          onPressed: (){
                            print('submit comment button clicked');

                            var ret = Navigator.push(
                              context,
                              MaterialPageRoute(builder: (BuildContext context) {
                                //return CommentSubmitPage(post: post,);
                                return CommentUploadPage(post: post, comment: null,);
                              }) 
                            );

                            ret.then((value){
                              print('return from navi : ${value}');
                              if(value == true){
                                loadPostFromServer();
                              }
                            });
                          },
                        )
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Container(
                      height: 200,
                      child:
                        post.images != null ? 
                        new Swiper(
                          itemBuilder: (BuildContext context,int index){
                            String url = post.images[index].url;
                            if(url.startsWith('http')){
                              return Hero(
                                tag: 'imgHero${index}',
                                child: new Image.network(url, fit: BoxFit.fitHeight)
                              );
                            }else{
                              return Hero(
                                tag: 'imgHero${index}',
                                child: new Image.asset(url, fit:BoxFit.fitHeight)
                              );
                            }
                          },
                          itemCount: post.images.length > 0 ? post.images.length : 0,
                          pagination: new SwiperPagination(),
                          control: new SwiperControl(),
                          onTap: (index)  async {
                            Navigator.push(context, MaterialPageRoute(builder: (_) {
                              return ImageDetailScreen(url: post.images[index].url);
                            }));
                          },
                        )
                        :
                        Text('无图片'),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Card(
                      child: Column(children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text('记录标题: '),
                              Expanded(child: Text('${post.title}'),)
                            ],
                          ),
                          // Padding(padding: EdgeInsets.only(top: 10)),
                          Row(
                            children: <Widget>[
                              Text('采集地点: '),
                              Expanded(child: Text('${post.coordinateLongitude}, ${post.coordinateLatitude}'),),
                              IconButton(
                                iconSize: 21,
                                icon: Image.asset(
                                  'images/icons/target_gray.png',
                                  width: 21,
                                  height: 21,
                                  fit: BoxFit.fill
                                ),
                                onPressed: () async{
                                  print('采集地点 clicked');
                                  var pos = await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (BuildContext context) {
                                      return MapShowPage(coord: LatLng(post.coordinateLatitude, post.coordinateLongitude));
                                    })
                                  );
                                  print('pos get: $pos');
                                },
                              )
                            ],
                          ),
                          // Padding(padding: EdgeInsets.only(top: 2)),
                          Row(
                            children: <Widget>[
                              Text('采集地址: '),
                              Expanded(child: Text('${post.address}'),)
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 2)),
                          Row(
                            children: <Widget>[
                              Text('临时标本号: '),
                              Expanded(child: Text('${post.tempId}'),)
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 2)),
                          Row(
                            children: <Widget>[
                              Text('永久标本号: '),
                              Expanded(child: Text('${post.permId}'),)
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 2)),
                          Row(
                            children: <Widget>[
                              Text('采集时间: '),
                              Expanded(child: Text('${DateFormat.yMd().add_jm().format(post.createdAt)}'),)
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 2)),
                          Row(
                            children: <Widget>[
                              Text('详细描述: '),
                              Expanded(child: Text('${post.content}'),)
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 2)),
                      ],),
                    ),
                  ],
                ),
              ),
            );
          }
          else{                                                  // comments
            return Container(
              padding: EdgeInsets.all(5),
              child: Card(
                child: ListTile(
                  leading: Column(
                    children: <Widget>[
                      Icon(Icons.account_circle),
                      Text(post.comments[index-1].author)
                    ],
                  ),
                  title: InkWell(
                    child: Text('鉴定类别： ${post.comments[index-1].categoryName}'),
                    onTap: (){
                      print('鉴定类别 clicked');
                    },
                  ),
                  subtitle: Text(post.comments[index-1].content),
                  trailing: Visibility(
                    visible: post.comments[index-1].userId == userId,
                    child: InkWell(
                      child: Icon(Icons.edit,),
                      onTap: (){
                        print('post comment: ${post.comments[index-1]}');

                        var ret = Navigator.push(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) {
                            //return CommentSubmitPage(post: post,);
                            return CommentUploadPage(post: post, comment: post.comments[index-1],editmode: true,);
                          }) 
                        );

                        ret.then((value){
                          print('return from navi : ${value}');
                          if(value == true){
                            loadPostFromServer();
                          }
                        });
                      },
                    ),
                  ),
                ),
              ),
            );
          }
        }),
    );
  }
}