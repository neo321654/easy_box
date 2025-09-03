import 'package:easy_box/core/extensions/context_extension.dart';
import 'package:easy_box/features/inventory/domain/entities/product.dart';
import 'package:easy_box/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:easy_box/features/inventory/presentation/pages/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductListItem extends StatelessWidget {
  final Product product;

  const ProductListItem({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: product),
          ),
        );
        // If result is a Product, it means it was updated. If true, it was deleted.
        if (result is Product || result == true) {
          // Refresh the inventory list
          context.read<InventoryBloc>().add(FetchProductsRequested());
        }
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
