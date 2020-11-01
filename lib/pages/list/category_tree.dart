import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_treeview/tree_view.dart';
import 'package:fossils_finder/api/service_method.dart';
import 'package:fossils_finder/config/global_config.dart';
import 'package:fossils_finder/model/category.dart';


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

  TreeViewController _treeViewController = TreeViewController(children: nodes);
  CategoryNode _node;


  Future loadPostListFromServer() async{
    var _content = await request(servicePath['categories']);
    var _jsonData = jsonDecode(_content.toString());
    // var _jsonData = jsonDecode(_content.toString())['data'];
    // print('json data: ${_jsonData.toString()}');
    // var _childrenJson = jsonEncode(_jsonData['data']['children']);
    // CategoryNode node = CategoryNode.fromJson(_jsonData);
    CategoryNode node = CategoryNode.fromJson(_jsonData);
    print('node ${node.label}');
    setState(() {
      _node = node;
      // _treeViewController = _treeViewController.loadJSON(json: _childrenJson);
    });
  }

  @override
  void initState() {
    loadPostListFromServer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RaisedButton(
          child: Text('Reload'),
          onPressed: (){
            loadPostListFromServer();
          },
        ),
        Expanded(
                  child: Container(
            child: TreeView(
              controller: _treeViewController,
              allowParentSelect: false,
              supportParentDoubleTap: false,
              // onExpansionChanged: _expandNodeHandler,
              onNodeTap: (key) {
                setState(() {
                  _treeViewController = _treeViewController.copyWith(selectedKey: key);
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
