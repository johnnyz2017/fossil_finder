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
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: new Container(
              color: Colors.blueAccent,
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
        // drawer: Drawer(
        //   child: ,
        // ),
        // appBar: new TabBar(
        //     tabs: <Widget>[
        //       Tab(text: "列表",),
        //       Tab(text: "分类",)
        //       // Tab(text: "List", icon: Icon(Icons.list),),
        //       // Tab(text: "Tree", icon: Icon(Icons.traffic))
        //     ]
        // ),
        // appBar: AppBar(
        //   title: Text(""),
        //   bottom: TabBar(
        //     tabs: <Widget>[
        //       Tab(text: "列表",),
        //       Tab(text: "分类",)
        //       // Tab(text: "List", icon: Icon(Icons.list),),
        //       // Tab(text: "Tree", icon: Icon(Icons.traffic))
        //     ]
        //   ),
        // ),
        // body: IndexedStack(
        //   index: currentIndex,
        //   children: tabPages,
        // ),
        body: TabBarView(
          children: tabPages
        ),
        
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}