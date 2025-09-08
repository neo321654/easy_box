import 'package:easy_box/core/extensions/context_extension.dart';
import 'package:easy_box/core/widgets/widgets.dart';
import 'package:easy_box/di/injection_container.dart';

import 'package:easy_box/features/order/presentation/bloc/order_list_bloc.dart';
import 'package:easy_box/features/order/presentation/pages/picking_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderListPage extends StatelessWidget {
  const OrderListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OrderListBloc>()..add(FetchOrdersRequested()),
      child: Scaffold(
        appBar: AppBar(title: Text(context.S.orderListPageTitle)),
        body: BlocBuilder<OrderListBloc, OrderListState>(
          builder: (context, state) {
            if (state is OrderListLoading || state is OrderListInitial) {
              return const Center(child: LoadingIndicator());
            }
            if (state is OrderListFailure) {
              return ErrorDisplay(
                message: context.S.orderListFailedToLoad,
                retryButtonText: context.S.retryButtonText,
                onRetry: () {
                  context.read<OrderListBloc>().add(FetchOrdersRequested());
                },
              );
            }
            if (state is OrderListSuccess) {
              return ListView.builder(
                key: const ValueKey('order_list'),
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  final order = state.orders[index];
                  return ListTile(
                    title: Text('${order.id} - ${order.customerName}'),
                    subtitle: Text(
                      context.S.orderStatusLabel(order.status.name),
                    ),
                    trailing: Text(
                      context.S.orderLinesLabel(order.lines.length),
                    ),
                    onTap: () async {
                      final result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PickingPage(order: order),
                        ),
                      );
                      if (result == true && context.mounted) {
                        // If picking was completed, refresh the list
                        context.read<OrderListBloc>().add(
                          FetchOrdersRequested(),
                        );
                      }
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
