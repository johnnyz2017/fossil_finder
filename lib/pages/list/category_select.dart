import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_treeview/tree_view.dart';
import 'package:fossils_finder/api/service_method.dart';
import 'package:fossils_finder/config/global_config.dart';
import 'package:fossils_finder/model/category.dart';

class CategorySelector extends StatefulWidget {
  final String treeJson;

  const CategorySelector({Key key, this.treeJson}) : super(key: key);

  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {

  TextEditingController _categoryController = TextEditingController();
  TreeViewController _treeViewController = TreeViewController();
  CategoryNode cNode;

  Future loadCategoriesFromServer() async{
    var _content = await request(servicePath['categorieswithoutposts']);
    print('get request content: ${_content}');
    var _jsonData = jsonDecode(_content.toString());
   
    setState(() {
      String categoriesJson = jsonEncode(_jsonData['data']['children']);
      _treeViewController = _treeViewController.loadJSON(json: categoriesJson);
    });
  }

  @override
  void initState() {
    super.initState();
    if(widget.treeJson.isNotEmpty)
      _treeViewController = _treeViewController.loadJSON(json: widget.treeJson);
    else
      loadCategoriesFromServer();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Category Selector"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.reply),
            onPressed: (){
              Navigator.pop(context, cNode);
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          // Expanded(
          //   child: 
          // ),

          Expanded(
            child: Container(
              child: TreeView(
                controller: _treeViewController,
                allowParentSelect: false,
                supportParentDoubleTap: false,
                onNodeTap: (key) {                      
                  String label = _treeViewController.getNode(key) == null
                                ? ''
                                : _treeViewController.getNode(key).label;
                  
                  debugPrint('Selected: $key - $label');
                  _categoryController.text = label;

                  cNode = CategoryNode.fromJson({
                    "key" : "$key",
                    "title" : label
                  });
                  setState(() {
                    _treeViewController =
                        _treeViewController.copyWith(selectedKey: key);
                  });

                  var _key = "${key}";
                  String type = _key.split('_')[0];
                  if(type.isEmpty || type == "c") return;
                  
                  int pid = int.parse(_key.split('_')[1]);
                },
                onNodeDoubleTap: (key){
                  debugPrint('double tap on ${key}');
                },
                onExpansionChanged: (key, expanded){
                  print('key : ${key}  expanded: ${expanded}');

                  String label = _treeViewController.getNode(key) == null
                                ? ''
                                : _treeViewController.getNode(key).label;
                  
                  debugPrint('Selected: $key - $label');
                  _categoryController.text = label;

                  cNode = CategoryNode.fromJson({
                    "key" : "$key",
                    "title" : label
                  });
                  setState(() {
                    _treeViewController =
                        _treeViewController.copyWith(selectedKey: key);
                  });

                  var _key = "${key}";
                  String type = _key.split('_')[0];
                  if(type.isEmpty || type == "c") return;
                  
                  int pid = int.parse(_key.split('_')[1]);
                }
              ),
            ),
          ),

          // Row(
          //   children: <Widget>[
          //     Text("当前选择："),
          //     TextField(controller: _categoryController,),
          //     RaisedButton(
          //       child: Text("Confirm"),
          //       onPressed: (){
          //         Navigator.pop(context, cNode);
          //       },
          //     ),
          //   ],
          // ),

          RaisedButton(
            child: Text("Confirm"),
            onPressed: (){
              Navigator.pop(context, cNode);
            },
          ),
               
        ],
      ),
    );
  }
}