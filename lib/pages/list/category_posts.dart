import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fossils_finder/api/service_method.dart';
import 'package:fossils_finder/config/global_config.dart';
import 'package:fossils_finder/model/category.dart';
import 'package:fossils_finder/model/post.dart';
import 'package:fossils_finder/pages/list/custom_list_item.dart';
import 'package:fossils_finder/pages/list/post_detail.dart';
import 'package:fossils_finder/pages/login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryPostsPage extends StatefulWidget {
  final int cid;

  const CategoryPostsPage({Key key, this.cid}) : super(key: key);
  
  @override
  _CategoryPostsPageState createState() => _CategoryPostsPageState();
}

class _CategoryPostsPageState extends State<CategoryPostsPage> {
  List<Post> posts = new List<Post>();
  CategoryItem _category;
  bool _loadingPost = false;
  final ScrollController scrollController = ScrollController();

  Future getCategoryFromServer(int cid) async{
    var _content = await request(servicePath['categories'] + '/${cid}');
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
      return null;
    }

    print('get request content: ${_content}');
    var _jsonData = jsonDecode(_content.toString());
   
    setState(() {
      // String categoryJson = jsonEncode(_jsonData['data']);
      _category = CategoryItem.fromJson(_jsonData['data']);
    });

    return _category;
  }

  Future loadPostsViaCategoryFromServer(int cid) async{
    var _content = await request(servicePath['categories'] + '/${cid}/posts');
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
      _loadingPost = false;
      posts = postList;
    });
    print('after get posts ${posts.length} - ${scrollController.offset}');
  }
  
  @override
  void initState() {
    super.initState();
    getCategoryFromServer(widget.cid);
    loadPostsViaCategoryFromServer(widget.cid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _category != null ? Text(_category.title) : Text('加载中......'), //Text('${_category.title}'),
      ),
      body: _category == null ? Center(child:Text('加载中...'))
            : ListView.separated(
                controller: scrollController,
                itemBuilder: (BuildContext context, int index){
                  if(posts.length == 0){
                    if(_loadingPost) //loading
                      return Container(
                        decoration: new BoxDecoration(
                          color: Colors.grey,
                        ),
                        padding: const EdgeInsets.all(30.0),
                        alignment: Alignment.center,
                        child: CircularProgressIndicator());
                    else
                      return Container(
                        decoration: new BoxDecoration(
                          color: Colors.grey,
                        ),
                        padding: const EdgeInsets.all(30.0),
                        alignment: Alignment.center,
                        child: Text('无记录'));
                  }
                  Post post = posts[index];

                  return InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) {
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
            ),
    );
  }
}