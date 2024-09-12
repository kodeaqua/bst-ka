import 'package:flutter/material.dart';
import 'package:klontong_kodeaqua/models/product_model.dart';
import 'package:klontong_kodeaqua/widgets/product_image_dialog_widget.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductImageDialogWidget(productId: '${widget.product.id}', url: '${widget.product.image}'))),
              child: SizedBox(
                height: 256,
                child: Center(
                  child: Hero(
                    tag: 'product-image-${widget.product.id}',
                    child: Image.network('${widget.product.image}', width: double.infinity, fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            title: Text('${widget.product.name}'),
            titleTextStyle: Theme.of(context).textTheme.headlineLarge,
            subtitle: Text('${widget.product.price}'),
            subtitleTextStyle: Theme.of(context).textTheme.bodyLarge,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Card.filled(
              child: ListTile(
                title: const Text('Description'),
                subtitle: Text('${widget.product.description}'),
                isThreeLine: true,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Card.filled(
              child: ExpansionTile(
                title: const Text('Other details'),
                shape: const RoundedRectangleBorder(side: BorderSide.none),
                collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
                children: <Widget>[
                  Divider(height: 1, thickness: 1, color: Theme.of(context).colorScheme.surface),
                  ListTile(
                    leading: const Icon(Icons.bookmark_outline_outlined),
                    title: const Text('SKU'),
                    trailing: Text('${widget.product.sku}', style: Theme.of(context).textTheme.labelLarge),
                  ),
                  Divider(height: 1, thickness: 1, color: Theme.of(context).colorScheme.surface),
                  ListTile(
                    leading: const Icon(Icons.line_weight_outlined),
                    title: const Text('Weight'),
                    trailing: Text('${widget.product.weight} g', style: Theme.of(context).textTheme.labelLarge),
                  ),
                  Divider(height: 1, thickness: 1, color: Theme.of(context).colorScheme.surface),
                  ListTile(
                    leading: const Icon(Icons.width_wide_outlined),
                    title: const Text('Width'),
                    trailing: Text('${widget.product.width} cm', style: Theme.of(context).textTheme.labelLarge),
                  ),
                  Divider(height: 1, thickness: 1, color: Theme.of(context).colorScheme.surface),
                  ListTile(
                    leading: const Icon(Icons.star_border_outlined),
                    title: const Text('Length'),
                    trailing: Text('${widget.product.length} cm', style: Theme.of(context).textTheme.labelLarge),
                  ),
                  Divider(height: 1, thickness: 1, color: Theme.of(context).colorScheme.surface),
                  ListTile(
                    leading: const Icon(Icons.height_outlined),
                    title: const Text('Height'),
                    trailing: Text('${widget.product.height} cm', style: Theme.of(context).textTheme.labelLarge),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: const Text('Reviews'),
            titleTextStyle: Theme.of(context).textTheme.titleLarge,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (_, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Card.outlined(
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.person_outlined),
                    ),
                    title: const Text('User *********'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        5,
                        (index) {
                          return Icon(
                            Icons.star,
                            color: Theme.of(context).colorScheme.primary,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.shopping_bag_outlined),
                label: const Text('Add to cart'),
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
            Expanded(
              child: FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.monetization_on_outlined),
                label: const Text('Buy now'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
