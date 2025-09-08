import 'package:easy_box/core/extensions/context_extension.dart';
import 'package:easy_box/features/inventory/domain/entities/product.dart';
import 'package:easy_box/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:easy_box/features/inventory/presentation/pages/product_detail_page.dart';
import 'package:easy_box/features/inventory/presentation/widgets/product_image.dart';
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
    final urlForImage = product.thumbnailUrl ?? product.imageUrl;
    // ignore: avoid_print
    print(
        '[DEBUG] ProductListItem for SKU ${product.sku}: Using URL: $urlForImage (Thumbnail: ${product.thumbnailUrl}, Image: ${product.imageUrl})');

    return InkWell(
      key: ValueKey('product_list_item_${product.sku}'),
      onTap: () async {
        final result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: product),
          ),
        );
        if (!context.mounted) return; // Add this line
        // If result is a Product, it means it was updated. If true, it was deleted.
        if (result is Product || result == true) {
          // Refresh the inventory list
          context.read<InventoryBloc>().add(FetchProductsRequested());
        }
      },
      child: ListTile(
        leading: SizedBox(
          width: 50,
          height: 50,
          child: ProductImage(
            imageUrl: product.thumbnailUrl ?? product.imageUrl,
          ),
        ),
        title: Text(product.name),
        subtitle: Text('${product.sku} - ${product.location ?? ''}'),
        trailing: Text(
          context.S.nPieces(product.quantity),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}