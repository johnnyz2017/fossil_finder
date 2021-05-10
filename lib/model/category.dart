class CategoryItem{

  final int id;
  final int parentId;
  final String title;
  final String description;
  final bool isGenus;

  CategoryItem(this.id, this.parentId, this.title, this.description, this.isGenus);

  CategoryItem.fromJson(Map<String, dynamic> json)
  : id = json['id'] ?? -1,
    parentId = json['parent_id'] ?? -1,
    title = json['title'] ?? 0 ,
    description = json['description'] ?? '', 
    isGenus = json['is_genus'] > 0 ? true : false
  ;
}

class CategoryNode{

  final String label;
  final String key;
  final int type;
  final int id;
  // final bool isGenus;

  final List<CategoryNode> children;
  CategoryNode(this.label, this.key, this.type, this.children, this.id);

  // CategoryNode(this.label, this.key, this.type);

  CategoryNode.fromJson(Map<String, dynamic> json)
  : label = json['title'] ?? 'label',
    key = json['key'] ?? 'key',
    type = json['type'] ?? 0 ,
    id = json['id'] ?? -1,
    // isGenus = json['is_genus'] > 0 ? true : false,
    children = json['children'] != null ? new List<CategoryNode>.from(json["children"].map((x) => CategoryNode.fromJson(x)).toList()) : []
  ;
}