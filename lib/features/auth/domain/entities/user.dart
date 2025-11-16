import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    required this.companyName,
  });

  final String id;
  final String email;
  final String companyName;

  @override
  List<Object?> get props => [id, email, companyName];
}


