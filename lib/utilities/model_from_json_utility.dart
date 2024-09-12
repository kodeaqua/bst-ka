import 'dart:convert';

import 'package:klontong_kodeaqua/models/category_model.dart';
import 'package:klontong_kodeaqua/models/product_model.dart';
import 'package:klontong_kodeaqua/models/role_model.dart';
import 'package:klontong_kodeaqua/models/user_model.dart';

class ModelFromJsonUtility {
  static List<CategoryModel> categories(String responseBody) {
    return List<CategoryModel>.from(jsonDecode(responseBody).map((json) => CategoryModel.fromJson(json)));
  }

  static List<ProductModel> products(String responseBody) {
    return List<ProductModel>.from(jsonDecode(responseBody).map((json) => ProductModel.fromJson(json)));
  }

  static List<RoleModel> roles(String responseBody) {
    return List<RoleModel>.from(jsonDecode(responseBody).map((json) => RoleModel.fromJson(json)));
  }

  static List<UserModel> users(String responseBody) {
    return List<UserModel>.from(jsonDecode(responseBody).map((json) => UserModel.fromJson(json)));
  }
}
