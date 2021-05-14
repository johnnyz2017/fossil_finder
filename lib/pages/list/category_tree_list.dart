import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_treeview/tree_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fossils_finder/api/service_method.dart';
import 'package:fossils_finder/config/global_config.dart';
import 'package:fossils_finder/model/category.dart';
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

class CategoryTreeListView extends StatefulWidget {
  @override
  _CategoryTreeListViewState createState() => _CategoryTreeListViewState();
}

class _CategoryTreeListViewState extends State<CategoryTreeListView> {

  List<Map<String, dynamic>> _categories_list = [{
    "id": 0,
    "parent_id": null,
    "label": "root",
    "description": "root",
    "key": "0",
    "children": [{
      "id": 4,
      "parent_id": 0,
      "label": "Category velit",
      "description": "Qui assumenda aut harum placeat.",
      "key": "4",
      "children": [{
        "id": 2,
        "parent_id": 4,
        "label": "Category vel",
        "description": "Quo temporibus sapiente sit est quaerat numquam.",
        "key": "2",
        "children": [{
          "id": 6,
          "parent_id": 2,
          "label": "Category fuga",
          "description": "Velit dolorum libero in eius ut quisquam.",
          "key": "6",
          "children": [{
            "id": 10,
            "parent_id": 6,
            "label": "Category adipisci",
            "description": "Vero dicta est et voluptatem ut est.",
            "key": "10",
            "children": []
          }]
        }]
      }, {
        "id": 3,
        "parent_id": 4,
        "label": "Category impedit",
        "description": "Numquam vel qui et ut.",
        "key": "3",
        "children": []
      }]
    }, {
      "id": 5,
      "parent_id": 0,
      "label": "Category animi",
      "description": "Eum necessitatibus aut dolorem sunt dolorum.",
      "key": "5",
      "children": [{
        "id": 7,
        "parent_id": 5,
        "label": "Category officiis",
        "description": "Aspernatur a a id ut dolorem.",
        "key": "7",
        "children": []
      }, {
        "id": 8,
        "parent_id": 5,
        "label": "Category quia",
        "description": "Sapiente dolor sunt velit quo.",
        "key": "8",
        "children": [{
          "id": 9,
          "parent_id": 8,
          "label": "Category voluptatem",
          "description": "Quaerat harum debitis fugit sequi.",
          "key": "9",
          "children": [{
            "id": 1,
            "parent_id": 9,
            "label": "Category excepturi",
            "description": "A pariatur molestias sit suscipit temporibus.",
            "key": "1",
            "children": []
          }]
        }]
      }]
    }]
  }];

  TreeViewController _treeViewController = TreeViewController(children: nodes);
  CategoryNode _node;

  ExpanderPosition _expanderPosition = ExpanderPosition.start;
  ExpanderType _expanderType = ExpanderType.caret;
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
      // String categoriesJson = jsonEncode(_jsonData['data']['children']);
      // _treeViewController = _treeViewController.loadJSON(json: categoriesJson);
    });
  }

  @override
  void initState() {
    loadCategoriesFromServer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TreeViewTheme _treeViewTheme = TreeViewTheme(
      expanderTheme: ExpanderThemeData(
        // type: _expanderType,
        // modifier: _expanderModifier,
        type: ExpanderType.plusMinus,
        modifier: ExpanderModifier.none,
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

    return Column(
      children: <Widget>[
        // RaisedButton(
        //   child: Text('Reload'),
        //   onPressed: (){
        //     loadCategoriesFromServer();
        //   },
        // ),
        Expanded(
          child: Container(
            child: TreeView(
              theme: _treeViewTheme,
              controller: _treeViewController,
              allowParentSelect: false,
              supportParentDoubleTap: false,
              // onExpansionChanged: _expandNodeHandler,
              onNodeTap: (key) {
                debugPrint('Selected: $key');
                setState(() {
                  _treeViewController =
                      _treeViewController.copyWith(selectedKey: key);
                });

                var _key = "${key}";
                String type = _key.split('_')[0];
                if(type.isEmpty || type == "c") return;
                
                int pid = int.parse(_key.split('_')[1]);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return PostDetailPage(pid: pid,);
                  }) 
                );
              },
              onNodeDoubleTap: (key){
                debugPrint('double tap on ${key}');
              },
              onExpansionChanged: (key, expanded){
                print('key : ${key}  expanded: ${expanded}');

                setState(() {
                  _treeViewController =
                      _treeViewController.copyWith(selectedKey: key);
                });
              }
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
