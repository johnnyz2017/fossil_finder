import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_treeview/tree_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fossils_finder/api/service_method.dart';
import 'package:fossils_finder/config/global_config.dart';
import 'package:fossils_finder/model/category.dart';
import 'package:fossils_finder/model/post.dart';
import 'package:fossils_finder/pages/form/category_new.dart';
import 'package:fossils_finder/pages/form/category_update.dart';
import 'package:fossils_finder/pages/list/category_posts.dart';
import 'package:fossils_finder/pages/list/custom_list_item.dart';
import 'package:fossils_finder/pages/list/post_detail.dart';
import 'package:fossils_finder/pages/login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryTreeView extends StatefulWidget {
  @override
  _CategoryTreeViewState createState() => _CategoryTreeViewState();
}

class _CategoryTreeViewState extends State<CategoryTreeView> {
  List<Post> posts = new List<Post>();
  final ScrollController scrollController = ScrollController();  
  CategoryItem _category;

  TreeViewController _treeViewController = TreeViewController();
  CategoryNode cNode;
  bool editmode = false;
  // TreeViewController _treeViewController;
  bool docsOpen = true;
  bool deepExpanded = true;
  String _selectedNode;
  List<Node> _nodes;

  ExpanderPosition _expanderPosition = ExpanderPosition.start;
  ExpanderType _expanderType = ExpanderType.plusMinus;
  ExpanderModifier _expanderModifier = ExpanderModifier.none;

  Future<bool> editable(int id) async{
    bool editable = false;
    var _content = await request(servicePath['categories'] + '/$id/editable');
    print('get request content: ${_content}');
    var _jsonData = jsonDecode(_content.toString());
    int code = _jsonData['code'];
    if(code == 200)
      editable = true;
    return editable;
  }

  Future<bool> deleteable(int id) async{
    bool deleteable = false;
    var _content = await request(servicePath['categories'] + '/$id/deleteable');
    print('get request content: ${_content}');
    var _jsonData = jsonDecode(_content.toString());
    int code = _jsonData['code'];
    if(code == 200)
      deleteable = true;

    return deleteable;
  }

