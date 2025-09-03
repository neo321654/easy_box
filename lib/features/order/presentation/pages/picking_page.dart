import 'package:easy_box/features/order/domain/entities/entities.dart';
import 'package:easy_box/features/order/presentation/bloc/picking_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PickingPage extends StatelessWidget {
  final Order order;
  const PickingPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PickingBloc()..add(InitializePicking(order)),
      child: const _PickingView(),
    );
  }
}

class _PickingView extends StatelessWidget {
  const _PickingView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<PickingBloc, PickingState>(
          builder: (context, state) {
            return Text('Picking Order: ${state.order?.id ?? ''}');
          },
        ),
      ),
      body: BlocBuilder<PickingBloc, PickingState>(
        builder: (context, state) {
          if (state.order == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: state.order!.lines.length,
            itemBuilder: (context, index) {
              final line = state.order!.lines[index];
              final isPicked = line.quantityPicked >= line.quantityToPick;
              return ListTile(
                tileColor: isPicked ? Colors.green.withOpacity(0.2) : null,
                title: Text(line.productName),
                subtitle: Text('SKU: ${line.sku}\nLocation: ${line.location ?? 'N/A'}'),
                trailing: Text(
                  '${line.quantityPicked}/${line.quantityToPick}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                onTap: () {
                  if (!isPicked) {
                    // In a real app, you might show a dialog to enter quantity
                    context.read<PickingBloc>().add(
                          LineItemPicked(
                            productId: line.productId,
                            quantity: line.quantityToPick,
                          ),
                        );
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Show confirmation dialog
          context.read<PickingBloc>().add(PickingCompleted());
        },
        label: const Text('Complete Picking'),
        icon: const Icon(Icons.check),
      ),
    );
  }
}
