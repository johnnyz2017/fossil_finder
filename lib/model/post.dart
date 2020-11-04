
import 'dart:convert';

import 'package:fossils_finder/model/comment.dart';
import 'package:fossils_finder/model/image.dart';


class Post {
  final int id;
  final int user_id;
  final String author;
  final String title;
  final String content;
  
  final String temp_id;
  final String perm_id;

  final bool private;
  final bool published;

  final int category_id;
  final int final_category_id;
  final int final_category_id_from;
  final int auth_user_id;

  final double longitude;
  final double latitude;
  final double altitude;
  final String address;
  final DateTime created_at;
  final DateTime updated_at;

  final List<Image> images;
  final List<Comment> comments;

  Post(this.id, this.author, this.title, this.content, this.comments, this.images, this.user_id, this.temp_id, this.perm_id, this.private, this.published, this.category_id, this.final_category_id, this.final_category_id_from, this.auth_user_id, this.longitude, this.latitude, this.altitude, this.address, this.created_at, this.updated_at);

  Post.fromJson(Map<String, dynamic> data)
  : id = data['id'] ?? 0,
    user_id = data['user_id'] ?? 0,
    author = data['author'] ?? '', //name of user_id
    title = data['title'] ?? '',
    content = data['content'] ?? 'No Description',

    temp_id = data['temp_id'] ?? "",
    perm_id = data['perm_id'] ?? "",

    private = data['private'] > 0 ? true : false ?? true,
    published = data['published'] > 0 ? true : false ?? false,
    category_id = data['category_id'] ?? -1,
    final_category_id = data['category_id'] ?? -1,
    final_category_id_from = data['final_category_id_from'] ?? -1,
    auth_user_id = data['auth_user_id'] ?? -1,
    longitude = data['coordinate_longitude'] ?? 121.0,
    latitude = data['coordinate_latitude'] ?? 39.0,
    altitude = data['coordinate_altitude'] ?? 100.0,
    // altitude = 100.02,
    address = data['address'] ?? '',
    created_at = DateTime.parse(data['created_at'] ?? DateTime.now()),
    updated_at = DateTime.parse(data['updated_at'] ?? DateTime.now()),

    comments = new List<Comment>.from(data["comments"].map((x) => Comment.fromJson(x)).toList()),
    images = new List<Image>.from(data['images'].map((x) => Image.fromJson(x)).toList())
    // comments = data['comments'].map((item) => Comment.fromJson(item)).toList(),
    // images = json.decode(data['images'])
  ;
}