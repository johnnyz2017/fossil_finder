import 'package:flutter/material.dart';
import 'package:flutter_treeview/tree_view.dart';


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
  Node(
      label: 'MeetingReport.xls',
      key: 'mrxls',
      icon: NodeIcon.fromIconData(Icons.insert_drive_file)),
  Node(
      label: 'MeetingReport.pdf',
      key: 'mrpdf',
      icon: NodeIcon.fromIconData(Icons.insert_drive_file)),
  Node(
      label: 'Demo.zip',
      key: 'demo',
      icon: NodeIcon.fromIconData(Icons.archive)),
];

class CategoryTreeView extends StatefulWidget {
  @override
  _CategoryTreeViewState createState() => _CategoryTreeViewState();
}

class _CategoryTreeViewState extends State<CategoryTreeView> {

  TreeViewController _treeViewController = TreeViewController(children: nodes);


  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
