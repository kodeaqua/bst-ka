class RoleModel {
  String? id;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;

  RoleModel({this.id, this.name, this.createdAt, this.updatedAt});

  RoleModel.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String,
        name = json['name'] as String,
        createdAt = DateTime.parse(json['createdAt']).toLocal(),
        updatedAt = DateTime.parse(json['updatedAt']).toLocal();

  Map<String, dynamic> toJson() => {
        'name': name,
        'createdAt': createdAt.toString(),
        'updatedAt': updatedAt.toString(),
      };
}
