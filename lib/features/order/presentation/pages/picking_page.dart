import 'package:easy_box/core/extensions/context_extension.dart';
import 'package:easy_box/di/injection_container.dart';
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
      create: (context) => PickingBloc(updateOrderUseCase: sl()),
      child: _PickingView(order: order),
    );
  }
}

class _PickingView extends StatefulWidget {
  final Order order;
  const _PickingView({required this.order});

  @override
  State<_PickingView> createState() => _PickingViewState();
}

class _PickingViewState extends State<_PickingView> {
  @override
  void initState() {
    super.initState();
    context.read<PickingBloc>().add(InitializePicking(widget.order));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PickingBloc, PickingState>(
      listener: (context, state) {
        if (state.isCompleted) {
          Navigator.of(context).pop(true); // Pop with a result to indicate success
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<PickingBloc, PickingState>(
            builder: (context, state) {
              return Text(
                  context.S.pickingPageTitle(state.order?.id ?? ''));
            },
          ),
        ),
        body: BlocBuilder<PickingBloc, PickingState>(
          builder: (context, state) {
            if (state.order == null || state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              itemCount: state.order!.lines.length,
              itemBuilder: (context, index) {
                final line = state.order!.lines[index];
                final isPicked = line.quantityPicked >= line.quantityToPick;
                return ListTile(
                  tileColor: isPicked ? Colors.green.withAlpha(51) : null,
                  leading: line.imageUrl != null && line.imageUrl!.isNotEmpty
                      ? Image.network(
                          line.imageUrl!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image),
                        )
                      : const Icon(Icons.image_not_supported),
                  title: Text(line.productName),
                  subtitle: Text(
                      '${context.S.pickingPageSkuLabel}: ${line.sku}\n${context.S.pickingPageLocationLabel}: ${line.location ?? 'N/A'}'),
                  trailing: Text(
                    '${line.quantityPicked}/${line.quantityToPick}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  onTap: () {
                    if (!isPicked) {
                      // In a real app, you might show a dialog to enter quantity
                      context.read<PickingBloc>().add(LineItemPicked(
                            productId: line.productId,
                            quantity: line.quantityToPick,
                          ));
                    }
                  },
                );
              },
            );
          },
        ),
        floatingActionButton: BlocBuilder<PickingBloc, PickingState>(
          builder: (context, state) {
            final allItemsPicked = state.order?.lines
                    .every((line) => line.quantityPicked >= line.quantityToPick) ??
                false;
            return FloatingActionButton.extended(
              onPressed: allItemsPicked
                  ? () {
                      // TODO: Show confirmation dialog
                      context.read<PickingBloc>().add(PickingCompleted());
                    }
                  : null, // Disable button if not all items are picked
              label: Text(context.S.pickingPageCompleteButton),
              icon: const Icon(Icons.check),
              backgroundColor: allItemsPicked ? null : Colors.grey,
            );
          },
        ),
      ),
    );
  }
}

