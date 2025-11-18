import 'package:prime_top_front/features/orders/domain/entities/order_status_history.dart';

class OrderStatusHistoryModel extends OrderStatusHistory {
  const OrderStatusHistoryModel({
    required super.id,
    required super.fromStatus,
    required super.toStatus,
    required super.changedAt,
    super.note,
  });

  factory OrderStatusHistoryModel.fromJson(Map<String, dynamic> json) {
    DateTime parseDateTime(String dateTimeString) {
      try {
        return DateTime.parse(dateTimeString);
      } catch (_) {
        throw FormatException('Неверный формат даты: $dateTimeString');
      }
    }

    return OrderStatusHistoryModel(
      id: json['id'] as int,
      fromStatus: json['from_status'] as String,
      toStatus: json['to_status'] as String,
      changedAt: parseDateTime(json['changed_at'] as String),
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'from_status': fromStatus,
      'to_status': toStatus,
      'changed_at': changedAt.toIso8601String(),
      'note': note,
    };
  }

  OrderStatusHistory toEntity() {
    return OrderStatusHistory(
      id: id,
      fromStatus: fromStatus,
      toStatus: toStatus,
      changedAt: changedAt,
      note: note,
    );
  }
}

