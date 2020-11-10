import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fossils_finder/api/service_method.dart';
import 'package:fossils_finder/config/global_config.dart';
import 'package:fossils_finder/model/post.dart';
import 'package:fossils_finder/pages/list/custom_list_item.dart';
import 'package:fossils_finder/pages/list/post_detail.dart';
import 'package:fossils_finder/pages/profile/post_editable_page.dart';

class PrivatePostsPage extends StatefulWidget {
  @override
  _PrivatePostsPageState createState() => _PrivatePostsPageState();
}

class _PrivatePostsPageState extends State<PrivatePostsPage> {

  List<Post> posts = new List<Post>();
  final ScrollController scrollController = ScrollController();

  Future loadPostListFromServer() async{
    var _content = await request(servicePath['unpublishedposts']);
    var _jsonData = jsonDecode(_content.toString());
    var _listJson;
    if(_jsonData['paginated']){
      _listJson = _jsonData['data']['data'];
    }
    else{
      _listJson = _jsonData['data'];
    }
    // print('get json data is  ${_jsonData}');
    
    List _jsonList = _listJson as List;
    List<Post> postList = _jsonList.map((item) => Post.fromJson(item)).toList();
    setState(() {
      posts = postList;
    });
  }

  @override
  void initState() {
    super.initState();

    loadPostListFromServer();
    scrollController.addListener(() { 
      if(scrollController.position.maxScrollExtent == scrollController.offset){
        print('try to load more or others');
        // loadPostListFromServer();
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('未公开'),
      ),
      body: ListView.separated(
          controller: scrollController,
          itemBuilder: (BuildContext context, int index){
            Post post = posts[index];

            return InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return PostEditblePage(post: post,);
                  }) 
                );
              },
              child: CustomListItem(
                user: post.author,
                viewCount: post.comments.length,
                thumbnail: Container(
                  decoration: const BoxDecoration(color: Colors.blue),
                  child: post.images.length > 0 ? (post.images[0].url.startsWith('http')? Image.network(post.images[0].url) : Image.asset(post.images[0].url)) : Text('NO IMAGE'),
                ),
                title: post.title,
              ),
            );
          }, 
          separatorBuilder: (context, index) => Divider(
            height: 30,
          ), 
          itemCount: posts?.length ?? 0
      )
    );
  }
}