import 'package:flutter/material.dart';

class DeleteConfirmationDialogWidget extends StatelessWidget {
  final String name;
  const DeleteConfirmationDialogWidget({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Are you sure want to delete this "$name" ? '),
      content: const Text('This action will affect permanently'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
