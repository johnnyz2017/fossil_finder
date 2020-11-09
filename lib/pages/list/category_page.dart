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
        appBar: new PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: new Container(
              color: Colors.blue,
              child: new SafeArea(
                child: Column(
                  children: <Widget>[
                    new Expanded(child: new Container()),
                    new TabBar(
                      tabs: [new Text("列表"), new Text("分类")],
                    ),
                  ],
                ),
              ),
          ),
        ),
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
        body: TabBarView(
          children: <Widget>[
            Center(child: CategoryListView(title: "列表")),
            Center(child: CategoryTreeView()),
          ],
        ),
        
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}