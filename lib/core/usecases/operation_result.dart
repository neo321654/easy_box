import 'package:equatable/equatable.dart';

class OperationResult extends Equatable {
  final bool isQueued;

  const OperationResult({required this.isQueued});

  @override
  List<Object> get props => [isQueued];
}
