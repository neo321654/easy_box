import 'package:easy_box/core/extensions/context_extension.dart';
import 'package:easy_box/features/inventory/domain/entities/product.dart';
import 'package:easy_box/features/inventory/presentation/pages/product_detail_page.dart';
import 'package:flutter/material.dart';

class ProductListItem extends StatelessWidget {
  final Product product;

  const ProductListItem({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: product),
          ),
        );
      },
      child: ListTile(
        title: Text(product.name),
        subtitle: Text(product.sku),
        trailing: Text(
          context.S.nPieces(product.quantity),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
