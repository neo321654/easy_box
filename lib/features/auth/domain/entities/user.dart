import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final bool isAnonymous;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.isAnonymous = false, // Default to false for regular users
  });

  @override
  List<Object> get props => [id, name, email, isAnonymous];
}
