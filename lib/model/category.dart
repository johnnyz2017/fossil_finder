class CategoryItem{

  final int id;
  final int parentId;
  final String title;
  final String description;

  CategoryItem(this.id, this.parentId, this.title, this.description);

  CategoryItem.fromJson(Map<String, dynamic> json)
  : id = json['id'] ?? -1,
    parentId = json['parent_id'] ?? -1,
    title = json['title'] ?? 0 ,
    description = json['description'] ?? ''
  ;
}

class CategoryNode{

  final String label;
  final String key;
  final int type;

  final List<CategoryNode> children;
  CategoryNode(this.label, this.key, this.type, this.children);

  // CategoryNode(this.label, this.key, this.type);

  CategoryNode.fromJson(Map<String, dynamic> json)
  : label = json['title'] ?? 'label',
    key = json['key'] ?? 'key',
    type = json['type'] ?? 0 ,
    children = json['children'] != null ? new List<CategoryNode>.from(json["children"].map((x) => CategoryNode.fromJson(x)).toList()) : []
  ;
}