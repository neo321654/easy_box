import 'package:easy_box/core/extensions/context_extension.dart';
import 'package:easy_box/core/utils/app_dimensions.dart';
import 'package:easy_box/core/widgets/app_snack_bar.dart';
import 'package:easy_box/core/widgets/widgets.dart';
import 'package:easy_box/di/injection_container.dart';
import 'package:easy_box/features/inventory/domain/entities/product.dart';
import 'package:easy_box/features/inventory/presentation/bloc/product_detail_bloc.dart';
import 'package:easy_box/features/inventory/presentation/widgets/edit_product_dialog.dart';
import 'package:easy_box/features/inventory/presentation/widgets/product_image.dart';
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
          context.read<ProductDetailBloc>().add(UpdateProductRequested(updatedProduct));
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
              .add(DeleteProductRequested(widget.product.id));
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
            showAppSnackBar(
                context,
                message +
                    (state.isQueued ? context.S.offlineIndicator : ''));
            if (state.type == ProductDetailSuccessType.updated) {
              Navigator.of(context).pop(state.updatedProduct);
            } else if (state.type == ProductDetailSuccessType.deleted) {
              Navigator.of(context).pop(true);
            }
          } else if (state is ProductUpdateFailure) {
            showAppSnackBar(
                context, context.S.failedToUpdateProductMessage, isError: true);
          } else if (state is ProductDeleteFailure) {
            showAppSnackBar(
                context, context.S.failedToDeleteProductMessage, isError: true);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductImage(
                imageUrl: widget.product.imageUrl,
                width: MediaQuery.of(context).size.width - (AppDimensions.medium * 2),
                height: AppDimensions.productImageHeight,
              ),
              const SizedBox(height: AppDimensions.medium),
              Text(
                '${context.S.productSkuLabel}: ${widget.product.sku}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppDimensions.small),
              Text(
                '${context.S.quantityLabel}: ${widget.product.quantity}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppDimensions.small),
              if (widget.product.location != null && widget.product.location!.isNotEmpty)
                Text(
                  context.S.productLocationLabelWithColon(widget.product.location!),
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
