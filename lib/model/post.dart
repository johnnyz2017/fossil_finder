import 'dart:convert';

import 'package:fossils_finder/model/comment.dart';
import 'package:fossils_finder/model/image.dart';
import 'package:fossils_finder/utils/strings.dart';

class Post {
    Post(
        this._userId,
        this._authUserId,
        this._tempId,
        this._permId,
        this._title,
        this._content,
        this._private,
        this._published,
        this._images,
        this._categoryId,
        this._finalCategoryId,
        this._finalCategoryIdFrom,
        this._coordinateLongitude,
        this._coordinateLatitude,
        this._coordinateAltitude,
        this._address,
        this._createdAt,
        this._updatedAt,
        this._author,
        this._comments,
    );

    Post.withId(
        this._id,
        this._userId,
        this._authUserId,
        this._tempId,
        this._permId,
        this._title,
        this._content,
        this._private,
        this._published,
        this._images,
        this._categoryId,
        this._finalCategoryId,
        this._finalCategoryIdFrom,
        this._coordinateLongitude,
        this._coordinateLatitude,
        this._coordinateAltitude,
        this._address,
        this._createdAt,
        this._updatedAt,
        this._author,
        this._comments,
    );

    int _id;
    int _userId;
    int _authUserId;
    String _tempId;
    String _permId;
    String _title;
    String _content;
    bool _private;
    bool _published;
    String _imagesString;
    List<Image> _images;
    int _categoryId;
    int _finalCategoryId;
    int _finalCategoryIdFrom;
    double _coordinateLongitude;
    double _coordinateLatitude;
    double _coordinateAltitude;
    String _address;
    DateTime _createdAt;
    DateTime _updatedAt;
    String _author;
    List<Comment> _comments;

    int get id => _id;
    int get userId => _userId;
    int get authUserId => _authUserId;
    String get tempId => _tempId;
    String get permId => _permId;
    String get title => _title;
    String get content => _content;
    bool get private => _private;
    bool get published => _published;
    String get imagesString => _imagesString;
    List<Image> get images => _images;
    int get categoryId => _categoryId;
    int get finalCategoryId => _finalCategoryId;
    int get finalCategoryIdFrom => _finalCategoryIdFrom;
    double get coordinateLongitude => _coordinateLongitude;
    double get coordinateLatitude => _coordinateLatitude;
    double get coordinateAltitude => _coordinateAltitude;
    String get address => _address;
    DateTime get createdAt => _createdAt;
    DateTime get updatedAt => _updatedAt;
    String get author => _author;
    List<Comment> get comments => _comments;

