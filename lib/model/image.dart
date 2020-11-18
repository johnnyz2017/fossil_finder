class Image{
  String url;

  Image({this.url});

  // Image.fromJson(Map<String, dynamic> data) 
  // : url = data['url'] ?? '';
  factory Image.fromJson(Map<String, dynamic> json) => Image(
      url: json["url"],
  );

  Map<String, dynamic> toJson() => {
      "url": url,
  };


  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['url'] = url;
    return map;
  }

  // Extract a Note object from a Map object
  Image.fromMapObject(Map<String, dynamic> map) {
    this.url = map['url'];
  }

}

