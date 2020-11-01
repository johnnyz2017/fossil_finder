class CategoryNode{

  final String label;
  final String key;
  final int type;

  final List<CategoryNode> children;
  CategoryNode(this.label, this.key, this.type, this.children);

  // CategoryNode(this.label, this.key, this.type);

  CategoryNode.fromJson(Map<String, dynamic> json)
  : label = json['label'] ?? 'label',
    key = json['key'] ?? 'key',
    type = json['type'] ?? 0 ,
    children = json['children'] != null ? new List<CategoryNode>.from(json["children"].map((x) => CategoryNode.fromJson(x)).toList()) : []
  ;
}