import 'package:prime_top_front/features/products/data/models/analyses_model.dart';
import 'package:prime_top_front/features/products/data/models/product_model.dart';
import 'package:prime_top_front/features/coating_types/data/models/coating_type_model.dart';
import 'package:prime_top_front/features/stock/domain/entities/stock.dart';

class StockModel extends Stock {
  StockModel({
    required super.stocksId,
    super.seriesId,
    super.seriesName,
    super.productionDate,
    super.expireDate,
    required super.quantity,
    super.reservedForClient = false,
    required super.updatedAt,
    super.color,
    ProductModel? product,
    CoatingTypeModel? coatingType,
    AnalysesModel? analyses,
  })  : _productModel = product,
        _coatingTypeModel = coatingType,
        _analysesModel = analyses,
        super(
          product: product,
          coatingType: coatingType?.toEntity(),
          analyses: analyses,
        );

  final ProductModel? _productModel;
  final CoatingTypeModel? _coatingTypeModel;
  final AnalysesModel? _analysesModel;

  factory StockModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? dateString) {
      if (dateString == null) return null;
      try {
        return DateTime.parse(dateString);
      } catch (_) {
        return null;
      }
    }

    final updatedAtDate = parseDate(json['updated_at'] as String?);

    ProductModel? product;
    if (json.containsKey('product') &&
        json['product'] != null &&
        json['product'] is Map<String, dynamic>) {
      try {
        product = ProductModel.fromJson(json['product'] as Map<String, dynamic>);
      } catch (e) {
        // ignore
      }
    }

    CoatingTypeModel? coatingType;
    if (json.containsKey('coating_type') &&
        json['coating_type'] != null &&
        json['coating_type'] is Map<String, dynamic>) {
      try {
        coatingType = CoatingTypeModel.fromJson(
          json['coating_type'] as Map<String, dynamic>,
        );
      } catch (e) {
        // ignore
      }
    }

    AnalysesModel? analyses;
    if (json.containsKey('analyses') &&
        json['analyses'] != null &&
        json['analyses'] is Map<String, dynamic>) {
      try {
        analyses = AnalysesModel.fromJson(
          json['analyses'] as Map<String, dynamic>?,
        );
      } catch (e) {
        // ignore
      }
    }

    return StockModel(
      stocksId: json['stocks_id'] is int ? json['stocks_id'] as int : 0,
      seriesId: json['series_id'] is int ? json['series_id'] as int : null,
      seriesName: json['series_name'] is String ? json['series_name'] as String : null,
      productionDate: parseDate(json['production_date'] as String?),
      expireDate: parseDate(json['expire_date'] as String?),
      quantity: json['quantity'] is num
          ? (json['quantity'] as num).toDouble()
          : 0.0,
      reservedForClient: json['reserved_for_client'] is bool
          ? json['reserved_for_client'] as bool
          : false,
      updatedAt: updatedAtDate ?? DateTime.now(),
      color: json['color'] is int ? json['color'] as int : null,
      product: product,
      coatingType: coatingType,
      analyses: analyses,
    );
  }

  Stock toEntity() {
    return Stock(
      stocksId: stocksId,
      seriesId: seriesId,
      seriesName: seriesName,
      productionDate: productionDate,
      expireDate: expireDate,
      quantity: quantity,
      reservedForClient: reservedForClient,
      updatedAt: updatedAt,
      color: color,
      product: _productModel?.toEntity(),
      coatingType: _coatingTypeModel?.toEntity(),
      analyses: _analysesModel?.toEntity(),
    );
  }
}
