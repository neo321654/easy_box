import 'package:dartz/dartz.dart' hide Order;
import 'package:easy_box/core/error/exceptions.dart';
import 'package:easy_box/core/error/failures.dart';
import 'package:easy_box/core/network/network_info.dart';
import 'package:easy_box/features/order/data/datasources/order_remote_data_source.dart';
import 'package:easy_box/features/order/domain/entities/order.dart';
import 'package:easy_box/features/order/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  OrderRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Order>>> getOrders() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteOrders = await remoteDataSource.getOrders();
        return Right(remoteOrders);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      // TODO: Implement local data source for offline support
      return Left(ServerFailure());
    }
  }
}