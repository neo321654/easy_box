import 'package:easy_box/features/order/data/datasources/order_remote_data_source.dart';
import 'package:easy_box/features/order/data/models/models.dart';
import 'package:easy_box/features/order/domain/entities/entities.dart';

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  // Mock data
  final _mockOrders = [
    OrderModel(
      id: 'ORD-001',
      customerName: 'John Doe',
      status: OrderStatus.open,
      lines: [
        const OrderLineModel(
          productId: '1',
          productName: 'Red T-Shirt, Size L',
          sku: 'SKU-TS-RED-L',
          location: 'A1-01-01',
          quantityToPick: 2,
          imageUrl: 'https://picsum.photos/id/10/50/50',
        ),
        const OrderLineModel(
          productId: '3',
          productName: 'Green Hoodie, Size M',
          sku: 'SKU-HD-GRN-M',
          location: 'A2-03-05',
          quantityToPick: 1,
          imageUrl: 'https://picsum.photos/id/30/50/50',
        ),
      ],
    ),
    OrderModel(
      id: 'ORD-002',
      customerName: 'Jane Smith',
      status: OrderStatus.open,
      lines: [
        const OrderLineModel(
          productId: '4',
          productName: 'Black Sneakers, Size 42',
          sku: 'SKU-SN-BLK-42',
          location: 'C4-02-01',
          quantityToPick: 1,
          imageUrl: 'https://picsum.photos/id/40/50/50',
        ),
      ],
    ),
  ];

  @override
  Future<List<OrderModel>> getOrders() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return _mockOrders;
  }

  @override
  Future<void> updateOrder(OrderModel order) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockOrders.indexWhere((o) => o.id == order.id);
    if (index != -1) {
      _mockOrders[index] = order;
    }
    // In a real app, this would throw an error if not found
  }
}