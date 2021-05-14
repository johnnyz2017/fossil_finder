class User{
  final int id;
  final String name;
  final String avatar;
  final String description;
  final String email;
  final String roleName;
  final DateTime created;
  final int postsCount;//posts_count
  final int categoriesCount; //categories_count
  final int commentsCount;//comments_count

  User(this.id, this.name, this.avatar, this.description, this.roleName, this.email, this.created, this.postsCount, this.categoriesCount, this.commentsCount);

  User.fromJson(Map<String, dynamic> data) 
  : id = data['id'] ?? 0,
    name = data['name'] ?? 'Unknown',
    email = data['email'] ?? '',
    avatar = data['profile_image'] ?? 'images/icons/user.png',
    description = data['description'] ?? '',
    roleName = data['role_name'] ?? '未知角色',
    // created =  data['created'] ?? DateTime.now()
    postsCount = data['posts_count'] ?? 0,
    categoriesCount = data['categories_count'] ?? 0,
    commentsCount = data['comments_count'] ?? 0,
    created =  DateTime.parse(data['created_at'] ?? DateTime.now().toString())
  ;
}