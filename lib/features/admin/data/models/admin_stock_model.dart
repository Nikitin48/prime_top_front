import 'package:prime_top_front/features/admin/domain/entities/admin_stock.dart';
import 'package:prime_top_front/features/auth/data/models/client_model.dart';
import 'package:prime_top_front/features/products/data/models/product_model.dart';

class AdminStockModel extends AdminStock {
  const AdminStockModel({
    required super.id,
    required super.series,
    super.client,
    required super.quantity,
    required super.isReserved,
    required super.updatedAt,
  });

  factory AdminStockModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? dateString) {
      if (dateString == null) return null;
      try {
        return DateTime.parse(dateString);
      } catch (_) {
        return null;
      }
    }

    final updatedAtDate = parseDate(json['updated_at'] as String?);

    AdminSeriesModel? series;
    if (json.containsKey('series') && json['series'] != null) {
      try {
        series = AdminSeriesModel.fromJson(
          json['series'] as Map<String, dynamic>,
        );
      } catch (e) {
      }
    }

    ClientModel? client;
    if (json.containsKey('client') && json['client'] != null) {
      try {
        client = ClientModel.fromJson(json['client'] as Map<String, dynamic>);
      } catch (e) {
      }
    }

    return AdminStockModel(
      id: json['id'] is int ? json['id'] as int : 0,
      series: series ?? const AdminSeriesModel(id: 0),
      client: client,
      quantity: json['quantity'] is num
          ? (json['quantity'] as num).toDouble()
          : 0.0,
      isReserved: json['is_reserved'] is bool ? json['is_reserved'] as bool : false,
      updatedAt: updatedAtDate ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'series_id': series.id,
      if (client != null) 'client_id': int.tryParse((client as ClientModel).id),
      'quantity': quantity,
      'is_reserved': isReserved,
    };
  }

  AdminStock toEntity() {
    return AdminStock(
      id: id,
      series: (series as AdminSeriesModel).toEntity(),
      client: client,
      quantity: quantity,
      isReserved: isReserved,
      updatedAt: updatedAt,
    );
  }
}

class AdminSeriesModel extends AdminSeries {
  const AdminSeriesModel({
    required super.id,
    super.name,
    super.productionDate,
    super.expireDate,
    ProductModel? product,
  }) : _productModel = product,
       super(product: product);

  final ProductModel? _productModel;

  factory AdminSeriesModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? dateString) {
      if (dateString == null) return null;
      try {
        return DateTime.parse(dateString);
      } catch (_) {
        return null;
      }
    }

    ProductModel? product;
    if (json.containsKey('product') && json['product'] != null) {
      try {
        product = ProductModel.fromJson(
          json['product'] as Map<String, dynamic>,
        );
      } catch (e) {
      }
    }

    return AdminSeriesModel(
      id: json['id'] is int ? json['id'] as int : 0,
      name: json['name'] as String?,
      productionDate: parseDate(json['production_date'] as String?),
      expireDate: parseDate(json['expire_date'] as String?),
      product: product,
    );
  }

  AdminSeries toEntity() {
    return AdminSeries(
      id: id,
      name: name,
      productionDate: productionDate,
      expireDate: expireDate,
      product: _productModel?.toEntity(),
    );
  }
}
