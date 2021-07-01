import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fossils_finder/api/service_method.dart';
import 'package:fossils_finder/config/global_config.dart';
import 'package:fossils_finder/model/post.dart';
import 'package:fossils_finder/pages/list/custom_list_item.dart';
import 'package:fossils_finder/pages/list/post_detail.dart';

class SharedPostsPage extends StatefulWidget {
  @override
  _SharedPostsPageState createState() => _SharedPostsPageState();
}

class _SharedPostsPageState extends State<SharedPostsPage> {
  List<Post> posts = new List<Post>();
  final ScrollController scrollController = ScrollController();

  Future loadPostListFromServer() async{
    var _content = await request(servicePath['sharedposts']); //publishedposts  //sharedposts
    var _jsonData = jsonDecode(_content.toString());
    var _listJson = _jsonData['data'];
    print('get json data is  ${_jsonData}');
    
    List _jsonList = _listJson as List;
    List<Post> postList = _jsonList.map((item) => Post.fromJson(item)).toList();
    // List<Post> postList = _jsonList.map((item) => print('item ${item}'));
    print('postList: ${postList}');
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
        title: Text('被共享记录'),
      ),
      body: ListView.separated(
          controller: scrollController,
          itemBuilder: (BuildContext context, int index){
            Post post = posts[index];

            return InkWell(
              onTap: () async{
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return PostDetailPage(pid: post.id,);
                  }) 
                );
                loadPostListFromServer();
              },
              child: CustomListItem(
                user: post.author,
                viewCount: post.comments.length,
                thumbnail: Container(
                  height: 130,
                  // decoration: const BoxDecoration(color: Colors.grey),
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