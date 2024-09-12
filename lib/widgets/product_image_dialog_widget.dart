import 'package:flutter/material.dart';

class ProductImageDialogWidget extends StatelessWidget {
  final String productId;
  final String url;
  const ProductImageDialogWidget({super.key, required this.productId, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: productId,
          child: Image.network(url),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: FilledButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_outlined),
          label: const Text('Back'),
        ),
      ),
    );
  }
}