  Future<bool> deleteCategory(int id) async{
    SharedPreferences localStorage;
    localStorage = await SharedPreferences.getInstance();
    String _token = localStorage.get('token');

    BaseOptions baseOptions = BaseOptions(
      baseUrl: apiUrl,
      responseType: ResponseType.json,
      connectTimeout: 30000,
      receiveTimeout: 30000,
      validateStatus: (code) {
        if (code >= 200) {
          return true;
        }
        return false;
      },
      headers: {
        HttpHeaders.authorizationHeader : 'Bearer $_token'
      }
    );

    Dio dio = new Dio(baseOptions);
    Options options = Options(
        contentType: 'application/json',
        followRedirects: false,
        validateStatus: (status) { return status < 500; },
        headers: {
          HttpHeaders.authorizationHeader : 'Bearer $_token'
        }
    );

    print(apiUrl + servicePath['categories'] + '/$id');

    var respone = await dio.delete<String>(apiUrl + servicePath['categories'] + '/$id', options: options);
    
    print(respone);
    if (respone.statusCode == 200) {
      var responseJson = json.decode(respone.data);
      print('response: ${respone.data} - ${responseJson['message']}');

      var status = responseJson['code'] as int;
      if(status == 200){
        Fluttertoast.showToast(
            msg: "提交成功",
            gravity: ToastGravity.CENTER,
            textColor: Colors.grey);
        return true;
      }else{
        Fluttertoast.showToast(
            msg: "提交失败！",
            gravity: ToastGravity.CENTER,
            textColor: Colors.red);
        return false;
      }
    }else{
      Fluttertoast.showToast(
        msg: "网络连接失败，检查网络",
        gravity: ToastGravity.CENTER,
        textColor: Colors.red);
      return false;
    }
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
      // posts = postList;
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
    print('get children is: ${_jsonData['data']['children']}');
   
    setState(() {
      String categoriesJson = jsonEncode(_jsonData['data']['children']);
      print('cate json string is: ${categoriesJson}');
      _treeViewController = _treeViewController.loadJSON(json: categoriesJson);

      // String deepKey = 'c_5';
      // List<Node> newdata =
      //     _treeViewController.expandToNode(deepKey);
      // _treeViewController =
      //     _treeViewController.copyWith(children: newdata);
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
        color: Colors.grey.shade700,
        size: 20,
      ),
      labelStyle: TextStyle(
        fontSize: 16,
        letterSpacing: 0.1,
        fontWeight: FontWeight.w800,
        // color: Colors.blue.shade700,
        color: Colors.black,
      ),
      parentLabelStyle: TextStyle(
        fontSize: 16,
        letterSpacing: 0.1,
        fontWeight: FontWeight.w800,
        // color: Colors.blue.shade700,
        color: Colors.black,
      ),
      iconTheme: IconThemeData(
        size: 18,
        color: Colors.grey.shade700,
      ),
      colorScheme: Theme.of(context).brightness == Brightness.light
          ? ColorScheme.light(
              primary: Colors.blue.shade50,
              onPrimary: Colors.grey.shade900,
              background: Colors.transparent,
              onBackground: Colors.black,
              secondary: Colors.blue.shade50,
            )
          : ColorScheme.dark(
              primary: Colors.black26,
              onPrimary: Colors.white,
              background: Colors.transparent,
              onBackground: Colors.white70,
              secondary: Colors.black26,
            ),
    );

    return Scaffold(
      appBar: AppBar(
        // title: _category != null ? Text(_category.title) : Text('请选择分类'),
        title: editmode ? Text('编辑模式') : Text('选择分类查看'),
        actions: <Widget>[
          Visibility(
            visible: editmode,
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () async{
                debugPrint('modify clicked ${cNode.id}');
                if(cNode == null) return;
                bool _e = await editable(cNode.id);
                print('get editable result $_e');
                if(_e){
                  var ret = Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) {
                      return CategoryUpdatePage(categoryNode: cNode,);
                    }) 
                  );

                  ret.then((value){
                    print('return from navi : ${value}');
                    if(value == true){
                      loadCategoriesOnlyFromServer();
                    }
                  });
                }else{
                  Fluttertoast.showToast(
                    msg: "无法编辑该类别",
                    gravity: ToastGravity.CENTER,
                    textColor: Colors.red);
                }
              },
            ),
          ),
          Visibility(
            visible: editmode,
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: (){
                debugPrint('add clicked');
                var ret = Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return CategoryNewPage();
                  }) 
                );

                ret.then((value){
                  print('return from navi : ${value}');
                  if(value == true){
                    loadCategoriesOnlyFromServer();
                  }
                });
              },
            ),
          ),
          Visibility(
            visible: editmode,
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async{
                debugPrint('delete clicked ${cNode}');
                if(cNode == null) return;

                bool _e = await deleteable(cNode.id);
                print('get deleteable result $_e');
                if(_e){
                  showDialog(
                    context: context,
                    builder: (context){
                      return AlertDialog(
                        title: Text("提示信息"),
                        content: Text("您确定要删除吗"),
                        actions: <Widget>[
                          RaisedButton(
                            child: Text("取消"),
                            color: Colors.blue,
                            textColor: Colors.white,
                            onPressed: (){
                              print("取消");
                              Navigator.pop(context);
                            },
                          ),
                          RaisedButton(
                            child: Text("确定"),
                            color: Colors.blue,
                            textColor: Colors.white,
                            onPressed: ()async{
                              print("确定");
                              Navigator.pop(context,"ok");
                              var ret = await deleteCategory(cNode.id);
                              if(ret)
                                loadCategoriesOnlyFromServer();
                            },
                          ),
                        ],
                      );
                    }
                  );
                }else{
                  Fluttertoast.showToast(
                    msg: "无法删除该类别，请确认权限和该类别下是否无记录或者子类别",
                    gravity: ToastGravity.CENTER,
                    textColor: Colors.red);
                }
              },
            ),
          ),
          IconButton(
            icon: editmode ? Icon(Icons.done) : Icon(Icons.edit),
            onPressed: (){
              setState(() {
                editmode = !editmode;
                print('edit mode = ${editmode}');
              });
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 5),
              child: TreeView(
                theme: _treeViewTheme,
                controller: _treeViewController,
                allowParentSelect: true,
                supportParentDoubleTap: false,
                onExpansionChanged: (key, expanded) =>
                        _expandNode(key, expanded),
                onNodeTap: (key) {
                  debugPrint('debug print select key: $key');
                  String label = _treeViewController.getNode(key) == null
                                ? ''
                                : _treeViewController.getNode(key).label;

                  var _key = "${key}";
                  String type = _key.split('_')[0];
                  if(type.isEmpty || type == "p") return;
                  
                  int cid = int.parse(_key.split('_')[1]);

                  print('${_key} - ${cid}');
                  cNode = CategoryNode.fromJson({
                    "key" : "$key",
                    "title" : label,
                    'id' : cid
                  });
                  
                  setState(() {
                    _treeViewController =
                        _treeViewController.copyWith(selectedKey: key);
                  });

                  if(editmode) {
                    getCategoryFromServer(cid);
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) {
                      return CategoryPostsPage(cid:cid);
                    }) 
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  _expandNode(String key, bool expanded) {
    String msg = '${expanded ? "Expanded" : "Collapsed"}: $key';
    debugPrint(msg);
    Node node = _treeViewController.getNode(key);
    if (node != null) {
      List<Node> updated;
      if (key == 'docs') {
        updated = _treeViewController.updateNode(
          key,
          node.copyWith(
              expanded: expanded,
              icon: NodeIcon(
                codePoint: expanded
                    ? Icons.folder_open.codePoint
                    : Icons.folder.codePoint,
                color: expanded ? "blue600" : "grey700",
              )),
        );
      } else {
        updated = _treeViewController.updateNode(
            key, node.copyWith(expanded: expanded));
      }
      setState(() {
        if (key == 'docs') docsOpen = expanded;
        _treeViewController = _treeViewController.copyWith(children: updated);
      });
    }
  }

  @override
  bool get wantKeepAlive => true;
}
