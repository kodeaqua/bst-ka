import 'package:flutter/material.dart';

import '../models/category_model.dart';

class AddOrEditCategoryDialogWidget extends StatefulWidget {
  final bool isNew;
  final CategoryModel? category;
  const AddOrEditCategoryDialogWidget({super.key, this.isNew = true, this.category});

  @override
  State<AddOrEditCategoryDialogWidget> createState() => _AddOrEditCategoryDialogWidgetState();
}

class _AddOrEditCategoryDialogWidgetState extends State<AddOrEditCategoryDialogWidget> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _inputNameController;
  late bool _isNew;
  late CategoryModel _category;
  late DateTime currentTime;

  bool get _isValid => _formKey.currentState!.validate();

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _inputNameController = TextEditingController();
    _isNew = widget.isNew;
    _category = !widget.isNew && widget.category != null ? widget.category! : CategoryModel();
  }

  @override
  void dispose() {
    super.dispose();
    _inputNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isNew ? 'New Category' : 'Edit Category'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _inputNameController,
          decoration: InputDecoration(labelText: _isNew ? 'Name' : _category.name),
          validator: (String? value) => value == null || value.isEmpty ? 'Please fill the name field' : null,
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _onSubmitTapped,
          child: const Text('Submit'),
        ),
      ],
    );
  }

  void _onSubmitTapped() {
    if (!_isValid) return;

    currentTime = DateTime.now().toUtc();
    _category.name = _inputNameController.value.text;
    _category.updatedAt = currentTime;
    if (_isNew) _category.createdAt = currentTime;

    Navigator.pop(context, _category);
  }
}
