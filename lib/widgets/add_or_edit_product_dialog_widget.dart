import 'package:cancellation_token/cancellation_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/busy_cubit.dart';
import '../cubits/categories_cubit.dart';
import '../cubits/products_cubit.dart';
import '../main.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import 'app_bar_loading_widget.dart';
import 'success_dialog_widget.dart';

class AddOrEditProductDialogWidget extends StatefulWidget {
  final bool isNew;
  final ProductModel? product;
  const AddOrEditProductDialogWidget({super.key, this.isNew = true, this.product});

  @override
  State<AddOrEditProductDialogWidget> createState() => _AddOrEditProductDialogWidgetState();
}

class _AddOrEditProductDialogWidgetState extends State<AddOrEditProductDialogWidget> {
  late final CancellationToken _token;
  late GlobalKey<FormState> _formKey;
  late TextEditingController _inputCategoryController;
  late TextEditingController _inputSkuController;
  late TextEditingController _inputNameController;
  late TextEditingController _inputDescriptionController;
  late TextEditingController _inputWeightController;
  late TextEditingController _inputWidthController;
  late TextEditingController _inputLengthController;
  late TextEditingController _inputHeightController;
  late TextEditingController _inputPriceController;
  late bool _isNew;
  late ProductModel _product;

  bool get _isValid => _formKey.currentState!.validate();
  String get _inputedCategory => _inputCategoryController.value.text;
  String get _inputedSku => _inputSkuController.value.text;
  String get _inputedName => _inputNameController.value.text;
  String get _inputedDescription => _inputDescriptionController.value.text;
  String get _inputedWeight => _inputWeightController.value.text;
  String get _inputedWidth => _inputWidthController.value.text;
  String get _inputedLength => _inputLengthController.value.text;
  String get _inputedHeight => _inputHeightController.value.text;
  String get _inputedPrice => _inputPriceController.value.text;

