import 'package:easy_box/core/extensions/context_extension.dart';
import 'package:easy_box/di/injection_container.dart';
import 'package:easy_box/features/inventory/domain/entities/product.dart';
import 'package:easy_box/features/inventory/presentation/bloc/product_detail_bloc.dart';
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
  late TextEditingController _nameController;
  late TextEditingController _skuController;
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _skuController = TextEditingController(text: widget.product.sku);
    _quantityController = TextEditingController(text: widget.product.quantity.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.S.editProductDialogTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: context.S.productNameLabel),
            ),
            TextField(
              controller: _skuController,
              decoration: InputDecoration(labelText: context.S.productSkuLabel),
            ),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: context.S.quantityLabel),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text(context.S.cancelButtonText),
          ),
          ElevatedButton(
            onPressed: () {
              final updatedProduct = Product(
                id: widget.product.id,
                name: _nameController.text,
                sku: _skuController.text,
                quantity: int.tryParse(_quantityController.text) ?? 0,
              );
              context.read<ProductDetailBloc>().add(ProductUpdated(updatedProduct));
              Navigator.of(ctx).pop(); // Pop dialog
            },
            child: Text(context.S.saveButtonText),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.S.deleteProductDialogTitle),
        content: Text(context.S.deleteConfirmationMessage(widget.product.name)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text(context.S.cancelButtonText),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ProductDetailBloc>().add(ProductDeleted(widget.product.id));
              Navigator.of(ctx).pop(); // Pop dialog
              // Navigator.of(context).pop(); // Pop detail page after deletion - this will be handled by listener
            },
            child: Text(context.S.deleteButtonText),
          ),
        ],
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
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.green));
            // If update was successful, pop the detail page and return true
            if (state.message == context.S.productUpdatedSuccessfullyMessage) {
              Navigator.of(context).pop(true);
            } else if (state.message == context.S.productDeletedSuccessfullyMessage) {
              Navigator.of(context).pop(true); // Pop detail page after deletion
            }
          } else if (state is ProductDetailFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
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
