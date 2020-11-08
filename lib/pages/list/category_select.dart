import 'dart:convert';

import 'package:flutter/material.dart';
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

  TreeViewController _treeViewController = TreeViewController();
  CategoryNode cNode;

  ExpanderPosition _expanderPosition = ExpanderPosition.start;
  ExpanderType _expanderType = ExpanderType.caret;
  ExpanderModifier _expanderModifier = ExpanderModifier.none;

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
          IconButton(
            icon: Icon(Icons.done),
            onPressed: (){
              Navigator.pop(context, cNode);
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

                  cNode = CategoryNode.fromJson({
                    "key" : "$key",
                    "title" : label
                  });
                  setState(() {
                    _treeViewController =
                        _treeViewController.copyWith(selectedKey: key);
                  });
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

          // RaisedButton(
          //   child: Text("确认"),
          //   onPressed: (){
          //     Navigator.pop(context, cNode);
          //   },
          // ),
               
        ],
      ),
    );
  }
}