    Post.fromJson(Map<String, dynamic> json) 
      :
        _id = json["id"],
        _userId = json["user_id"],
        _authUserId = json["auth_user_id"],
        _tempId = json["temp_id"],
        _permId = json["perm_id"],
        _title = json["title"],
        _content = json["content"],
        _private = json["private"] > 0 ? true : false,
        _published = json["published"] > 0 ? true : false,
        _images = List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
        _categoryId = json["category_id"],
        _finalCategoryId = json["final_category_id"],
        _finalCategoryIdFrom = json["final_category_id_from"],
        _coordinateLongitude = json["coordinate_longitude"].toDouble(),
        _coordinateLatitude = json["coordinate_latitude"].toDouble(),
        _coordinateAltitude = json["coordinate_altitude"].toDouble(),
        _address = json["address"],
        _createdAt = DateTime.parse(json["created_at"]),
        _updatedAt = DateTime.parse(json["updated_at"]),
        _author = json["author"],
        _comments = List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x)))
    ;

    // factory Post.fromJson(Map<String, dynamic> json) => Post(
    //     _id: json["id"],
    //     _userId: json["user_id"],
    //     _authUserId: json["auth_user_id"],
    //     _tempId: json["temp_id"],
    //     _permId: json["perm_id"],
    //     _title: json["title"],
    //     _content: json["content"],
    //     _private: json["private"] > 0 ? true : false,
    //     _published: json["published"] > 0 ? true : false,
    //     _images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
    //     _categoryId: json["category_id"],
    //     _finalCategoryId: json["final_category_id"],
    //     _finalCategoryIdFrom: json["final_category_id_from"],
    //     _coordinateLongitude: json["coordinate_longitude"].toDouble(),
    //     _coordinateLatitude: json["coordinate_latitude"].toDouble(),
    //     _coordinateAltitude: json["coordinate_altitude"].toDouble(),
    //     _address: json["address"],
    //     _createdAt: DateTime.parse(json["created_at"]),
    //     _updatedAt: DateTime.parse(json["updated_at"]),
    //     _author: json["author"],
    //     _comments: List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x))),
    // );

    Map<String, dynamic> toJson() => {
        "id": _id,
        "user_id": _userId,
        "auth_user_id": _authUserId,
        "temp_id": _tempId,
        "perm_id": _permId,
        "title": _title,
        "content": _content,
        "private": _private,
        "published": _published,
        "images": List<Image>.from(_images.map((x) => x.toJson())),
        "category_id": _categoryId,
        "final_category_id": _finalCategoryId,
        "final_category_id_from": _finalCategoryIdFrom,
        "coordinate_longitude": _coordinateLongitude,
        "coordinate_latitude": _coordinateLatitude,
        "coordinate_altitude": _coordinateAltitude,
        "address": _address,
        "created_at": _createdAt == null ? '' : _createdAt.toIso8601String(),
        "updated_at": _updatedAt == null ? '' : _updatedAt.toIso8601String(),
        "author": _author,
        "comments": List<Comment>.from(_comments.map((x) => x.toJson())),
    };

    Map<String, dynamic> toMap() {
      var map = Map<String, dynamic>();
      if (_id != null) {
        map['id'] = _id;
      }
      map['user_id'] = _userId;
      map['auth_user_id'] = _authUserId;
      map['temp_id'] = _tempId;
      map['perm_id'] = _permId;
      map['title'] = _title;
      map['content'] = _content;
      map['private'] = _private ? 1 : 0;
      map['published'] = _published ? 1 : 0;
      if(_images != null && _images.length > 0){
        List<String> imageList = <String>[];
        _images.forEach((image) { 
          imageList.add(image.url);
        });
        map['images'] = list2String(imageList, ',');
      }else{
        map['images'] = _imagesString;
      }
      
      map['category_id'] = _categoryId;
      map['final_category_id'] = _finalCategoryId;
      map['final_category_id_from'] = _finalCategoryIdFrom;
      map['coordinate_longitude'] = _coordinateLongitude;
      map['coordinate_latitude'] = _coordinateLatitude;
      map['coordinate_altitude'] = _coordinateAltitude;
      map['address'] = _address;
      map['created_at'] = _createdAt == null ? '' : _createdAt.toIso8601String();
      map['updated_at'] = _updatedAt == null ? '' : _updatedAt.toIso8601String();
      map['author'] = _author;
      return map;
    }

    // Extract a Note object from a Map object
    Post.fromMapObject(Map<String, dynamic> map) {
      this._id = map['id'];
      this._userId = map['user_id'];
      this._authUserId = map['auth_user_id'];
      this._tempId = map['temp_id'];
      this._permId = map['perm_id'];
      this._title = map['title'];
      this._content = map['content'];
      this._private = map['private'] > 0 ? true : false;
      this._published = map['published'] > 0 ? true : false;
      if(map['images'] != null && map['images'].toString().isNotEmpty){
        this._images = <Image>[];
        String imgStr = map['images'].toString();
        List<String> imgList = imgStr.split(',');
        imgList.forEach((img) { 
          this._images.add(Image.fromMapObject({
            "url" : img
          }));
        });
      }
      this._imagesString = map['images'];
      this._categoryId = map['category_id'];
      this._finalCategoryId = map['final_category_id'];
      this._finalCategoryIdFrom = map['final_category_id_from'];
      this._coordinateLongitude = map['coordinate_longitude'];
      this._coordinateLatitude = map['coordinate_latitude'];
      this._coordinateAltitude = map['coordinate_altitude'];
      this._address = map['address'];
      if(map['created_at'] != null && map['created_at'].toString().isNotEmpty){
        this._createdAt = DateTime.parse(map['created_at']);
      }
      if(map['updated_at'] != null && map['updated_at'].toString().isNotEmpty){
        this._updatedAt = DateTime.parse(map['updated_at']);
      }
      this._author = map['author'];
    }

}