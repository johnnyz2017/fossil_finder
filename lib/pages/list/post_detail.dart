import 'dart:convert';

import 'package:flutter/material.dart';
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
  // Future<Post> post;
  Post post;

  Future loadPostFromServer() async{
    var _content = await request('${serviceUrl}/api/v1/posts/${widget.pid}');
    var _jsonData = jsonDecode(_content.toString());
    print('get json data is  ${_jsonData}');
    var _postJson = _jsonData['data'];
    Post _post = Post.fromJson(_postJson);
    setState(() {
      post = _post;
    });
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
    // return StreamBuilder(
    //   builder: (context, snapshot){
    //     return Column(
    //       children: <Widget>[
    //         Center(child: Text("详情页面"),),
    //         Expanded(
    //           child: ListView.builder(
    //             itemBuilder: (_, index){
    //               return ListTile(title: Text('title'),);
    //             }
    //           ),
    //         )
    //     ],);
    //   },
    // ); 

    return Scaffold(
      appBar: AppBar(
        title: Text("详情页")
      ),
      body: ListView.builder(
        itemCount: post.comments.length + 2,
        itemBuilder: (BuildContext context, int index){
          if(index == 0){                                            // post content
            return Container(
              padding: EdgeInsets.all(5),
              child: Card(
                child: Column(
                  children: <Widget>[
                    Text(
                      post.title, 
                      style: TextStyle(
                        //backgroundColor: Colors.yellow, 
                        color: Colors.blue,
                        fontSize: 30,

                        ),
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      
                      child: Text(
                        post.content,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.lightBlue,

                        ),
                        textAlign: TextAlign.start,
                      ),
                    )
                  ],
                ),
              ),
            );


          }else if(index == post.comments.length + 1){     // submit button
            return Container(
              padding: EdgeInsets.all(5),
              child: RaisedButton(
                onPressed: (){
                  print('submit comment button clicked');

                  var ret = Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) {
                      //return CommentSubmitPage(post: post,);
                      return CommentUploadPage(post: post,);
                    }) 
                  );

                  if(ret == true){
                    print('post OKKK');
                    loadPostFromServer();
                  }

                  // AmapService.navigateDrive(LatLng(36.547901, 104.258354));
                },
                child: Text('发表评论'),
                textColor: Colors.green,
              ),
            );


          }else{                                                  // comments
            return Container(
              padding: EdgeInsets.all(5),
              child: Card(
                child: Text('评论 ${index}'),
              ),
            );


          }
        }),
    );
  }
}