import 'package:easy_box/core/widgets/widgets.dart';
import 'package:easy_box/di/injection_container.dart';
import 'package:easy_box/features/order/presentation/bloc/order_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderListPage extends StatelessWidget {
  const OrderListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OrderListBloc>()..add(FetchOrdersRequested()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Orders'), // TODO: Localize
        ),
        body: BlocBuilder<OrderListBloc, OrderListState>(
          builder: (context, state) {
            if (state is OrderListLoading || state is OrderListInitial) {
              return const Center(child: LoadingIndicator());
            }
            if (state is OrderListFailure) {
              return ErrorDisplay(
                message: 'Failed to load orders', // TODO: Localize
                retryButtonText: 'Retry', // TODO: Localize
                onRetry: () {
                  context.read<OrderListBloc>().add(FetchOrdersRequested());
                },
              );
            }
            if (state is OrderListSuccess) {
              return ListView.builder(
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  final order = state.orders[index];
                  return ListTile(
                    title: Text('${order.id} - ${order.customerName}'),
                    subtitle: Text('Status: ${order.status.name}'),
                    trailing: Text('${order.lines.length} lines'),
                    onTap: () {
                      // TODO: Navigate to order picking page
                    },
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}