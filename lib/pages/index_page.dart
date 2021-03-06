import 'package:flutter/material.dart';
import 'package:fossils_finder/test/tree_view/tree_view_test.dart';

import 'home/home_page.dart';
import 'list/category_list.dart';
import 'list/category_page.dart';
import 'profile/member_page.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final List<BottomNavigationBarItem> bottomTabs = [
    BottomNavigationBarItem(
      // icon: Icon(Icons.home),
      icon: new Image.asset(
        'images/icons/scan_gray.png',
        width: 0,
        height: 0,
        fit: BoxFit.fill
      ),
      title: Text("首页")
    ),
    BottomNavigationBarItem(
      // icon: Icon(Icons.list),
      icon: new Image.asset(
        'images/icons/scan_gray.png',
        width: 0,
        height: 0,
        fit: BoxFit.fill
      ),
      title: Text("标本")
    ),
    // BottomNavigationBarItem(
    //   icon: Icon(Icons.person),
    //   title: Text("我的")
    // ),
    BottomNavigationBarItem(
      // icon: Icon(Icons.person,),
      icon: new Image.asset(
        'images/icons/scan_gray.png',
        width: 0,
        height: 0,
        fit: BoxFit.fill
      ),
      title: Text("我的")
    ),
    // BottomNavigationBarItem(
    //   icon: Icon(Icons.person),
    //   title: Text("树形测试")
    // ),
  ];

  final List<Widget> tabBodies = [
    HomePage(title: '首页',),
    CategoryPage(),
    MemberPage(title: '我的'),
  ];

  int currentIndex = 0;
  var currentPage;

  @override
  void initState() {
    currentPage = tabBodies[currentIndex];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        items: bottomTabs,
        onTap: (index){
          print("change index to $index");
          setState(() {
            currentIndex = index;
            currentPage = tabBodies[currentIndex];
          });
        },
      ),  
      body: IndexedStack(
        index: currentIndex,
        children: tabBodies,
      ),
    );
  }
}