  @override
  void initState() {
    super.initState();
    _token = CancellationToken();
    _formKey = GlobalKey<FormState>();
    _inputCategoryController = TextEditingController();
    _inputSkuController = TextEditingController();
    _inputNameController = TextEditingController();
    _inputDescriptionController = TextEditingController();
    _inputWeightController = TextEditingController();
    _inputWidthController = TextEditingController();
    _inputLengthController = TextEditingController();
    _inputHeightController = TextEditingController();
    _inputPriceController = TextEditingController();
    _isNew = widget.isNew;
    _product = !widget.isNew && widget.product != null ? widget.product! : ProductModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              const AppBarLoadingWidget(),
              BlocBuilder<CategoriesCubit, List<CategoryModel>?>(
                builder: (_, categories) {
                  late final CategoryModel? category;

                  if (_isNew) {
                    category = categories?.elementAtOrNull(0);
                  } else {
                    category = categories?.where((CategoryModel c) => c.id == _product.categoryId).toList().first;
                  }

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: categories == null ? 0 : null,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: BlocBuilder<BusyCubit, bool>(
                        builder: (context, isBusy) {
                          return DropdownMenu(
                            enabled: !isBusy,
                            controller: _inputCategoryController,
                            label: const Text('Category'),
                            width: MediaQuery.of(context).size.width - 32,
                            inputDecorationTheme: const InputDecorationTheme(filled: true),
                            initialSelection: category,
                            dropdownMenuEntries: categories == null ? [] : categories.map((CategoryModel c) => DropdownMenuEntry(value: c, label: '${c.name}')).toList(),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
              BlocBuilder<BusyCubit, bool>(builder: (context, isBusy) {
                return TextFormField(
                  enabled: !isBusy,
                  controller: _inputSkuController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  maxLength: 8,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: _isNew ? 'SKU' : _product.sku,
                    prefixIcon: const Icon(Icons.bookmark_outline_outlined),
                  ),
                  validator: (String? value) {
                    if (!_isNew) return null;
                    if (value == null || value.isEmpty) return 'Please fill in SKU field';
                    return null;
                  },
                );
              }),
              BlocBuilder<BusyCubit, bool>(builder: (context, isBusy) {
                return TextFormField(
                  enabled: !isBusy,
                  controller: _inputNameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  maxLength: 64,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: _isNew ? 'Name' : _product.name,
                    prefixIcon: const Icon(Icons.edit_outlined),
                  ),
                  validator: (String? value) {
                    if (!_isNew) return null;
                    if (value == null || value.isEmpty) return 'Please fill in name field';
                    if (value.characters.length < 8) return 'The minimum character is 8';
                    return null;
                  },
                );
              }),
              BlocBuilder<BusyCubit, bool>(builder: (context, isBusy) {
                return TextFormField(
                  enabled: !isBusy,
                  controller: _inputDescriptionController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  maxLength: 255,
                  maxLines: 3,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: _isNew ? 'Description' : _product.description,
                    prefixIcon: const Icon(Icons.edit_outlined),
                  ),
                  validator: (String? value) {
                    if (!_isNew) return null;
                    if (value == null || value.isEmpty) return 'Please fill in description field';
                    if (value.characters.length < 8) return 'The minimum character is 8';
                    return null;
                  },
                );
              }),
              BlocBuilder<BusyCubit, bool>(builder: (context, isBusy) {
                return TextFormField(
                  enabled: !isBusy,
                  controller: _inputWeightController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.number,
                  maxLength: 16,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: _isNew ? 'Weight' : _product.weight.toString(),
                    prefixIcon: const Icon(Icons.line_weight_outlined),
                  ),
                  validator: (String? value) {
                    if (!_isNew) return null;
                    if (value == null || value.isEmpty) return 'Please fill in weight field';
                    return null;
                  },
                );
              }),
              BlocBuilder<BusyCubit, bool>(builder: (context, isBusy) {
                return TextFormField(
                  enabled: !isBusy,
                  controller: _inputWidthController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: _isNew ? 'Width' : _product.width.toString(),
                    prefixIcon: const Icon(Icons.width_wide_outlined),
                  ),
                  validator: (String? value) {
                    if (!_isNew) return null;
                    if (value == null || value.isEmpty) return 'Please fill in width field';
                    return null;
                  },
                );
              }),
              BlocBuilder<BusyCubit, bool>(builder: (context, isBusy) {
                return TextFormField(
                  enabled: !isBusy,
                  controller: _inputLengthController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: _isNew ? 'Length' : _product.length.toString(),
                    prefixIcon: const Icon(Icons.star_border_outlined),
                  ),
                  validator: (String? value) {
                    if (!_isNew) return null;
                    if (value == null || value.isEmpty) return 'Please fill in length field';
                    return null;
                  },
                );
              }),
              BlocBuilder<BusyCubit, bool>(builder: (context, isBusy) {
                return TextFormField(
                  enabled: !isBusy,
                  controller: _inputHeightController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: _isNew ? 'Height' : _product.height.toString(),
                    prefixIcon: const Icon(Icons.height_outlined),
                  ),
                  validator: (String? value) {
                    if (!_isNew) return null;
                    if (value == null || value.isEmpty) return 'Please fill in height field';
                    return null;
                  },
                );
              }),
              BlocBuilder<BusyCubit, bool>(builder: (context, isBusy) {
                return TextFormField(
                  enabled: !isBusy,
                  controller: _inputPriceController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.number,
                  maxLength: 32,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: _isNew ? 'Price' : _product.price.toString(),
                    prefixIcon: const Icon(Icons.monetization_on_outlined),
                  ),
                  validator: (String? value) {
                    if (!_isNew) return null;
                    if (value == null || value.isEmpty) return 'Please fill in price field';
                    return null;
                  },
                );
              }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: BlocBuilder<BusyCubit, bool>(builder: (context, isBusy) {
          return FilledButton(
            onPressed: isBusy ? null : _onSubmitted,
            child: const Text('Submit'),
          );
        }),
      ),
    );
  }

  void _onSubmitted() {
    late final DateTime currentTime;

    if (!_isValid) return;

    currentTime = DateTime.now().toUtc();

    if (_isNew) {
      _product.categoryId = context.read<CategoriesCubit>().state!.where((CategoryModel e) => e.name == _inputedCategory).first.id;
      _product.sku = _inputedSku;
      _product.name = _inputedName;
      _product.description = _inputedDescription;
      _product.weight = int.tryParse(_inputedWeight);
      _product.width = int.tryParse(_inputedWidth);
      _product.length = int.tryParse(_inputedLength);
      _product.height = int.tryParse(_inputedHeight);
      _product.price = int.tryParse(_inputedPrice);
      _product.image = 'https://cf.shopee.co.id/file/7cb930d1bd183a435f4fb3e5cc4a896b';
      _product.createdAt = currentTime;
      _product.updatedAt = currentTime;
    } else {
      _product.categoryId = context.read<CategoriesCubit>().state!.where((CategoryModel e) => e.name == _inputedCategory).first.id;
      _product.sku = _product.sku != _inputedSku && _inputedSku.isNotEmpty ? _inputedSku : _product.sku;
      _product.name = _product.name != _inputedName && _inputedName.isNotEmpty ? _inputedName : _product.name;
      _product.description = _product.description != _inputedDescription && _inputedDescription.isNotEmpty ? _inputedDescription : _product.description;
      _product.weight = _product.weight != int.tryParse(_inputedWeight) && _inputedWeight.isNotEmpty ? int.tryParse(_inputedWeight) : _product.weight;
      _product.width = _product.width != int.tryParse(_inputedWidth) && _inputedWidth.isNotEmpty ? int.tryParse(_inputedWidth) : _product.width;
      _product.length = _product.length != int.tryParse(_inputedLength) && _inputedLength.isNotEmpty ? int.tryParse(_inputedLength) : _product.length;
      _product.height = _product.height != int.tryParse(_inputedHeight) && _inputedHeight.isNotEmpty ? int.tryParse(_inputedHeight) : _product.height;
      _product.price = _product.price != int.tryParse(_inputedPrice) && _inputedPrice.isNotEmpty ? int.tryParse(_inputedPrice) : _product.price;
      _product.image = 'https://cf.shopee.co.id/file/7cb930d1bd183a435f4fb3e5cc4a896b';
      _product.createdAt = currentTime;
      _product.updatedAt = currentTime;
    }

    context.read<ProductsCubit>().send(token: _token, isNew: _isNew, data: _product).then(_callBackSendCategory);
  }

  void _callBackSendCategory(dynamic value) {
    if (value.runtimeType == Null) return;

    showDialog(context: context, builder: (_) => const SuccessDialogWidget(message: 'Data has been saved!')).whenComplete(
      () => _isNew ? Navigator.pop(context) : null,
    );

    // context.read<ProductsCubit>().initialize(token: _token);
    context.read<ProductsCubit>().init(token: _token);
  }

  /*
          Note from kodeaqua
          These code might be no optimal ways, because of using 3rd party's REST API
          So this logic is to get all users, and might be memory or resource leak and causing vulnerability issue
      */
  // Start of unoptimized logic #2
  Future<ProductModel?> _unoptimizedMethod() async {
    late final List<ProductModel>? products;
    late final List<String> mappedProductSku;
    late final int indexOfProduct;

    // response = await TaskUtility.execute(providerToken: _token, function: () => HttpUtility.get(entity: 'products'));
    // if (response.runtimeType == Null) return null;

    // products = ModelFromJsonUtility.products(response);
    // if (products.isEmpty) return null;
    await navigatorKey.currentContext!.read<ProductsCubit>().init(token: _token);
    products = navigatorKey.currentContext!.read<ProductsCubit>().state ?? <ProductModel>[];

    mappedProductSku = products.map((ProductModel p) => p.sku ?? '').toList();
    if (!mappedProductSku.contains(_inputedSku)) return null;

    indexOfProduct = mappedProductSku.indexOf(_inputedSku);

    return products[indexOfProduct];
  }
  // End of unoptimized logic #2

  Future<ProductModel?> _onProcessingRequest() async {
    late final DateTime currentTime;
    late ProductModel product;

    if (_isNew) {
      currentTime = DateTime.now().toUtc();
      product = ProductModel();
      product.categoryId = _inputedCategory;
      product.sku = _inputedSku;
      product.name = _inputedName;
      product.description = _inputedDescription;
      product.weight = int.tryParse(_inputedWeight);
      product.width = int.tryParse(_inputedWidth);
      product.length = int.tryParse(_inputedLength);
      product.height = int.tryParse(_inputedHeight);
      product.price = int.tryParse(_inputedPrice);
      product.image = 'https://cf.shopee.co.id/file/7cb930d1bd183a435f4fb3e5cc4a896b';
      product.createdAt = currentTime;
      product.updatedAt = currentTime;

      // response = await TaskUtility.execute(providerToken: _token, function: () => HttpUtility.post(entity: 'products', data: product));
      // if (response.runtimeType == Null) return null;
      navigatorKey.currentContext!.read<ProductsCubit>().send(token: _token, data: product);
    }

    return await _unoptimizedMethod();
  }

  void _onRequestResultCallback(ProductModel? value) async {
    Navigator.pop(context);

    if (value == null) return;
  }

  void _onSavedCredentialsCallback({required ProductModel value}) {
    // context.read<UserCubit>().set(value);
    // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomeScreen()), (__) => false);
  }
}
