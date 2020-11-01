class Image{
  final String url;

  Image(this.url);

  Image.fromJson(Map<String, dynamic> data) 
  : url = data['url'] ?? '';

}