import 'package:easy_box/core/extensions/context_extension.dart';
import 'package:easy_box/core/widgets/widgets.dart';
import 'package:easy_box/di/injection_container.dart';
import 'package:easy_box/features/inventory/domain/entities/product.dart';
import 'package:easy_box/features/inventory/presentation/bloc/product_detail_bloc.dart';
import 'package:easy_box/features/inventory/presentation/widgets/edit_product_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProductDetailBloc>(),
      child: _ProductDetailView(product: product),
    );
  }
}

class _ProductDetailView extends StatefulWidget {
  final Product product;

  const _ProductDetailView({required this.product});

  @override
  State<_ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<_ProductDetailView> {
  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (ctx) => EditProductDialog(
        product: widget.product,
        onUpdate: (updatedProduct) {
          context.read<ProductDetailBloc>().add(ProductUpdated(updatedProduct));
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmationDialog(
        title: context.S.deleteProductDialogTitle,
        content: Text(context.S.deleteConfirmationMessage(widget.product.name)),
        confirmButtonText: context.S.deleteButtonText,
        onConfirm: () {
          context
              .read<ProductDetailBloc>()
              .add(ProductDeleted(widget.product.id));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _showEditDialog,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _showDeleteConfirmationDialog,
          ),
        ],
      ),
      body: BlocListener<ProductDetailBloc, ProductDetailState>(
        listener: (context, state) {
          if (state is ProductDetailSuccess) {
            final message = state.type == ProductDetailSuccessType.updated
                ? context.S.productUpdatedSuccessfullyMessage
                : context.S.productDeletedSuccessfullyMessage;
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                  content: Text(
                      message + (state.isQueued ? context.S.offlineIndicator : '')),
                  backgroundColor: Colors.green));
            if (state.type == ProductDetailSuccessType.updated) {
              Navigator.of(context).pop(state.updatedProduct);
            } else if (state.type == ProductDetailSuccessType.deleted) {
              Navigator.of(context).pop(true);
            }
          } else if (state is ProductUpdateFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                  content: Text(context.S.failedToUpdateProductMessage),
                  backgroundColor: Colors.red));
          } else if (state is ProductDeleteFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                  content: Text(context.S.failedToDeleteProductMessage),
                  backgroundColor: Colors.red));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${context.S.productSkuLabel}: ${widget.product.sku}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '${context.S.quantityLabel}: ${widget.product.quantity}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              // TODO: Add more product details if available
            ],
          ),
        ),
      ),
    );
  }
}