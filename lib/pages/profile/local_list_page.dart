import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fossils_finder/api/service_method.dart';
import 'package:fossils_finder/config/global_config.dart';
import 'package:fossils_finder/model/post.dart';
import 'package:fossils_finder/pages/list/custom_list_item.dart';
import 'package:fossils_finder/pages/profile/local_post_editable_page.dart';
import 'package:fossils_finder/utils/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class LocalPostsPage extends StatefulWidget {
  @override
  _LocalPostsPageState createState() => _LocalPostsPageState();
}

class _LocalPostsPageState extends State<LocalPostsPage> {
  DatabaseHelper dbhelper = DatabaseHelper();
  List<Post> posts = new List<Post>();
  final ScrollController scrollController = ScrollController();

  Future loadPostListFromDB() async{
    final Future<Database> dbFuture = dbhelper.initializeDatabase();
    dbFuture.then((db){
      print('after db init');

      Future<List<Post>> postListFuture = dbhelper.getPostList();
      postListFuture.then((postList) {
        print('get post list ${postList.length} ');
        setState(() {
          posts = postList;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadPostListFromDB();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('尚未发布记录'),
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
                    return LocalPostEditblePage(post: post,);
                  }) 
                );
                loadPostListFromDB();
              },
              child: CustomListItem(
                user: post.author != null ? post.author : 'no author got',
                // viewCount: post.comments.length,
                viewCount: 0,
                thumbnail: Container(
                  height: 100,
                  decoration: const BoxDecoration(color: Colors.grey),
                  child: post.images != null ? post.images.length > 0 ? (post.images[0].url.startsWith('http')? Image.network(post.images[0].url) : Image.asset(post.images[0].url)) : Text('NO IMAGE')
                         : Text('No Image'),
                ),
                title: post.title != null ? post.title : 'no title got',
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