import 'package:easy_box/core/extensions/context_extension.dart';
import 'package:easy_box/di/injection_container.dart';
import 'package:easy_box/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:easy_box/features/inventory/presentation/widgets/product_list_item.dart';
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
        body: BlocBuilder<InventoryBloc, InventoryState>(
          builder: (context, state) {
            if (state is InventoryLoading || state is InventoryInitial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is InventoryFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(context.S.serverError),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<InventoryBloc>().add(FetchProductsRequested());
                      },
                      child: Text(context.S.retryButtonText),
                    ),
                  ],
                ),
              );
            }
            if (state is InventorySuccess) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<InventoryBloc>().add(FetchProductsRequested());
                },
                child: ListView.builder(
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    final product = state.products[index];
                    return ProductListItem(product: product);
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}