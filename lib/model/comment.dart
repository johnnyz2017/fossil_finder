
import 'dart:convert';

class Comment{
  final int id;
  final String author;
  final String content;

  Comment(this.id, this.author, this.content);

  Comment.fromJson(Map<String, dynamic> json)
  : id = json["id"] ?? 0,
    author = json["author"] ?? '',
    content = json["contents"] ?? ''; //tbd

}

// class Comment{
//   final int id;
//   final int specimenId;
//   final String classes;
//   final String comments;
//   final DateTime commentTime;

//   Comment(this.id, this.specimenId, this.classes, this.comments, this.commentTime);

//   Comment.fromJson(Map<String, dynamic> json)
//   : id = json["id"],
//     specimenId = json["specimenId"],
//     classes = json["classes"],
//     comments = json["comments"],
//     commentTime = jsonDecode(json["commentTime"]) ; //tbd

// }