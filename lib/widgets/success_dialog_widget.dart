import 'package:flutter/material.dart';

class SuccessDialogWidget extends StatelessWidget {
  final String message;
  const SuccessDialogWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.check_outlined),
      title: const Text('Yay, success!'),
      content: Text(message),
      actions: <Widget>[
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
