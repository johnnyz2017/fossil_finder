import 'package:flutter/material.dart';
import 'package:fossils_finder/test/swiper/swiper_test.dart';
import 'package:fossils_finder/test/tree_view/tree_view_test.dart';

import 'category_list.dart';
import 'category_tree.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          // title: Text("test tab"),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(text: "List",),
              Tab(text: "Tree",)
              // Tab(text: "List", icon: Icon(Icons.list),),
              // Tab(text: "Tree", icon: Icon(Icons.traffic))
            ]
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Center(child: CategoryListView(title: "test")),
            // Center(child: SwiperTestPage(title: "Test Page"))
            Center(child: CategoryTreeView()),
            // Center(child: TreeViewTestPage(title: 'Tree View Test Page',))
          ],
        ),
        
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}