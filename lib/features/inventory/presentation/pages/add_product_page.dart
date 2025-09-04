import 'dart:io';

import 'package:easy_box/core/extensions/context_extension.dart';
import 'package:easy_box/core/widgets/widgets.dart';
import 'package:easy_box/di/injection_container.dart';
import 'package:easy_box/features/inventory/presentation/bloc/product_creation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddProductPage extends StatelessWidget {
  const AddProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProductCreationBloc>(),
      child: const _AddProductView(),
    );
  }
}

class _AddProductView extends StatefulWidget {
  const _AddProductView();

  @override
  State<_AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<_AddProductView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _skuController;
  late final TextEditingController _locationController;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _skuController = TextEditingController();
    _locationController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.S.selectImageSource),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(context.S.camera),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(context.S.gallery),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _createProduct() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ProductCreationBloc>().add(
            ProductCreateRequested(
              name: _nameController.text,
              sku: _skuController.text,
              location: _locationController.text.isEmpty
                  ? null
                  : _locationController.text,
              imageUrl: _imageFile?.path,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.S.addProductPageTitle),
      ),
      body: BlocListener<ProductCreationBloc, ProductCreationState>(
        listener: (context, state) {
          if (state is ProductCreationSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                    content: Text(context.S.productCreatedSuccessfully +
                        (state.isQueued ? context.S.offlineIndicator : '')),
                    backgroundColor: Colors.green),
              );
            Navigator.of(context).pop(); // Go back after successful creation
          } else if (state is ProductCreationFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                    content: Text(context.S.failedToCreateProduct),
                    backgroundColor: Colors.red),
              );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _showImageSourceDialog,
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: _imageFile != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                _imageFile!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.add_a_photo, size: 40),
                                  const SizedBox(height: 8),
                                  Text(context.S.addProductImage),
                                ],
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: context.S.productNameLabel,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) => (value?.isEmpty ?? true)
                        ? context.S.pleaseEnterProductNameError
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _skuController,
                    decoration: InputDecoration(
                      labelText: context.S.productSkuLabel,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) => (value?.isEmpty ?? true)
                        ? context.S.pleaseEnterSkuError
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      labelText: context.S.productLocationLabel,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<ProductCreationBloc, ProductCreationState>(
                    builder: (context, state) {
                      if (state is ProductCreationLoading) {
                        return const LoadingIndicator();
                      }
                      return PrimaryButton(
                        onPressed: _createProduct,
                        text: context.S.saveButtonText,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
