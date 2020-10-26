class User{
  final int id;
  final String name;
  final String avatar;
  final String email;
  final DateTime created;

  User(this.id, this.name, this.avatar, this.email, this.created);

  User.fromJson(Map<String, dynamic> data) 
  : id = data['id'] ?? 0,
    name = data['name'] ?? 'Unknown',
    email = data['email'] ?? '',
    avatar = data['avatar'] ?? 'images/icons/user.png',
    created =  DateTime.parse(data['created'] ?? DateTime.now())
  ;
}