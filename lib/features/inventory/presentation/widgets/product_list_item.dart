import 'package:easy_box/core/extensions/context_extension.dart';
import 'package:easy_box/features/inventory/domain/entities/product.dart';
import 'package:flutter/material.dart';

class ProductListItem extends StatelessWidget {
  final Product product;

  const ProductListItem({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.name),
      subtitle: Text(product.sku),
      trailing: Text(
        '${product.quantity} pcs', // TODO: Localize "pcs"
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
