import 'package:flutter/material.dart';

class MemberProfileUpdatePage extends StatefulWidget {
  @override
  _MemberProfileUpdatePageState createState() => _MemberProfileUpdatePageState();
}

class _MemberProfileUpdatePageState extends State<MemberProfileUpdatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("个人设置"),
      ),
      body: Center(child: Text('个人设置'),),
    );
  }
}