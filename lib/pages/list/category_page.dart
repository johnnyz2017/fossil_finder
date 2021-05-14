import 'package:flutter/material.dart';

import 'category_list.dart';
import 'category_tree.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> with AutomaticKeepAliveClientMixin{

  final List<Widget> tabPages = [
    CategoryListView(title: "标本记录列表"),
    CategoryTreeView(),
  ];

  int currentIndex = 0;
  var currentPage;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: new PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight - 30), //TBD
            child: new Container(
              decoration: BoxDecoration(
                color: Colors.grey[100]
              ),
              child: new SafeArea(
                child: Column(
                  children: <Widget>[
                    new Expanded(child: new Container()),
                    new TabBar(
                      tabs: [
                        new Text("标本记录列表"), 
                        new Text("分类单元")
                      ],
                    ),
                  ],
                ),
              ),
          ),
        ),
        body: TabBarView(
          children: tabPages
        ),
        
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}