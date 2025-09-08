import 'package:easy_box/core/extensions/context_extension.dart';
import 'package:easy_box/core/widgets/app_snack_bar.dart';
import 'package:easy_box/core/widgets/widgets.dart';
import 'package:easy_box/di/injection_container.dart';
import 'package:easy_box/features/receiving/presentation/bloc/receiving_bloc.dart';
import 'package:easy_box/features/receiving/presentation/widgets/create_product_and_add_stock_form.dart';
import 'package:easy_box/core/utils/scanner_utils.dart';
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
    final sku = await scanBarcode(context);
    if (sku != null && mounted) {
      _skuController.text = sku;
    }
  }

  void _showCreateProductSheet(String sku) {
    final quantity = int.tryParse(_quantityController.text) ?? 0;
    if (quantity <= 0) {
      showAppSnackBar(
        context,
        context.S.quantityMustBePositiveError,
        isError: true,
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        // We can use context.read here because the BlocProvider is above this widget
        // in the tree, specifically in the ReceivingPage build method.
        return BlocProvider.value(
          value: context.read<ReceivingBloc>(),
          child: CreateProductAndAddStockForm(sku: sku, quantity: quantity),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.S.receiveStockPageTitle)),
      body: BlocListener<ReceivingBloc, ReceivingState>(
        listener: (context, state) {
          if (state is ReceivingSuccess) {
            final message = state.productCreated
                ? context.S.productCreatedAndStockAddedSuccessfully(state.sku)
                : context.S.stockAddedSuccessfully(state.sku);
            showAppSnackBar(
              context,
              message + (state.isQueued ? context.S.offlineIndicator : ''),
            );
            _skuController.clear();
            _quantityController.clear();
            FocusScope.of(context).unfocus();
          } else if (state is AddStockFailure) {
            showAppSnackBar(context, context.S.failedToAddStock, isError: true);
          } else if (state is CreateProductFailure) {
            showAppSnackBar(
              context,
              context.S.failedToCreateProduct,
              isError: true,
            );
          } else if (state is AddStockAfterCreateFailure) {
            showAppSnackBar(
              context,
              context.S.failedToAddStockAfterCreatingProduct,
              isError: true,
            );
          } else if (state is ReceivingProductNotFound) {
            _showCreateProductSheet(state.sku);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  key: const ValueKey('receiving_sku_field'),
                  controller: _skuController,
                  decoration: InputDecoration(
                    labelText: context.S.productSkuLabel,
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.qr_code_scanner),
                      onPressed: _scanBarcode,
                    ),
                  ),
                  validator: (value) => (value?.isEmpty ?? true)
                      ? context.S.pleaseEnterSkuError
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const ValueKey('receiving_quantity_field'),
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
                      return const LoadingIndicator();
                    }
                    return PrimaryButton(
                      key: const ValueKey('receiving_add_stock_button'),
                      onPressed: _addStock,
                      text: context.S.addStockButtonText,
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
