import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_treeview/tree_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fossils_finder/api/service_method.dart';
import 'package:fossils_finder/config/global_config.dart';
import 'package:fossils_finder/model/category.dart';
import 'package:fossils_finder/pages/form/category_new.dart';
import 'package:fossils_finder/pages/form/category_update.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategorySelector extends StatefulWidget {
  final String treeJson;
  final bool editable;
  final int sid;

  const CategorySelector({Key key, this.editable = true, this.sid = -1, this.treeJson }) : super(key: key);

  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> with AutomaticKeepAliveClientMixin{
  String categoriesJson = '';
  TreeViewController _treeViewController = TreeViewController();
  CategoryNode cNode;

  ExpanderPosition _expanderPosition = ExpanderPosition.start;
  ExpanderType _expanderType = ExpanderType.caret;
  ExpanderModifier _expanderModifier = ExpanderModifier.none;

  bool editmode = false;

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

  Future loadCategoriesFromServer() async{
    var _content = await request(servicePath['categorieswithoutposts']);
    print('get request content: ${_content}');
    var _jsonData = jsonDecode(_content.toString());
    categoriesJson = jsonEncode(_jsonData['data']['children']);
    print('get json :  ${categoriesJson}');
   
    setState(() {
      _treeViewController = _treeViewController.loadJSON(json: categoriesJson);
    });
  }

  @override
  void initState() {
    loadCategoriesFromServer();
    super.initState();
    // if(widget.treeJson.isNotEmpty)
    //   _treeViewController = _treeViewController.loadJSON(json: widget.treeJson);
    // else
    //   loadCategoriesFromServer();

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
        title: Text("类别选择"),
        actions: <Widget>[
          Visibility(
            visible: widget.editable,
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: (){
                setState(() {
                  editmode = true;
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.done),
            onPressed: (){
              if(editmode){
                setState(() {
                  editmode = false;
                  // cNode = null;
                  // _treeViewController = _treeViewController.copyWith(selectedKey: null);
                });
              }else{
                if(cNode.id == widget.sid){
                  print('select wrong id ${cNode.id}');
                  Fluttertoast.showToast(
                    msg: "不能选择自己！",
                    gravity: ToastGravity.CENTER,
                    textColor: Colors.red);
                }
                else{
                  Navigator.pop(context, cNode);
                }
              }
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: TreeView(
                theme: _treeViewTheme,
                controller: _treeViewController,
                allowParentSelect: true,
                supportParentDoubleTap: false,
                onNodeTap: (key) {     
                  String label = _treeViewController.getNode(key) == null
                                ? ''
                                : _treeViewController.getNode(key).label;
                  
                  debugPrint('Selected: $key - $label');

                  String _type = key.split('_')[0];
                  int _cateId = -1;
                  if(_type.isNotEmpty || _type == "c"){
                    _cateId = int.parse(key.split('_')[1]);
                    print('got category id ${_cateId}');
                  }

                  cNode = CategoryNode.fromJson({
                    "key" : "$key",
                    "title" : label,
                    'id' : _cateId
                  });
                  setState(() {
                    _treeViewController =
                        _treeViewController.copyWith(selectedKey: key);
                  });
                  
                  if(editmode){
                    debugPrint('in edit mode');
                  } else{
                    debugPrint('not in edit mode');
                  }                
                },
                onNodeDoubleTap: (key){
                  debugPrint('double tap on ${key}');
                },
                // onExpansionChanged: (key, expanded){
                //   print('key : ${key}  expanded: ${expanded}');

                //   String label = _treeViewController.getNode(key) == null
                //                 ? ''
                //                 : _treeViewController.getNode(key).label;
                  
                //   debugPrint('Selected: $key - $label');
                //   _categoryController.text = label;

                //   cNode = CategoryNode.fromJson({
                //     "key" : "$key",
                //     "title" : label
                //   });
                //   setState(() {
                //     _treeViewController =
                //         _treeViewController.copyWith(selectedKey: key);
                //   });

                //   var _key = "${key}";
                //   String type = _key.split('_')[0];
                //   if(type.isEmpty || type == "c") return;
                  
                //   int pid = int.parse(_key.split('_')[1]);
                // }
              ),
            ),
          ),
          // Text('Current Selected: '),
          Visibility(
            visible: editmode,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton(
                  child: Text('添加'),
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
                        loadCategoriesFromServer();
                      }
                    });
                  }),
                  RaisedButton(
                  child: Text('修改'),
                  onPressed: editmode ? () async {
                    debugPrint('modify clicked');
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
                          loadCategoriesFromServer();
                        }
                      });
                      // setState(() {
                        // debugPrint('modify clicked create');
                        // var ll = _treeViewController.getNode('c_3').children;
                        // Node newNode = new Node(key: 'c_100', label: '测试节点及其子节点',children: ll, expanded: true);
                        
                        // _treeViewController = _treeViewController.withUpdateNode('c_3', newNode); //OK
                        // _treeViewController = _treeViewController.withCollapseToNode('c_100'); //OK

                        // _treeViewController = _treeViewController.withAddNode('c_10', newNode); //OK
                        // _treeViewController = _treeViewController.withCollapseToNode('c_100'); //OK
                        // _treeViewController = _treeViewController.withExpandToNode('c_100'); //OK

                        // print("${_treeViewController.getNode('c_100').children}");
                        // print("${_treeViewController.getNode('c_100').isParent}");
                        // print("${_treeViewController.getNode('c_3')}");
                      // });
                    }else{
                      Fluttertoast.showToast(
                        msg: "无法编辑该类别",
                        gravity: ToastGravity.CENTER,
                        textColor: Colors.red);
                    }
                    
                  } : null,
                  ),
                  RaisedButton(
                  child: Text('删除'),
                  onPressed: editmode ? () async {
                    debugPrint('delete clicked ${cNode}');

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
                                    loadCategoriesFromServer();
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
                    // if(_treeViewController.getNode(cNode.key).isParent){
                    //   print('current selected is ${cNode.key}-${cNode.label} is parent, can not be deleted');
                    // }
                  } : null,),
              ],
            ),
          ),
          SizedBox(height: 50,)
               
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}