
import 'dart:convert';

class Comment{
  // final int id;
  // final String author;
  // final String content;

  int id;
  int postId;
  int userId;
  dynamic replyCommentId;
  String title;
  String content;
  dynamic categoryId;
  int sticky;
  String author;

  Comment({
      this.id,
      this.postId,
      this.userId,
      this.replyCommentId,
      this.title,
      this.content,
      this.categoryId,
      this.sticky,
      this.author,
  });

  // Comment(this.id, this.author, this.content);

  // Comment.fromJson(Map<String, dynamic> json)
  // : id = json["id"] ?? 0,
  //   author = json["author"] ?? '',
  //   content = json["contents"] ?? ''; //tbd

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
      id: json["id"],
      postId: json["post_id"],
      userId: json["user_id"],
      replyCommentId: json["reply_comment_id"],
      title: json["title"],
      content: json["content"],
      categoryId: json["category_id"],
      sticky: json["sticky"],
      author: json["author"],
  );

  Map<String, dynamic> toJson() => {
      "id": id,
      "post_id": postId,
      "user_id": userId,
      "reply_comment_id": replyCommentId,
      "title": title,
      "content": content,
      "category_id": categoryId,
      "sticky": sticky,
      "author": author,
  };

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['post_id'] = postId;
    map['user_id'] = userId;
    map['reply_comment_id'] = replyCommentId;
    map['title'] = title;
    map['content'] = content;
    map['category_id'] = categoryId;
    map['sticky'] = sticky;
    map['author'] = author;

    return map;
  }

  // Extract a Note object from a Map object
  Comment.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.postId = map['post_id'];
    this.userId = map['user_id'];
    this.replyCommentId = map['reply_comment_id'];
    this.title = map['title'];
    this.content = map['content'];
    this.categoryId = map['category_id'];
    this.sticky = map['sticky'];
    this.author = map['author'];
  }

}