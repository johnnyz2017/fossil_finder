import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fossils_finder/api/post_api.dart';
import 'package:fossils_finder/api/service_method.dart';
import 'package:fossils_finder/config/global_config.dart';
import 'package:fossils_finder/model/post.dart';
import 'package:fossils_finder/pages/list/custom_list_item.dart';
import 'package:fossils_finder/pages/list/post_detail.dart';
import 'package:fossils_finder/pages/login/login_page.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryListView extends StatefulWidget {

  final String title;

  

  const CategoryListView({Key key, this.title}) : super(key: key);
  
  @override
  _CategoryListViewState createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView>  with AutomaticKeepAliveClientMixin{

  List<Post> posts = new List<Post>();
  final ScrollController scrollController = ScrollController();
  bool _reloading = false;
  bool _loadingmore = false;

  Future loadPostListFromServer() async{
    var _content = await request(servicePath['posts']);
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
    print('after get posts ${posts.length} - ${scrollController.offset}');
    _reloading = false;
  }

  Future loadPostList() async{
    PostService.getPost();
    String _content = await rootBundle.loadString('assets/data/posts.json');
    List _jsonContent = json.decode(_content);
    // print("after json decode list size is: ${_jsonContent}"); //OK
    print(_jsonContent[0]);
    List<Post> postList = _jsonContent.map((item) => Post.fromJson(item)).toList();
    setState(() {
      posts = postList;
    });
    print('after loadpostlist');
    _reloading = false;
  }

  @override
  void initState() {
    // print("category page init state called");
    loadPostListFromServer();
    scrollController.addListener(() { 
      // print('scroll offset ${scrollController.offset}');
      if(scrollController.position.maxScrollExtent == scrollController.offset){
        //load more
        // posts.clear();
        // posts = null;
        print('try to load more or others');
        // loadPostListFromServer();
        // scrollController.animateTo(.0, duration: Duration(milliseconds: 200), curve: Curves.ease);
      }

      if(-20 > scrollController.offset){
        if(!_reloading){
          _reloading = true;
          scrollController.jumpTo(0);
          // scrollController.animateTo(0, duration: Duration(milliseconds: 0), curve: null);
          setState(() {
            posts.clear();
          });
          print('try to reload');
          loadPostListFromServer();
        }
      }
    });
    // loadPostList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(posts == null){
      return Center(child: CircularProgressIndicator());
    }

    return ListView.separated(
        controller: scrollController,
        itemBuilder: (BuildContext context, int index){
          if(posts.length == 0){
            return Center(child: CircularProgressIndicator());
          }
          Post post = posts[index];

          return InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) {
                  // return PostDetailPage(post: post,);
                  return PostDetailPage(pid: post.id,);
                }) 
              );
            },
            child: CustomListItem(
              user: post.author,
              viewCount: post.comments.length,
              thumbnail: Container(
                height: 100,
                decoration: const BoxDecoration(color: Colors.grey),
                child: post.images.length > 0 ? (post.images[0].url.startsWith('http')? Image.network(post.images[0].url) : Image.asset(post.images[0].url)) : Text('NO IMAGE'),
              ),
              title: post.title,
            ),
          );
        }, 
        separatorBuilder: (context, index) => Divider(
          height: 30,
        ), 
        itemCount: posts?.length > 0 ? posts.length : 1
    );
  }

  @override
  bool get wantKeepAlive => true;
}