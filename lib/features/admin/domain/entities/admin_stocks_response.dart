import 'package:equatable/equatable.dart';
import 'package:prime_top_front/features/admin/domain/entities/admin_stock.dart';

class AdminStocksResponse extends Equatable {
  const AdminStocksResponse({
    required this.count,
    required this.results,
  });

  final int count;
  final List<AdminStock> results;

  @override
  List<Object?> get props => [count, results];
}
