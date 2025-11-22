import 'package:equatable/equatable.dart';

class OrderStatusHistory extends Equatable {
  const OrderStatusHistory({
    required this.id,
    required this.fromStatus,
    required this.toStatus,
    required this.changedAt,
    this.note,
  });

  final int id;
  final String fromStatus;
  final String toStatus;
  final DateTime changedAt;
  final String? note;

  @override
  List<Object?> get props => [id, fromStatus, toStatus, changedAt, note];
}
