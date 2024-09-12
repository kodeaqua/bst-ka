import 'package:cancellation_token/cancellation_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:klontong_kodeaqua/utilities/task_utility_new.dart';

import '../cubits/busy_cubit.dart';
import '../cubits/categories_cubit.dart';
import '../models/category_model.dart';
import '../widgets/add_or_edit_category_dialog_widget.dart';
import '../widgets/app_bar_loading_widget.dart';
import '../widgets/delete_confirmation_dialog_widget.dart';
import '../widgets/success_dialog_widget.dart';

class ManageCategoriesScreen extends StatefulWidget {
  const ManageCategoriesScreen({super.key});

  @override
  State<ManageCategoriesScreen> createState() => _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState extends State<ManageCategoriesScreen> {
  late final CancellationToken _token;
  late String _searched;
  late final TextEditingController _searchController;
  bool? _isNew;
  CategoryModel? _activeCategory;

  @override
  void initState() {
    super.initState();

    _token = CancellationToken();
    _searched = '';
    _searchController = SearchController();
    _searchController.addListener(_searchListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // context.read<CategoriesCubit>().initialize(token: _token);
      context.read<CategoriesCubit>().init(token: _token);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _token.cancel();
    _searchController.dispose();
    _isNew = null;
    _activeCategory = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: RefreshIndicator(
        // onRefresh: () => context.read<CategoriesCubit>().initialize(token: _token),
        onRefresh: () => context.read<CategoriesCubit>().init(token: _token),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SearchBar(
                controller: _searchController,
                elevation: WidgetStateProperty.all(0),
                hintText: 'Search categories',
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
                child: BlocBuilder<CategoriesCubit, List<CategoryModel>?>(
                  builder: (_, categories) {
                    late final List<CategoryModel> categoriesFix;

                    if (categories == null) {
                      return const Center(
                        child: Text('Loading data...'),
                      );
                    }

                    if (categories.isEmpty) {
                      return const Center(
                        child: Text("There's no data :("),
                      );
                    }

                    categoriesFix = _searched.isEmpty ? categories : categories.where((CategoryModel c) => '${c.name}'.toLowerCase().contains(_searched)).toList();

                    if (_searched.isNotEmpty && categoriesFix.isEmpty) {
                      return const Center(
                        child: Text("Not found any data"),
                      );
                    }

                    return ListView.builder(
                      itemCount: categoriesFix.length,
                      itemBuilder: (_, int index) {
                        final CategoryModel c = categoriesFix.elementAt(index);

                        return BlocBuilder<BusyCubit, bool>(builder: (_, isBusy) {
                          return InkWell(
                            onTap: isBusy ? null : () => _showAddOrEditCategoryDialog(isNew: false, category: c),
                            onLongPress: isBusy ? null : () => _showDeleteCategoryDialog(value: c),
                            borderRadius: BorderRadius.circular(12),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text('${c.name?.characters.first}'),
                              ),
                              title: Text('${c.name}'),
                              subtitle: Text('Created at ${c.createdAt != null ? DateFormat('EEEE, dd MM yyyy - hh:mm').format(c.createdAt!) : 'Unknown'}'),
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
                    onPressed: _showAddOrEditCategoryDialog,
                    icon: const Icon(Icons.add_outlined),
                    label: const Text('Category'),
                  ),
          );
        },
      ),
    );
  }

  void _searchListener() => setState(() => _searched = _searchController.value.text);

  void _showAddOrEditCategoryDialog({bool isNew = true, CategoryModel? category}) {
    _isNew = isNew;
    _activeCategory = category;

    showDialog<CategoryModel?>(context: context, builder: (_) => AddOrEditCategoryDialogWidget(isNew: _isNew!, category: _activeCategory)).then(_callBackAddOrEditCategory);
  }

  void _callBackAddOrEditCategory(CategoryModel? value) {
    if (value == null) {
      _isNew = null;
      _activeCategory = null;
      return;
    }

    _activeCategory = value;
    // context.read<CategoriesCubit>().send(token: _token, isNew: _isNew!, data: _activeCategory!).then(_callBackSendCategory);
    context.read<CategoriesCubit>().send(token: _token, isNew: _isNew!, data: _activeCategory!).then(_callBackSendCategory);
  }

  void _callBackSendCategory(TaskResult result) {
    if (result.result == null) return;

    showDialog(context: context, builder: (_) => const SuccessDialogWidget(message: 'Data has been saved!'));

    _isNew = null;
    _activeCategory = null;
    // context.read<CategoriesCubit>().initialize(token: _token);
    context.read<CategoriesCubit>().init(token: _token);
  }

  void _showDeleteCategoryDialog({required CategoryModel value}) {
    _activeCategory = value;

    showDialog<bool?>(
      context: context,
      builder: (_) => DeleteConfirmationDialogWidget(name: '${value.name}'),
    ).then(_callBackDeleteCategory);
  }

  void _callBackDeleteCategory(bool? value) {
    if (value == null || !value) {
      _activeCategory = null;
      return;
    }

    // context.read<CategoriesCubit>().deleteById(token: _token, id: _activeCategory!.id!).then(_callBackDeleteCategoryCompleted);
    context.read<CategoriesCubit>().deleteById(token: _token, id: _activeCategory!.id!).then(_callBackDeleteCategoryCompleted);
  }

  void _callBackDeleteCategoryCompleted(TaskResult value) {
    if (value.result == null) return;

    showDialog(context: context, builder: (_) => const SuccessDialogWidget(message: 'Data has been deleted!'));

    _activeCategory = null;
    // context.read<CategoriesCubit>().initialize(token: _token);
    context.read<CategoriesCubit>().init(token: _token);
  }
}
