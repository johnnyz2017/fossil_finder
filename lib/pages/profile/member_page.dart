import 'package:flutter/material.dart';

class MemberPage extends StatefulWidget {
  final String title;

  const MemberPage({Key key, this.title}) : super(key: key);

  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("会员中心")
      ),
      body: ListView(
        children: <Widget>[
          _topHeader()
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  Widget _topHeader(){
    return Container(
      // width: MediaQuery.of(context),
      padding: EdgeInsets.all(20),
      color: Colors.pinkAccent,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20),
            child: ClipOval(child: Image.asset('images/icons/user.png', height: 100,),),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text('测试名字'),
          )
        ],
      ),
    );
  }
}