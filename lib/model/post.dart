import 'package:fossils_finder/model/comment.dart';
import 'package:fossils_finder/model/image.dart';
import 'package:fossils_finder/utils/strings.dart';

class Post {
    Post({
        this.id,
        this.userId,
        this.authUserId,
        this.tempId,
        this.permId,
        this.title,
        this.content,
        this.private,
        this.published,
        this.images,
        this.categoryId,
        this.finalCategoryId,
        this.finalCategoryIdFrom,
        this.coordinateLongitude,
        this.coordinateLatitude,
        this.coordinateAltitude,
        this.address,
        this.createdAt,
        this.updatedAt,
        this.author,
        this.comments,
    });

    int id;
    int userId;
    int authUserId;
    String tempId;
    String permId;
    String title;
    String content;
    bool private;
    bool published;
    String imagesString;
    List<Image> images;
    int categoryId;
    int finalCategoryId;
    int finalCategoryIdFrom;
    double coordinateLongitude;
    double coordinateLatitude;
    double coordinateAltitude;
    String address;
    DateTime createdAt;
    DateTime updatedAt;
    String author;
    List<Comment> comments;

    factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"],
        userId: json["user_id"],
        authUserId: json["auth_user_id"],
        tempId: json["temp_id"],
        permId: json["perm_id"],
        title: json["title"],
        content: json["content"],
        private: json["private"] > 0 ? true : false,
        published: json["published"] > 0 ? true : false,
        images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
        categoryId: json["category_id"],
        finalCategoryId: json["final_category_id"],
        finalCategoryIdFrom: json["final_category_id_from"],
        coordinateLongitude: json["coordinate_longitude"].toDouble(),
        coordinateLatitude: json["coordinate_latitude"].toDouble(),
        coordinateAltitude: json["coordinate_altitude"].toDouble(),
        address: json["address"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        author: json["author"],
        comments: List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "auth_user_id": authUserId,
        "temp_id": tempId,
        "perm_id": permId,
        "title": title,
        "content": content,
        "private": private,
        "published": published,
        "images": List<Image>.from(images.map((x) => x.toJson())),
        "category_id": categoryId,
        "final_category_id": finalCategoryId,
        "final_category_id_from": finalCategoryIdFrom,
        "coordinate_longitude": coordinateLongitude,
        "coordinate_latitude": coordinateLatitude,
        "coordinate_altitude": coordinateAltitude,
        "address": address,
        "created_at": createdAt == null ? '' : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? '' : updatedAt.toIso8601String(),
        "author": author,
        "comments": List<Comment>.from(comments.map((x) => x.toJson())),
    };

    Map<String, dynamic> toMap() {
      var map = Map<String, dynamic>();
      if (id != null) {
        map['id'] = id;
      }
      map['user_id'] = userId;
      map['auth_user_id'] = authUserId;
      map['temp_id'] = tempId;
      map['perm_id'] = permId;
      map['title'] = title;
      map['content'] = content;
      map['private'] = private ? 1 : 0;
      map['published'] = published ? 1 : 0;
      if(images != null && images.length > 0){
        List<String> imageList = <String>[];
        images.forEach((image) { 
          imageList.add(image.url);
        });
        map['images'] = list2String(imageList, ',');
      }else{
        map['images'] = imagesString;
      }
      
      map['category_id'] = categoryId;
      map['final_category_id'] = finalCategoryId;
      map['final_category_id_from'] = finalCategoryIdFrom;
      map['coordinate_longitude'] = coordinateLongitude;
      map['coordinate_latitude'] = coordinateLatitude;
      map['coordinate_altitude'] = coordinateAltitude;
      map['address'] = address;
      map['created_at'] = createdAt == null ? '' : createdAt.toIso8601String();
      map['updated_at'] = updatedAt == null ? '' : updatedAt.toIso8601String();
      map['author'] = author;
      // map['comments'] = comments;
      return map;
    }

