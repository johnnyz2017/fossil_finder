import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_treeview/tree_view.dart';
import 'package:fossils_finder/api/service_method.dart';
import 'package:fossils_finder/config/global_config.dart';
import 'package:fossils_finder/model/category.dart';
import 'package:fossils_finder/model/post.dart';
import 'package:fossils_finder/pages/list/custom_list_item.dart';
import 'package:fossils_finder/pages/list/post_detail.dart';
import 'package:fossils_finder/pages/login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';


List<Node> nodes = [
  Node(
    label: 'Documents',
    key: 'docs',
    expanded: true,
    icon: NodeIcon(
      codePoint:Icons.folder_open.codePoint,
          // docsOpen ? Icons.folder_open.codePoint : Icons.folder.codePoint,
      color: "blue",
    ),
    children: [
      Node(
          label: 'Job Search',
          key: 'd3',
          icon: NodeIcon.fromIconData(Icons.input),
          children: [
            Node(
                label: 'Resume.docx',
                key: 'pd1',
                icon: NodeIcon.fromIconData(Icons.insert_drive_file)),
            Node(
                label: 'Cover Letter.docx',
                key: 'pd2',
                icon: NodeIcon.fromIconData(Icons.insert_drive_file)),
          ]),
      Node(
        label: 'Inspection.docx',
        key: 'd1',
      ),
      Node(
          label: 'Invoice.docx',
          key: 'd2',
          icon: NodeIcon.fromIconData(Icons.insert_drive_file)),
    ],
  ),
  // Node(
  //     label: 'MeetingReport.xls',
  //     key: 'mrxls',
  //     icon: NodeIcon.fromIconData(Icons.insert_drive_file)),
  // Node(
  //     label: 'MeetingReport.pdf',
  //     key: 'mrpdf',
  //     icon: NodeIcon.fromIconData(Icons.insert_drive_file)),
  // Node(
  //     label: 'Demo.zip',
  //     key: 'demo',
  //     icon: NodeIcon.fromIconData(Icons.archive)),
];

class CategoryTreeView extends StatefulWidget {
  @override
  _CategoryTreeViewState createState() => _CategoryTreeViewState();
}

class _CategoryTreeViewState extends State<CategoryTreeView> {
  List<Post> posts = new List<Post>();
  bool _loadingPost = false;
  final ScrollController scrollController = ScrollController();
  
  CategoryItem _category;

  TreeViewController _treeViewController = TreeViewController(children: nodes);
  CategoryNode _node;

  ExpanderPosition _expanderPosition = ExpanderPosition.start;
  ExpanderType _expanderType = ExpanderType.caret;
  ExpanderModifier _expanderModifier = ExpanderModifier.none;

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

  Future loadCategoriesOnlyFromServer() async{
    var _content = await request(servicePath['categorieswithoutposts']);
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

    print('get request content: ${_content}');
    var _jsonData = jsonDecode(_content.toString());
   
    setState(() {
      String categoriesJson = jsonEncode(_jsonData['data']['children']);
      _treeViewController = _treeViewController.loadJSON(json: categoriesJson);

      String deepKey = 'c_5';
      List<Node> newdata =
          _treeViewController.expandToNode(deepKey);
      _treeViewController =
          _treeViewController.copyWith(children: newdata);
    });
  }

  Future loadCategoriesFromServer() async{
    var _content = await request(servicePath['categorieswithposts']);
    // var _content = await request(servicePath['categorieswithoutposts']);
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

    print('get request content: ${_content}');
    var _jsonData = jsonDecode(_content.toString());

    setState(() {
      String categoriesJson = jsonEncode(_jsonData['data']['children']);
      _treeViewController = _treeViewController.loadJSON(json: categoriesJson);
    });
  }

  @override
  void initState() {
    loadCategoriesOnlyFromServer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TreeViewTheme _treeViewTheme = TreeViewTheme(
      expanderTheme: ExpanderThemeData(
        type: _expanderType,
        modifier: _expanderModifier,
        position: _expanderPosition,
        color: Colors.grey.shade800,
        size: 20,
      ),
      labelStyle: TextStyle(
        fontSize: 16,
        letterSpacing: 0.3,
      ),
      parentLabelStyle: TextStyle(
        fontSize: 16,
        letterSpacing: 0.1,
        fontWeight: FontWeight.w800,
        color: Colors.blue.shade700,
      ),
      iconTheme: IconThemeData(
        size: 18,
        color: Colors.grey.shade800,
      ),
      colorScheme: Theme.of(context).brightness == Brightness.light
          ? ColorScheme.light(
              primary: Colors.blue.shade50,
              onPrimary: Colors.grey.shade900,
              background: Colors.transparent,
              onBackground: Colors.black,
            )
          : ColorScheme.dark(
              primary: Colors.black26,
              onPrimary: Colors.white,
              background: Colors.transparent,
              onBackground: Colors.white70,
            ),
    );

    return Scaffold(
      appBar: AppBar(
        title: _category != null ? Text(_category.title) : Text('请选择分类'),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            // RaisedButton(
            //   child: Text('Reload'),
            //   onPressed: (){
            //     // loadCategoriesOnlyFromServer();
            //     getCategoryFromServer(10);
            //     Navigator.pop(context);
            //   },
            // ),
            Expanded(
              child: Container(
                child: TreeView(
                  theme: _treeViewTheme,
                  controller: _treeViewController,
                  allowParentSelect: true,
                  supportParentDoubleTap: false,
                  
                  // onExpansionChanged: _expandNodeHandler,
                  onNodeTap: (key) {
                    debugPrint('debug print select key: $key');
                    setState(() {
                      _treeViewController =
                          _treeViewController.copyWith(selectedKey: key);
                    });

                    var _key = "${key}";
                    String type = _key.split('_')[0];
                    if(type.isEmpty || type == "p") return;
                    
                    int cid = int.parse(_key.split('_')[1]);

                    print('${_key} - ${cid}');

                    getCategoryFromServer(cid);
                    setState(() {
                      _loadingPost = true;  
                    });
                    loadPostsViaCategoryFromServer(cid);

                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: _category == null ? Center(child:Text('滑动左侧分类菜单选择分类'))
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

  @override
  bool get wantKeepAlive => true;
}
