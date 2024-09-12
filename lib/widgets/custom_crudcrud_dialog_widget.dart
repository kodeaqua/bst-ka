import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klontong_kodeaqua/cubits/active_server_cubit.dart';

class CustomCrudCrudDialogWidget extends StatefulWidget {
  const CustomCrudCrudDialogWidget({super.key});

  @override
  State<CustomCrudCrudDialogWidget> createState() => _CustomCrudCrudDialogWidgetState();
}

class _CustomCrudCrudDialogWidgetState extends State<CustomCrudCrudDialogWidget> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _inputIdController;

  bool get _isValid => _formKey.currentState!.validate();
  String get _inputedId => _inputIdController.value.text;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _inputIdController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _inputIdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Custom CRUDCRUD'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _inputIdController,
          decoration: const InputDecoration(label: Text('Identifier')),
          validator: (String? value) => value == null || value.isEmpty ? 'Please fill in the field' : null,
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (!_isValid) return;
            context.read<ActiveServerCubit>().set(value: _inputedId);
            context.read<ActiveServerCubit>().save();
            Navigator.pop(context);
          },
          child: const Text('Confirm'),
        )
      ],
    );
  }
}
