import 'package:flutter/material.dart';
import 'package:fossils_finder/model/post.dart';

class PostDetailPage extends StatefulWidget {
  final Post post;

  const PostDetailPage({Key key, this.post}) : super(key: key);
  
  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post.author)
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.asset(widget.post.images[0].url),
            Text(widget.post.title),
            Text(widget.post.content),
            Divider(color: Colors.blue,),
            Text(widget.post.comments[0].content),
            Text(widget.post.comments[0].author),
          ]
        ),
      ),
    );
  }
}