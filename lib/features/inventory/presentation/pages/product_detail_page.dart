import 'package:easy_box/core/extensions/context_extension.dart';
import 'package:easy_box/core/utils/app_dimensions.dart';
import 'package:easy_box/core/widgets/app_snack_bar.dart';
import 'package:easy_box/core/widgets/widgets.dart';
import 'package:easy_box/di/injection_container.dart';
import 'package:easy_box/features/inventory/domain/entities/product.dart';
import 'package:easy_box/features/inventory/presentation/bloc/product_detail_bloc.dart';
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
  late Product _currentProduct;
  bool _isEditing = false;

  late final TextEditingController _nameController;
  late final TextEditingController _skuController;
  late final TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _currentProduct = widget.product;
    _nameController = TextEditingController(text: _currentProduct.name);
    _skuController = TextEditingController(text: _currentProduct.sku);
    _locationController = TextEditingController(text: _currentProduct.location);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        // Reset controllers if canceling edit
        _nameController.text = _currentProduct.name;
        _skuController.text = _currentProduct.sku;
        _locationController.text = _currentProduct.location ?? '';
      }
    });
  }

  void _saveChanges() {
    final updatedProduct = Product(
      id: _currentProduct.id,
      name: _nameController.text,
      sku: _skuController.text,
      quantity: _currentProduct.quantity,
      location: _locationController.text,
      imageUrl: _currentProduct.imageUrl,
    );
    context.read<ProductDetailBloc>().add(UpdateProductRequested(updatedProduct));
    _toggleEditMode();
  }

  void _updateQuantity(int change) {
    final newQuantity = _currentProduct.quantity + change;
    if (newQuantity >= 0) {
      final updatedProduct = Product(
        id: _currentProduct.id,
        name: _currentProduct.name,
        sku: _currentProduct.sku,
        quantity: newQuantity,
        location: _currentProduct.location,
        imageUrl: _currentProduct.imageUrl,
      );
      context.read<ProductDetailBloc>().add(UpdateProductRequested(updatedProduct));
    }
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmationDialog(
        title: context.S.deleteProductDialogTitle,
        content: Text(context.S.deleteConfirmationMessage(_currentProduct.name)),
        confirmButtonText: context.S.deleteButtonText,
        onConfirm: () {
          context
              .read<ProductDetailBloc>()
              .add(DeleteProductRequested(_currentProduct.id));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? context.S.editProductDialogTitle : _currentProduct.name),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: _toggleEditMode,
            )
          else
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _toggleEditMode,
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
              setState(() {
                _currentProduct = state.updatedProduct!;
              });
              // Exit edit mode on successful update
              if(_isEditing) {
                _toggleEditMode();
              }
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
                imageUrl: _currentProduct.imageUrl,
                width: MediaQuery.of(context).size.width - (AppDimensions.medium * 2),
                height: AppDimensions.productImageHeight,
              ),
              const SizedBox(height: AppDimensions.medium),
              _isEditing ? _buildEditView() : _buildViewView(),
            ],
          ),
        ),
      ),
      floatingActionButton: _isEditing
          ? FloatingActionButton.extended(
              onPressed: _saveChanges,
              label: Text(context.S.saveButtonText),
              icon: const Icon(Icons.save),
            )
          : null,
    );
  }

  Widget _buildViewView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${context.S.productSkuLabel}: ${_currentProduct.sku}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppDimensions.small),
        Row(
          children: [
            Text(
              '${context.S.quantityLabel}: ',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () => _updateQuantity(-1),
            ),
            Text(
              '${_currentProduct.quantity}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => _updateQuantity(1),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.small),
        if (_currentProduct.location != null && _currentProduct.location!.isNotEmpty)
          Text(
            context.S.productLocationLabelWithColon(_currentProduct.location!),
            style: Theme.of(context).textTheme.titleMedium,
          ),
      ],
    );
  }

  Widget _buildEditView() {
    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(labelText: context.S.productNameLabel),
        ),
        const SizedBox(height: AppDimensions.medium),
        TextFormField(
          controller: _skuController,
          decoration: InputDecoration(labelText: context.S.productSkuLabel),
        ),
        const SizedBox(height: AppDimensions.medium),
        TextFormField(
          controller: _locationController,
          decoration: InputDecoration(labelText: context.S.productLocationLabel),
        ),
      ],
    );
  }
}