
import 'dart:convert';

import 'package:fossils_finder/model/comment.dart';
import 'package:fossils_finder/model/image.dart';


class Post {
  final int id;
  final String author;
  final String title;
  final String content;
  // final List<String> images;
  final List<Image> images;
  final List<Comment> comments;

  Post(this.id, this.author, this.title, this.content, this.comments, this.images);

  Post.fromJson(Map<String, dynamic> data)
  : id = data['id'],
    author = data['author'],
    title = data['title'],
    content = data['contents'],
    comments = new List<Comment>.from(data["comments"].map((x) => Comment.fromJson(x)).toList()),
    images = new List<Image>.from(data['images'].map((x) => Image.fromJson(x)).toList())
    // comments = data['comments'].map((item) => Comment.fromJson(item)).toList(),
    // images = json.decode(data['images'])
  ;
}

// class Post {
//   final int id;
//   final int temporaryId;
//   final int permanentId;
//   final int author_id;
//   final String author;
//   final String title;
//   final String content;
//   final List<String> images;
//   final List<Comment> comments;

//   Post(this.id, this.temporaryId, this.permanentId, this.author_id, this.author, this.title, this.content, this.images, this.comments);

//   Post.fromJson(Map<String, dynamic> data)
//   : id = data['id'],
//     temporaryId = data["temporaryId"],
//     permanentId = data["permanentId"],
//     author_id = data['author_id'],
//     author = data['author'],
//     title = data['title'],
//     content = data['content'],
//     comments = new List<Comment>.from(data["comments"].map((x) => Comment.fromJson(x))),
//     images = data['images']
//   ;
// }