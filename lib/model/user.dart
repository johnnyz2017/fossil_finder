class User{
  final int id;
  final String name;
  final String avatar;
  final String description;
  final String email;
  final DateTime created;

  User(this.id, this.name, this.avatar, this.description, this.email, this.created);

  User.fromJson(Map<String, dynamic> data) 
  : id = data['id'] ?? 0,
    name = data['name'] ?? 'Unknown',
    email = data['email'] ?? '',
    avatar = data['profile_image'] ?? 'images/icons/user.png',
    description = data['description'] ?? '',
    // created =  data['created'] ?? DateTime.now()
    created =  DateTime.parse(data['created_at'] ?? DateTime.now().toString())
  ;
}