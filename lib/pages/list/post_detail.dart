import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fossils_finder/api/service_method.dart';
import 'package:fossils_finder/config/global_config.dart';
import 'package:fossils_finder/model/post.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fossils_finder/pages/form/comment_upload.dart';
import 'package:fossils_finder/pages/list/comment_submit.dart';

// import 'package:amap_map_fluttify/amap_map_fluttify.dart';

class PostDetailPage extends StatefulWidget {
  final int pid;

  const PostDetailPage({Key key, this.pid}) : super(key: key);
  
  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  Post post;

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
        // actions: <Widget>[
        //   IconButton(
        //     // icon: ,
        //     onPressed: (){},
        //   )
        // ],
      ),
      body: ListView.builder(
        itemCount: post.comments.length + 1,
        itemBuilder: (BuildContext context, int index){
          if(index == 0){                                            // post content
            return Container(
              padding: EdgeInsets.all(5),
              child: Card(
                child: Column(
                  children: <Widget>[
                    // Text(
                    //   post.title, 
                    //   style: TextStyle(
                    //     //backgroundColor: Colors.yellow, 
                    //     color: Colors.blue,
                    //     fontSize: 30,
                    //   ),
                    // ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text('鉴定类别: ${post.title}',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 25
                            ),                          
                          ),
                        ),
                        RaisedButton(
                          child: Text('添加鉴定'),
                          onPressed: (){
                            print('submit comment button clicked');

                            var ret = Navigator.push(
                              context,
                              MaterialPageRoute(builder: (BuildContext context) {
                                //return CommentSubmitPage(post: post,);
                                return CommentUploadPage(post: post,);
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
                              return new Image.network(url, fit: BoxFit.fitHeight);
                            }else{
                              return new Image.asset(url, fit:BoxFit.fitHeight);
                            }
                          },
                          itemCount: post.images.length > 0 ? post.images.length : 0,
                          pagination: new SwiperPagination(),
                          control: new SwiperControl(),
                        )
                        :
                        Text('无图片'),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Card(
                      child: Column(children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text('采集地点: '),
                              Expanded(child: Text('${post.coordinateLongitude}, ${post.coordinateLatitude}'),),
                              IconButton(
                                icon: Icon(Icons.gps_fixed),
                                onPressed: (){
                                  print('采集地点 clicked');
                                },
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 5)),
                          Row(
                            children: <Widget>[
                              Text('采集地址: '),
                              Expanded(child: Text('${post.address}'),)
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 5)),
                          Row(
                            children: <Widget>[
                              Text('临时标本号: '),
                              Expanded(child: Text('${post.tempId}'),)
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 5)),
                          Row(
                            children: <Widget>[
                              Text('永久标本号: '),
                              Expanded(child: Text('${post.permId}'),)
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 5)),
                          Row(
                            children: <Widget>[
                              Text('采集时间: '),
                              Expanded(child: Text('${post.createdAt.toString()}'),)
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 5)),
                          Row(
                            children: <Widget>[
                              Text('详细描述: '),
                              Expanded(child: Text('${post.content}'),)
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(top: 10)),
                      ],),
                    ),
                    // Padding(padding: EdgeInsets.only(top: 10)),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                      
                    //   child: Text(
                    //     post.content,
                    //     style: TextStyle(
                    //       fontSize: 20,
                    //       color: Colors.lightBlue,

                    //     ),
                    //     textAlign: TextAlign.start,
                    //   ),
                    // )
                  ],
                ),
              ),
            );


          }
          // else if(index == post.comments.length + 1){     // submit button
          //   return Container(
          //     padding: EdgeInsets.all(5),
          //     child: RaisedButton(
          //       onPressed: (){
          //         print('submit comment button clicked');

          //         var ret = Navigator.push(
          //           context,
          //           MaterialPageRoute(builder: (BuildContext context) {
          //             //return CommentSubmitPage(post: post,);
          //             return CommentUploadPage(post: post,);
          //           }) 
          //         );

          //         ret.then((value){
          //           print('return from navi : ${value}');
          //           if(value == true){
          //             loadPostFromServer();
          //           }
          //         });
          //         // AmapService.navigateDrive(LatLng(36.547901, 104.258354));
          //       },
          //       child: Text('发表评论'),
          //       textColor: Colors.green,
          //     ),
          //   );
          // }
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
                    child: Text('鉴定类别： ${post.comments[index-1].title}'),
                    onTap: (){
                      print('鉴定类别 clicked');
                    },
                  ),
                  subtitle: Text(post.comments[index-1].content),
                ),
              ),
            );
          }
        }),
    );
  }
}