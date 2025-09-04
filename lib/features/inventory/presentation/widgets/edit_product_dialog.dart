import 'package:easy_box/core/extensions/context_extension.dart';
import 'package:easy_box/features/inventory/domain/entities/product.dart';
import 'package:flutter/material.dart';

class EditProductDialog extends StatefulWidget {
  final Product product;
  final Function(Product) onUpdate;

  const EditProductDialog({
    super.key,
    required this.product,
    required this.onUpdate,
  });

  @override
  State<EditProductDialog> createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _skuController;
  late final TextEditingController _quantityController;
  late final TextEditingController _locationController;
  late final TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _skuController = TextEditingController(text: widget.product.sku);
    _quantityController =
        TextEditingController(text: widget.product.quantity.toString());
    _locationController = TextEditingController(text: widget.product.location);
    _imageUrlController = TextEditingController(text: widget.product.imageUrl);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _quantityController.dispose();
    _locationController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
          TextField(
            controller: _locationController,
            decoration:
                InputDecoration(labelText: context.S.productLocationLabel),
          ),
          TextField(
            controller: _imageUrlController,
            decoration:
                InputDecoration(labelText: context.S.productImageUrlLabel),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
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
              location: _locationController.text,
              imageUrl: _imageUrlController.text,
            );
            widget.onUpdate(updatedProduct);
            Navigator.of(context).pop();
          },
          child: Text(context.S.saveButtonText),
        ),
      ],
    );
  }
}
