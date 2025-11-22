import 'package:equatable/equatable.dart';
import 'package:prime_top_front/features/auth/domain/entities/client.dart';
import 'package:prime_top_front/features/products/domain/entities/product.dart';

class AdminStock extends Equatable {
  const AdminStock({
    required this.id,
    required this.series,
    this.client,
    required this.quantity,
    required this.isReserved,
    required this.updatedAt,
  });

  final int id;
  final AdminSeries series;
  final Client? client;
  final double quantity;
  final bool isReserved;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [id, series, client, quantity, isReserved, updatedAt];
}

class AdminSeries extends Equatable {
  const AdminSeries({
    required this.id,
    this.name,
    this.productionDate,
    this.expireDate,
    this.product,
  });

  final int id;
  final String? name;
  final DateTime? productionDate;
  final DateTime? expireDate;
  final Product? product;

  @override
  List<Object?> get props => [id, name, productionDate, expireDate, product];
}
