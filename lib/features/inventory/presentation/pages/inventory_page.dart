import 'package:easy_box/core/extensions/context_extension.dart';
import 'package:easy_box/core/widgets/widgets.dart';
import 'package:easy_box/di/injection_container.dart';
import 'package:easy_box/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:easy_box/features/inventory/presentation/widgets/product_list_item.dart';
import 'package:easy_box/features/inventory/presentation/pages/add_product_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<InventoryBloc>()..add(FetchProductsRequested()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.S.inventoryPageTitle),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AddProductPage()),
            );
            // Refresh the inventory list after returning from AddProductPage
            if (context.mounted) {
              context.read<InventoryBloc>().add(FetchProductsRequested());
            }
          },
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
            }
            if (state is InventorySuccess) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: context.S.inventorySearchHint,
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
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
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
