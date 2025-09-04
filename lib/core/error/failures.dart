import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]]);
}

// General failures
class ServerFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class CacheFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class ProductNotFoundFailure extends Failure {
  final String sku;

  const ProductNotFoundFailure(this.sku);

  @override
  List<Object?> get props => [sku];
}

class LogInFailure extends Failure {
  final String message;

  const LogInFailure(this.message);

  @override
  List<Object?> get props => [message];
}