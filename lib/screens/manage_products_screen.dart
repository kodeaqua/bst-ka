import 'package:cancellation_token/cancellation_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:klontong_kodeaqua/widgets/add_or_edit_product_dialog_widget.dart';

import '../cubits/busy_cubit.dart';
import '../cubits/products_cubit.dart';
import '../models/product_model.dart';
import '../widgets/app_bar_loading_widget.dart';
import '../widgets/delete_confirmation_dialog_widget.dart';
import '../widgets/success_dialog_widget.dart';

class ManageProductsScreen extends StatefulWidget {
  const ManageProductsScreen({super.key});

  @override
  State<ManageProductsScreen> createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  late final CancellationToken _token;
  late String _searched;
  late final TextEditingController _searchController;
  ProductModel? _activeProduct;

  @override
  void initState() {
    super.initState();

    _token = CancellationToken();
    _searched = '';
    _searchController = SearchController();
    _searchController.addListener(_searchListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // context.read<ProductsCubit>().initialize(token: _token);
      context.read<ProductsCubit>().init(token: _token);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _token.cancel();
    _searchController.dispose();
    _activeProduct = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: RefreshIndicator(
        // onRefresh: () => context.read<ProductsCubit>().initialize(token: _token),
        onRefresh: () => context.read<ProductsCubit>().init(token: _token),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SearchBar(
                controller: _searchController,
                elevation: WidgetStateProperty.all(0),
                hintText: 'Search product(s)',
                padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 16)),
                trailing: const <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(Icons.search_outlined),
                  ),
                ],
              ),
            ),
            const AppBarLoadingWidget(),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: BlocBuilder<ProductsCubit, List<ProductModel>?>(
                  builder: (_, products) {
                    late final List<ProductModel> productsFix;

                    if (products == null) {
                      return const Center(
                        child: Text('Loading data...'),
                      );
                    }

                    if (products.isEmpty) {
                      return const Center(
                        child: Text("There's no data :("),
                      );
                    }

                    productsFix = _searched.isEmpty ? products : products.where((ProductModel p) => '${p.name}'.toLowerCase().contains(_searched)).toList();

                    if (_searched.isNotEmpty && productsFix.isEmpty) {
                      return const Center(
                        child: Text("Not found any data"),
                      );
                    }

                    return ListView.builder(
                      itemCount: productsFix.length,
                      itemBuilder: (_, int index) {
                        final ProductModel p = productsFix.elementAt(index);

                        return BlocBuilder<BusyCubit, bool>(builder: (_, isBusy) {
                          return InkWell(
                            onTap: isBusy ? null : () => _toAddOrEditProductPage(isNew: false, product: p),
                            onLongPress: isBusy ? null : () => _showDeleteCategoryDialog(value: p),
                            borderRadius: BorderRadius.circular(12),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text('${p.name?.characters.first}'),
                              ),
                              title: Text('${p.name}'),
                              subtitle: Text('Created at ${p.createdAt != null ? DateFormat('EEEE, dd MM yyyy - hh:mm').format(p.createdAt!) : 'Unknown'}'),
                            ),
                          );
                        });
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: BlocBuilder<BusyCubit, bool>(
        builder: (context, isBusy) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: isBusy
                ? const SizedBox()
                : FloatingActionButton.extended(
                    onPressed: _toAddOrEditProductPage,
                    icon: const Icon(Icons.add_outlined),
                    label: const Text('Product'),
                  ),
          );
        },
      ),
    );
  }

  void _searchListener() => setState(() => _searched = _searchController.value.text);

  void _toAddOrEditProductPage({bool isNew = true, ProductModel? product}) {
    _activeProduct = product;

    Navigator.push(context, MaterialPageRoute(builder: (_) => AddOrEditProductDialogWidget(isNew: isNew, product: _activeProduct)));
  }

  void _showDeleteCategoryDialog({required ProductModel value}) {
    _activeProduct = value;

    showDialog<bool?>(
      context: context,
      builder: (_) => DeleteConfirmationDialogWidget(name: '${value.name}'),
    ).then(_callBackDeleteCategory);
  }

  void _callBackDeleteCategory(bool? value) {
    if (value == null || !value) {
      _activeProduct = null;
      return;
    }

    context.read<ProductsCubit>().deleteById(token: _token, id: _activeProduct!.id!).then(_callBackDeleteCategoryCompleted);
  }

  void _callBackDeleteCategoryCompleted(dynamic value) {
    if (value.runtimeType == Null) return;

    showDialog(context: context, builder: (_) => const SuccessDialogWidget(message: 'Data has been deleted!'));

    _activeProduct = null;
    // context.read<ProductsCubit>().initialize(token: _token);
    context.read<ProductsCubit>().init(token: _token);
  }
}
