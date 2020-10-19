import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fossils_finder/api/post_api.dart';
import 'package:fossils_finder/api/service_method.dart';
import 'package:fossils_finder/config/global_config.dart';
import 'package:fossils_finder/model/post.dart';
import 'package:fossils_finder/pages/list/custom_list_item.dart';
import 'package:fossils_finder/pages/list/post_detail.dart';
import 'package:fossils_finder/test/swiper/swiper_test.dart';

class CategoryListView extends StatefulWidget {

  final String title;

  

  const CategoryListView({Key key, this.title}) : super(key: key);
  
  @override
  _CategoryListViewState createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView>  with AutomaticKeepAliveClientMixin{

  List<Post> posts = new List<Post>();
  
  Future loadPostListFromServer() async{
    var _content = await request(servicePath['posts']);
    var _jsonData = jsonDecode(_content.toString());
    print('get json data is  ${_jsonData}');
    var _listJson = _jsonData['data']['data'];
    List _jsonList = _listJson as List;
    // print('first item of list is ${_jsonList[0]}');
    List<Post> postList = _jsonList.map((item) => Post.fromJson(item)).toList();
    setState(() {
      posts = postList;
    });
  }

  Future loadPostList() async{
    PostService.getPost();
    String _content = await rootBundle.loadString('assets/data/posts.json');
    List _jsonContent = json.decode(_content);
    print("after json decode list size is: ${_jsonContent}"); //OK
    print(_jsonContent[0]);
    List<Post> postList = _jsonContent.map((item) => Post.fromJson(item)).toList();
    setState(() {
      posts = postList;
    });
  }

  @override
  void initState() {
    print("category page init state called");
    loadPostListFromServer();
    // loadPostList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (BuildContext context, int index){
          Post post = posts[index];

          return InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return PostDetailPage(post: post,);
                  // return SwiperTestPage(post: post,);
                }) 
              );
            },
            child: CustomListItem(
              user: post.author,
              viewCount: post.id,
              thumbnail: Container(
                decoration: const BoxDecoration(color: Colors.blue),
                child: post.images.length > 0 ? (post.images[0].url.startsWith('http')? Image.network(post.images[0].url) : Image.asset(post.images[0].url)) : Text('NO IMAGE'),
              ),
              title: post.title,
            ),
          );
        }, 
        separatorBuilder: (context, index) => Divider(
          height: 50,
        ), 
        itemCount: posts?.length
    );
  }

  @override
  bool get wantKeepAlive => true;
}