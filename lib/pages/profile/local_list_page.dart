import 'package:flutter/material.dart';

class LocalPostsPage extends StatefulWidget {
  @override
  _LocalPostsPageState createState() => _LocalPostsPageState();
}

class _LocalPostsPageState extends State<LocalPostsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('未上传'),
      ),
      body: Center(
        child: Text('未上传'),
      ),
    );
  }
}