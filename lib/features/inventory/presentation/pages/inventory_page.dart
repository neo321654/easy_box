import 'package:easy_box/core/extensions/context_extension.dart';
import 'package:easy_box/core/widgets/widgets.dart';
import 'package:easy_box/di/injection_container.dart';
import 'package:easy_box/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:easy_box/features/inventory/presentation/bloc/product_creation_bloc.dart';
import 'package:easy_box/features/inventory/presentation/widgets/add_product_form.dart';
import 'package:easy_box/features/inventory/presentation/widgets/product_list_item.dart';
import 'package:easy_box/features/scanning/presentation/pages/barcode_scanner_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddProductSheet(BuildContext context, {String? initialSku}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return BlocProvider(
          create: (_) => sl<ProductCreationBloc>(),
          child: AddProductForm(initialSku: initialSku),
        );
      },
    ).then((result) {
      if (result == true && context.mounted) {
        context.read<InventoryBloc>().add(FetchProductsRequested());
      }
    });
  }

  Future<void> _scanBarcode() async {
    final sku = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const BarcodeScannerPage()),
    );
    if (sku != null && mounted) {
      _searchController.text = sku;
      context.read<InventoryBloc>().add(SearchTermChanged(sku));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.S.inventoryPageTitle),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddProductSheet(this.context),
        label: Text(context.S.addProductButtonText),
        icon: const Icon(Icons.add),
      ),
      body: BlocBuilder<InventoryBloc, InventoryState>(
        builder: (context, state) {
          if (state is InventoryLoading || state is InventoryInitial) {
            return const Center(child: LoadingIndicator());
          }
          if (state is InventoryFailure) {
            return ErrorDisplay(
              message: context.S.serverError,
              retryButtonText: context.S.retryButtonText,
              onRetry: () {
                context.read<InventoryBloc>().add(FetchProductsRequested());
              },
            );
          } else if (state is InventorySuccess) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: context.S.inventorySearchHint,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.qr_code_scanner),
                        onPressed: _scanBarcode,
                      ),
                    ),
                    onChanged: (value) {
                      context.read<InventoryBloc>().add(SearchTermChanged(value));
                    },
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<InventoryBloc>().add(FetchProductsRequested());
                    },
                    child: ListView.builder(
                      itemCount: state.filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = state.filteredProducts[index];
                        return ProductListItem(product: product);
                      },
                    ),
                  ),
                ),
              ],
            );
          } else if (state is InventoryProductNotFound) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(context.S.productNotFound),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    onPressed: () => _showAddProductSheet(this.context, initialSku: state.sku),
                    text: context.S.addProductButtonText,
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}