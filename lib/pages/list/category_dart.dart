import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fossils_finder/model/post.dart';
import 'package:fossils_finder/pages/list/custom_list_item.dart';
import 'package:fossils_finder/pages/list/post_detail.dart';

class CategoryPage extends StatefulWidget {

  final String title;

  

  const CategoryPage({Key key, this.title}) : super(key: key);
  
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>  with AutomaticKeepAliveClientMixin{

  List<Post> posts = new List<Post>();
  // var posts = const [];

  Future loadPostList() async{
    String _content = await rootBundle.loadString('assets/data/posts.json');
    // print("load string: ${_content}"); //OK
    List _jsonContent = json.decode(_content);
    print("after json decode list size is: ${_jsonContent.length}"); //OK
    print(_jsonContent[0]);
    List<Post> postList = _jsonContent.map((item) => Post.fromJson(item)).toList();
    print('#####load post list ${postList.length}');
    setState(() {
      posts = postList;
    });
  }

  @override
  void initState() {
    print("category page init state called");
    loadPostList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.separated(
        itemBuilder: (BuildContext context, int index){
          Post post = posts[index];

          return InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return PostDetailPage(post: post,);
                }) 
              );
            },
            child: CustomListItem(
              user: post.author,
              viewCount: post.id,
              thumbnail: Container(
                decoration: const BoxDecoration(color: Colors.blue),
                child: Image.asset(post.images[0].url),
              ),
              title: post.title,
            ),
          );
        }, 
        separatorBuilder: (context, index) => Divider(), 
        itemCount: posts?.length
      ),
      // body: ListView.separated(
      //   itemBuilder: (BuildContext context, int index){
      //     Post post = posts[index];

      //     return ListTile(
      //       title: Text(post.title),
      //       isThreeLine: true,
      //       //leading: CircleAvatar(child: Text(post.author.substring(0, 1)),), //use the first character
      //       // leading: CircleAvatar(child: Image.asset(post.images[0].url),),
      //       leading: Image.asset(post.images[0].url),
      //       subtitle: Text(
      //         post.content,
      //         maxLines: 2,
      //         overflow: TextOverflow.ellipsis,
      //       ),
      //       onTap: (){
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (BuildContext context) {
      //             return PostDetailPage(post: post,);
      //           }) 
      //         );
      //       },
      //     );
      //   }, 
      //   separatorBuilder: (context, index) => Divider(), 
      //   // itemCount: posts == null? 0 : posts.length
      //   itemCount: posts?.length,

      // ),

      // body: ListView(
      //   padding: const EdgeInsets.all(8.0),
      //   itemExtent: 106.0,
      //   children: <CustomListItem>[
      //     CustomListItem(
      //       user: 'Flutter',
      //       viewCount: 999000,
      //       thumbnail: Container(
      //         decoration: const BoxDecoration(color: Colors.blue),
      //       ),
      //       title: 'The Flutter YouTube Channel',
      //     ),
      //     CustomListItem(
      //       user: 'Dash',
      //       viewCount: 884000,
      //       thumbnail: Container(
      //         decoration: const BoxDecoration(color: Colors.yellow),
      //       ),
      //       title: 'Announcing Flutter 1.0',
      //     ),
      //   ],
      // ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}