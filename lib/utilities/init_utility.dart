import 'package:cancellation_token/cancellation_token.dart';
import 'package:flutter_bcrypt/flutter_bcrypt.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klontong_kodeaqua/cubits/categories_cubit.dart';
import 'package:klontong_kodeaqua/cubits/products_cubit.dart';
import 'package:klontong_kodeaqua/cubits/roles_cubit.dart';
import 'package:klontong_kodeaqua/cubits/user_cubit.dart';
import 'package:klontong_kodeaqua/main.dart';
import 'package:klontong_kodeaqua/models/category_model.dart';
import 'package:klontong_kodeaqua/models/product_model.dart';
import 'package:klontong_kodeaqua/models/role_model.dart';
import 'package:klontong_kodeaqua/models/user_model.dart';
import 'package:klontong_kodeaqua/utilities/http_utility_new.dart';
import 'package:http/http.dart' as http;

class InitUtility {
  static Future<void> start() async {
    late http.Response response;
    late final HttpUtilityNew httpUtil;
    late final HttpPayload httpPayload;

    httpUtil = HttpUtilityNew();
    httpPayload = HttpPayload(entity: '', requestType: HttpRequestType.get);

    response = await httpUtil.makeRequest(payload: httpPayload);
    if (response.body == '[]') {
      await _initRoles();
    }

    response = await httpUtil.makeRequest(payload: httpPayload);
    if (response.body == '["roles]') {
      await _initUsers();
    }

    response = await httpUtil.makeRequest(payload: httpPayload);
    if (response.body == '["roles","users"]') {
      await _initCategories();
    }

    response = await httpUtil.makeRequest(payload: httpPayload);
    if (response.body == '["roles","users","categories"]') {
      await _initProducts();
    }
  }

  static Future<void> _initRoles() async {
    late final CancellationToken token;
    late final RoleModel admin;
    late final RoleModel user;
    late final DateTime currentTime;
    late List<RoleModel> defaultRoles;

    token = CancellationToken();
    currentTime = DateTime.now().toUtc();

    admin = RoleModel();
    admin.name = 'Owner';
    admin.createdAt = currentTime;
    admin.updatedAt = currentTime;

    user = RoleModel();
    user.name = 'User';
    user.createdAt = currentTime;
    user.updatedAt = currentTime;

    defaultRoles = <RoleModel>[];
    defaultRoles.add(admin);
    defaultRoles.add(user);

    for (RoleModel role in defaultRoles) {
      await navigatorKey.currentContext!.read<RolesCubit>().send(token: token, data: role);
    }
  }

  static Future<void> _initUsers() async {
    late final CancellationToken token;
    late final List<RoleModel> defaultRoles;
    late final UserModel owner;
    late final UserModel user;
    late final DateTime currentTime;
    late List<UserModel> defaultUsers;

    token = CancellationToken();
    // await navigatorKey.currentContext!.read<RolesCubit>().initialize(token: token);
    await navigatorKey.currentContext!.read<RolesCubit>().init(token: token);
    defaultRoles = navigatorKey.currentContext!.read<RolesCubit>().state ?? <RoleModel>[];
    currentTime = DateTime.now().toUtc();

    owner = UserModel();
    owner.username = 'owner_gantenk';
    owner.password = await FlutterBcrypt.hashPw(password: '12345678', salt: await FlutterBcrypt.salt());
    owner.name = 'Owner Klontong';
    owner.roleId = defaultRoles[0].id;
    owner.createdAt = currentTime;
    owner.updatedAt = currentTime;

    user = UserModel();
    user.username = 'pembeli_itu_raja';
    user.password = await FlutterBcrypt.hashPw(password: '12345678', salt: await FlutterBcrypt.salt());
    user.name = 'User 1';
    user.roleId = defaultRoles[1].id;
    user.createdAt = currentTime;
    user.updatedAt = currentTime;

    defaultUsers = <UserModel>[];
    defaultUsers.add(owner);
    defaultUsers.add(user);

    for (UserModel user in defaultUsers) {
      await navigatorKey.currentContext!.read<UserCubit>().send(token: token, data: user);
    }
  }

  static Future<void> _initCategories() async {
    late final CancellationToken token;
    late final CategoryModel category1;
    late final CategoryModel category2;
    late final DateTime currentTime;
    late List<CategoryModel> defaultCategories;

    token = CancellationToken();
    currentTime = DateTime.now().toUtc();

    category1 = CategoryModel();
    category1.name = 'Cemilan';
    category1.createdAt = currentTime;
    category1.updatedAt = currentTime;

    category2 = CategoryModel();
    category2.name = 'Cepuluh';
    category2.createdAt = currentTime;
    category2.updatedAt = currentTime;

    defaultCategories = <CategoryModel>[];
    defaultCategories.add(category1);
    defaultCategories.add(category2);

    for (CategoryModel category in defaultCategories) {
      // await navigatorKey.currentContext!.read<CategoriesCubit>().send(token: token, data: category);
      await navigatorKey.currentContext!.read<CategoriesCubit>().send(token: token, data: category);
    }
  }

  static Future<void> _initProducts() async {
    late final CancellationToken token;
    late final List<CategoryModel> defaultCategories;
    late final ProductModel product1;
    late final ProductModel product2;
    late final DateTime currentTime;
    late List<ProductModel> defaultProducts;

    token = CancellationToken();
    // await navigatorKey.currentContext!.read<CategoriesCubit>().initialize(token: token);
    await navigatorKey.currentContext!.read<CategoriesCubit>().init(token: token);
    defaultCategories = navigatorKey.currentContext!.read<CategoriesCubit>().state ?? <CategoryModel>[];
    currentTime = DateTime.now().toUtc();

    product1 = ProductModel();
    product1.categoryId = defaultCategories[0].id;
    product1.sku = 'MHZVTK';
    product1.name = 'Ciki ciki';
    product1.description = 'Ciki ciki yang super enak, hanya di toko klontong kami';
    product1.weight = 500;
    product1.width = 5;
    product1.length = 5;
    product1.height = 5;
    product1.image = "https://cf.shopee.co.id/file/7cb930d1bd183a435f4fb3e5cc4a896b";
    product1.price = 30000;
    product1.createdAt = currentTime;
    product1.updatedAt = currentTime;

    product2 = ProductModel();
    product2.categoryId = defaultCategories[0].id;
    product2.sku = 'MHZVTK';
    product2.name = 'Ciki ciki';
    product2.description = 'Ciki ciki yang super enak, hanya di toko klontong kami';
    product2.weight = 500;
    product2.width = 5;
    product2.length = 5;
    product2.height = 5;
    product2.image = "https://cf.shopee.co.id/file/7cb930d1bd183a435f4fb3e5cc4a896b";
    product2.price = 30000;
    product2.createdAt = currentTime;
    product2.updatedAt = currentTime;

    defaultProducts = <ProductModel>[];
    defaultProducts.add(product1);
    defaultProducts.add(product2);

    for (ProductModel product in defaultProducts) {
      await navigatorKey.currentContext!.read<ProductsCubit>().send(token: token, data: product);
    }
  }
}
