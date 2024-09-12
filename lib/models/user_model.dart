class UserModel {
  String? id;
  String? username;
  String? password;
  String? name;
  String? roleId;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserModel({this.id, this.name, this.roleId, this.createdAt, this.updatedAt});

  UserModel.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String,
        username = json['username'] as String,
        password = json['password'] as String,
        name = json['name'] as String,
        roleId = json['roleId'] as String,
        createdAt = DateTime.parse(json['createdAt']).toLocal(),
        updatedAt = DateTime.parse(json['updatedAt']).toLocal();

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'name': name,
        'roleId': roleId,
        'createdAt': createdAt.toString(),
        'updatedAt': updatedAt.toString(),
      };
}
