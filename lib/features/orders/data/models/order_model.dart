import 'package:prime_top_front/features/auth/data/models/client_model.dart';
import 'package:prime_top_front/features/orders/domain/entities/order.dart';
import 'package:prime_top_front/features/orders/data/models/order_item_model.dart';
import 'package:prime_top_front/features/orders/data/models/order_status_history_model.dart';

class OrderModel extends Order {
  const OrderModel({
    required super.id,
    required super.client,
    required super.status,
    required super.createdAt,
    required super.items,
    required super.totalQuantity,
    required super.statusHistory,
    super.shippedAt,
    super.deliveredAt,
    super.cancelReason,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(String dateString) {
      try {
        return DateTime.parse(dateString);
      } catch (_) {
        throw FormatException('Неверный формат даты: $dateString');
      }
    }

    DateTime? parseNullableDate(String? dateString) {
      if (dateString == null) return null;
      return parseDate(dateString);
    }

    return OrderModel(
      id: json['id'] as int,
      client: ClientModel.fromJson(
        json['client'] as Map<String, dynamic>,
      ),
      status: json['status'] as String,
      createdAt: parseDate(json['created_at'] as String),
      shippedAt: parseNullableDate(json['shipped_at'] as String?),
      deliveredAt: parseNullableDate(json['delivered_at'] as String?),
      cancelReason: json['cancel_reason'] as String?,
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => OrderItemModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      totalQuantity: (json['total_quantity'] as num?)?.toDouble() ?? 0.0,
      statusHistory: (json['status_history'] as List<dynamic>?)
              ?.map((item) => OrderStatusHistoryModel.fromJson(
                    item as Map<String, dynamic>,
                  ))
              .toList() ??
          [],
    );
  }

  factory OrderModel.fromAdminListJson(Map<String, dynamic> json) {
    DateTime parseDate(String dateString) {
      try {
        return DateTime.parse(dateString);
      } catch (_) {
        throw FormatException('Неверный формат даты: $dateString');
      }
    }

    DateTime? parseNullableDate(String? dateString) {
      if (dateString == null) return null;
      return parseDate(dateString);
    }

    return OrderModel(
      id: json['id'] is int ? json['id'] as int : 0,
      client: ClientModel.fromJson(
        json['client'] as Map<String, dynamic>? ?? {},
      ),
      status: json['status'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? parseDate(json['created_at'] as String)
          : DateTime.now(),
      shippedAt: parseNullableDate(json['shipped_at'] as String?),
      deliveredAt: parseNullableDate(json['delivered_at'] as String?),
      cancelReason: json['cancel_reason'] as String?,
      items: [],
      totalQuantity: (json['total_quantity'] as num?)?.toDouble() ?? 0.0,
      statusHistory: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client': (client as ClientModel).toJson(),
      'status': status,
      'created_at': createdAt.toIso8601String().split('T')[0],
      'shipped_at': shippedAt?.toIso8601String().split('T')[0],
      'delivered_at': deliveredAt?.toIso8601String().split('T')[0],
      'cancel_reason': cancelReason,
      'items': items
          .map((item) => (item as OrderItemModel).toJson())
          .toList(),
      'total_quantity': totalQuantity,
      'status_history': statusHistory
          .map((item) => (item as OrderStatusHistoryModel).toJson())
          .toList(),
    };
  }

  Order toEntity() {
    return Order(
      id: id,
      client: client,
      status: status,
      createdAt: createdAt,
      shippedAt: shippedAt,
      deliveredAt: deliveredAt,
      cancelReason: cancelReason,
      items: items.map((item) => (item as OrderItemModel).toEntity()).toList(),
      totalQuantity: totalQuantity,
      statusHistory: statusHistory
          .map((item) => (item as OrderStatusHistoryModel).toEntity())
          .toList(),
    );
  }
}
