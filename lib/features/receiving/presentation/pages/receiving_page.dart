import 'package:easy_box/core/extensions/context_extension.dart';
import 'package:easy_box/di/injection_container.dart';
import 'package:easy_box/features/receiving/presentation/bloc/receiving_bloc.dart';
import 'package:easy_box/features/scanning/presentation/pages/barcode_scanner_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReceivingPage extends StatelessWidget {
  const ReceivingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ReceivingBloc>(),
      child: const _ReceivingView(),
    );
  }
}

class _ReceivingView extends StatefulWidget {
  const _ReceivingView();

  @override
  State<_ReceivingView> createState() => _ReceivingViewState();
}

class _ReceivingViewState extends State<_ReceivingView> {
  late final TextEditingController _skuController;
  late final TextEditingController _quantityController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _skuController = TextEditingController();
    _quantityController = TextEditingController();
  }

  @override
  void dispose() {
    _skuController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _addStock() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ReceivingBloc>().add(
            StockAdded(
              sku: _skuController.text,
              quantity: int.tryParse(_quantityController.text) ?? 0,
            ),
          );
    }
  }

  Future<void> _scanBarcode() async {
    final sku = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const BarcodeScannerPage()),
    );
    if (sku != null && mounted) {
      _skuController.text = sku;
    }
  }

  void _showCreateProductDialog(String sku) {
    final TextEditingController productNameController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(context.S.productNotFoundDialogTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('SKU: $sku'),
            TextField(
              controller: productNameController,
              decoration: InputDecoration(labelText: context.S.productNameLabel),
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
              if (productNameController.text.isNotEmpty) {
                Navigator.of(ctx).pop();
                context.read<ReceivingBloc>().add(
                      CreateProductAndAddStock(
                        name: productNameController.text,
                        sku: sku,
                        quantity: int.tryParse(_quantityController.text) ?? 0,
                      ),
                    );
              }
            },
            child: Text(context.S.createAndAddStockButtonText),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.S.receiveStockPageTitle),
      ),
      body: BlocListener<ReceivingBloc, ReceivingState>(
        listener: (context, state) {
          if (state is ReceivingFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                    content: Text(state.errorMessage),
                    backgroundColor: Colors.red),
              );
          } else if (state is ReceivingSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                    content: Text(state.successMessage),
                    backgroundColor: Colors.green),
              );
            _skuController.clear();
            _quantityController.clear();
            FocusScope.of(context).unfocus();
          } else if (state is ReceivingProductNotFound) {
            _showCreateProductDialog(state.sku);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _skuController,
                  decoration: InputDecoration(
                    labelText: context.S.productSkuLabel,
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.qr_code_scanner),
                      onPressed: _scanBarcode,
                    ),
                  ),
                  validator: (value) =>
                      (value?.isEmpty ?? true) ? context.S.pleaseEnterSkuError : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _quantityController,
                  decoration: InputDecoration(
                    labelText: context.S.quantityLabel,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return context.S.pleaseEnterQuantityError;
                    }
                    if ((int.tryParse(value!) ?? 0) <= 0) {
                      return context.S.quantityMustBePositiveError;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                BlocBuilder<ReceivingBloc, ReceivingState>(
                  builder: (context, state) {
                    if (state is ReceivingLoading) {
                      return const CircularProgressIndicator();
                    }
                    return ElevatedButton(
                      onPressed: _addStock,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: Text(context.S.addStockButtonText),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
