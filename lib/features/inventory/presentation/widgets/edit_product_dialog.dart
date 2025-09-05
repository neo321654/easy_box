import 'dart:io';

import 'package:easy_box/core/extensions/context_extension.dart';
import 'package:easy_box/core/utils/app_dimensions.dart';
import 'package:easy_box/core/widgets/image_source_sheet.dart';
import 'package:easy_box/features/inventory/domain/entities/product.dart';
import 'package:easy_box/features/inventory/presentation/widgets/product_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _skuController = TextEditingController(text: widget.product.sku);
    _quantityController =
        TextEditingController(text: widget.product.quantity.toString());
    _locationController = TextEditingController(text: widget.product.location);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _quantityController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final source = await showImageSourceSheet(context);
    if (source == null) return;

    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.S.editProductDialogTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: AppDimensions.productImageSmallSize,
                width: AppDimensions.productImageSmallSize,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(AppDimensions.small),
                  border: Border.all(color: Colors.grey),
                ),
                child: _imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(AppDimensions.small),
                        child: Image.file(
                          _imageFile!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : ProductImage(
                        imageUrl: widget.product.imageUrl,
                        width: AppDimensions.productImageSmallSize,
                        height: AppDimensions.productImageSmallSize,
                      ),
              ),
            ),
            const SizedBox(height: AppDimensions.medium),
            TextFormField(
              controller: _nameController,
              decoration:
                  InputDecoration(labelText: context.S.productNameLabel),
            ),
            const SizedBox(height: AppDimensions.medium),
            TextFormField(
              controller: _skuController,
              decoration:
                  InputDecoration(labelText: context.S.productSkuLabel),
            ),
            const SizedBox(height: AppDimensions.medium),
            TextFormField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: context.S.quantityLabel),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppDimensions.medium),
            TextFormField(
              controller: _locationController,
              decoration:
                  InputDecoration(labelText: context.S.productLocationLabel),
            ),
          ],
        ),
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
              imageUrl: _imageFile?.path ?? widget.product.imageUrl,
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