    // Extract a Note object from a Map object
    Post.fromMapObject(Map<String, dynamic> map) {
      this.id = map['id'];
      this.userId = map['user_id'];
      this.authUserId = map['auth_user_id'];
      this.tempId = map['temp_id'];
      this.permId = map['perm_id'];
      this.title = map['title'];
      this.content = map['content'];
      this.private = map['private'] > 0 ? true : false;
      this.published = map['published'] > 0 ? true : false;
      // this.images = Image.fromMapObject(map['imaegs']);
      if(map['images'] != null && map['images'].toString().isNotEmpty){
        this.images = <Image>[];
        String imgStr = map['images'].toString();
        List<String> imgList = imgStr.split(',');
        imgList.forEach((img) { 
          this.images.add(Image.fromMapObject({
            "url" : img
          }));
        });
      }
      this.imagesString = map['images'];
      this.categoryId = map['category_id'];
      this.finalCategoryId = map['final_category_id'];
      this.finalCategoryIdFrom = map['final_category_id_from'];
      this.coordinateLongitude = map['coordinate_longitude'];
      this.coordinateLatitude = map['coordinate_latitude'];
      this.coordinateAltitude = map['coordinate_altitude'];
      this.address = map['address'];
      // this.createdAt = map['created_at'].toString().isNotEmpty ? DateTime.parse(map['created_at']) : DateTime.now();
      // this.updatedAt = map['updated_at'].toString().isNotEmpty ? DateTime.parse(map['updated_at']) : DateTime.now();
      String createdAtString;
      String updatedAtString;
      if(map['created_at'] != null && map['created_at'].toString().isNotEmpty){
        this.createdAt = DateTime.parse(map['created_at']);
      }
      if(map['updated_at'] != null && map['updated_at'].toString().isNotEmpty){
        this.updatedAt = DateTime.parse(map['updated_at']);
      }
      // this.createdAt = map['created_at'] != null ? DateTime.parse(map['created_at'].toString().isNotEmpty ? map['created_at'].toString()) : DateTime.now();
      // this.updatedAt = map['updated_at'] != null ? DateTime.parse(map['updated_at']) : DateTime.now();
      this.author = map['author'];
      // this.comments = map['comments'];
    }

}

// class Post {
//   final int id;
//   final int user_id;
//   final String author;
//   final String title;
//   final String content;
  
//   final String temp_id;
//   final String perm_id;

//   final bool private;
//   final bool published;

//   final int category_id;
//   final int final_category_id;
//   final int final_category_id_from;
//   final int auth_user_id;

//   final double longitude;
//   final double latitude;
//   final double altitude;
//   final String address;
//   final DateTime created_at;
//   final DateTime updated_at;

//   final List<Image> images;
//   final List<Comment> comments;

//   Post(this.id, this.author, this.title, this.content, this.comments, this.images, this.user_id, this.temp_id, this.perm_id, this.private, this.published, this.category_id, this.final_category_id, this.final_category_id_from, this.auth_user_id, this.longitude, this.latitude, this.altitude, this.address, this.created_at, this.updated_at);

//   Post.fromJson(Map<String, dynamic> data)
//   : id = data['id'] ?? 0,
//     user_id = data['user_id'] ?? 0,
//     author = data['author'] ?? '', //name of user_id
//     title = data['title'] ?? '',
//     content = data['content'] ?? 'No Description',

//     temp_id = data['temp_id'] ?? "",
//     perm_id = data['perm_id'] ?? "",

//     private = data['private'] > 0 ? true : false ?? true,
//     published = data['published'] > 0 ? true : false ?? false,
//     category_id = data['category_id'] ?? -1,
//     final_category_id = data['category_id'] ?? -1,
//     final_category_id_from = data['final_category_id_from'] ?? -1,
//     auth_user_id = data['auth_user_id'] ?? -1,
//     longitude = data['coordinate_longitude'] ?? 121.0,
//     latitude = data['coordinate_latitude'] ?? 39.0,
//     altitude = data['coordinate_altitude'] ?? 100.0,
//     // altitude = 100.02,
//     address = data['address'] ?? '',
//     created_at = DateTime.parse(data['created_at'] ?? DateTime.now()),
//     updated_at = DateTime.parse(data['updated_at'] ?? DateTime.now()),

//     comments = new List<Comment>.from(data["comments"].map((x) => Comment.fromJson(x)).toList()),
//     images = new List<Image>.from(data['images'].map((x) => Image.fromJson(x)).toList())
//     // comments = data['comments'].map((item) => Comment.fromJson(item)).toList(),
//     // images = json.decode(data['images'])
//   ;
// }