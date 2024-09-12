class ProductModel {
  String? id;
  String? categoryId;
  String? sku;
  String? name;
  String? description;
  int? weight;
  int? width;
  int? length;
  int? height;
  String? image;
  int? price;
  DateTime? createdAt;
  DateTime? updatedAt;

  ProductModel({
    this.id,
    this.categoryId,
    this.sku,
    this.name,
    this.description,
    this.weight,
    this.width,
    this.length,
    this.height,
    this.image,
    this.price,
  });

  ProductModel.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String,
        categoryId = json['categoryId'] as String,
        sku = json['sku'] as String,
        name = json['name'] as String,
        description = json['description'] as String,
        weight = json['weight'] as int,
        width = json['width'] as int,
        length = json['length'] as int,
        height = json['height'] as int,
        image = json['image'] as String,
        price = json['price'] as int,
        createdAt = DateTime.parse(json['createdAt']).toLocal(),
        updatedAt = DateTime.parse(json['updatedAt']).toLocal();

  Map<String, dynamic> toJson() => {
        'categoryId': categoryId,
        'sku': sku,
        'name': name,
        'description': description,
        'weight': weight,
        'width': width,
        'length': length,
        'height': height,
        'image': image,
        'price': price,
        'createdAt': createdAt.toString(),
        'updatedAt': updatedAt.toString(),
      };
}
