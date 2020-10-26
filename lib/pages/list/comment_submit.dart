import 'package:flutter/material.dart';
import 'package:fossils_finder/model/post.dart';

class CommentSubmitPage extends StatefulWidget {
  final Post post;

  const CommentSubmitPage({Key key, this.post}) : super(key: key);
  
  @override
  _CommentSubmitPageState createState() => _CommentSubmitPageState();
}

class _CommentSubmitPageState extends State<CommentSubmitPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post?.title ?? 'title none'),
      ),
      body: Center(
        child: Text('Comment Submit Page'),
      ),
    );
  }
}