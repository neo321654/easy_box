import 'dart:io';

import 'package:easy_box/core/extensions/context_extension.dart';
import 'package:easy_box/core/utils/app_dimensions.dart';
import 'package:easy_box/shared/widgets/app_snack_bar.dart';
import 'package:easy_box/shared/widgets/image_source_sheet.dart';
import 'package:easy_box/shared/widgets/widgets.dart';
import 'package:easy_box/features/inventory/presentation/bloc/product_creation_bloc.dart';
import 'package:easy_box/core/utils/scanner_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddProductForm extends StatefulWidget {
  final String? initialSku;

  const AddProductForm({super.key, this.initialSku});

  @override
  State<AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _skuController;
  late final TextEditingController _locationController;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _skuController = TextEditingController(text: widget.initialSku);
    _locationController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
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

  Future<void> _scanBarcode() async {
    final sku = await scanBarcode(context);
    if (sku != null && mounted) {
      _skuController.text = sku;
    }
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
    return BlocListener<ProductCreationBloc, ProductCreationState>(
      listener: (context, state) {
        if (state is ProductCreationSuccess) {
          showAppSnackBar(
            context,
            context.S.productCreatedSuccessfully +
                (state.isQueued ? context.S.offlineIndicator : ''),
          );
          Navigator.of(context).pop(true); // Go back after successful creation
        } else if (state is ProductCreationFailure) {
          showAppSnackBar(
            context,
            state.message,
            isError: true,
          );
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: AppDimensions.medium,
            right: AppDimensions.medium,
            top: AppDimensions.medium,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.S.addProductPageTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppDimensions.large),
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
                            borderRadius: BorderRadius.circular(
                              AppDimensions.small,
                            ),
                            child: Image.file(_imageFile!, fit: BoxFit.cover),
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.add_a_photo, size: 40),
                                const SizedBox(height: AppDimensions.small),
                                Text(context.S.addProductImage),
                              ],
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: AppDimensions.large),
                TextFormField(
                  key: const ValueKey('add_product_name_field'),
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: context.S.productNameLabel,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) => (value?.isEmpty ?? true)
                      ? context.S.pleaseEnterProductNameError
                      : null,
                ),
                const SizedBox(height: AppDimensions.medium),
                TextFormField(
                  key: const ValueKey('add_product_sku_field'),
                  controller: _skuController,
                  readOnly:
                      widget.initialSku !=
                      null, // Make read-only if initialSku is provided
                  decoration: InputDecoration(
                    labelText: context.S.productSkuLabel,
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.qr_code_scanner),
                      onPressed: widget.initialSku != null
                          ? null
                          : _scanBarcode, // Disable scan if read-only
                    ),
                  ),
                  validator: (value) => (value?.isEmpty ?? true)
                      ? context.S.pleaseEnterSkuError
                      : null,
                ),
                const SizedBox(height: AppDimensions.medium),
                TextFormField(
                  key: const ValueKey('add_product_location_field'),
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: context.S.productLocationLabel,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppDimensions.large),
                BlocBuilder<ProductCreationBloc, ProductCreationState>(
                  builder: (context, state) {
                    if (state is ProductCreationLoading) {
                      return const LoadingIndicator();
                    }
                    return PrimaryButton(
                      key: const ValueKey('add_product_save_button'),
                      onPressed: _createProduct,
                      text: context.S.saveButtonText,
                    );
                  },
                ),
                const SizedBox(height: AppDimensions.medium),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
