import 'package:prime_top_front/features/stock/data/models/stock_model.dart';
import 'package:prime_top_front/features/stock/domain/entities/available_stocks_response.dart';

class AvailableStocksResponseModel extends AvailableStocksResponse {
  const AvailableStocksResponseModel({
    required super.series,
    required super.count,
    required super.totalCount,
    super.client,
    super.summaryByNomenclature,
  });

  factory AvailableStocksResponseModel.fromJson(Map<String, dynamic>? json) {
    if (json == null || json.isEmpty) {
      return const AvailableStocksResponseModel(
        series: [],
        count: 0,
        totalCount: 0,
      );
    }

    // Парсинг серий
    List<StockModel> seriesList = [];
    if (json['series'] != null && json['series'] is List) {
      final seriesValue = json['series'] as List;
      seriesList = seriesValue
          .map((item) {
            try {
              if (item is Map<String, dynamic>) {
                return StockModel.fromJson(item);
              }
            } catch (e) {
            }
            return null;
          })
          .whereType<StockModel>()
          .toList();
    }

    // Парсинг клиента
    ClientInfoModel? client;
    if (json['client'] != null && json['client'] is Map<String, dynamic>) {
      try {
        final clientJson = json['client'] as Map<String, dynamic>;
        client = ClientInfoModel(
          id: clientJson['id'] is int ? clientJson['id'] as int : 0,
          name: clientJson['name'] is String ? clientJson['name'] as String : '',
        );
      } catch (e) {
      }
    }

    // Парсинг summary_by_nomenclature
    List<SummaryByNomenclatureModel>? summaryList;
    if (json['summary_by_nomenclature'] != null &&
        json['summary_by_nomenclature'] is List) {
      final summaryValue = json['summary_by_nomenclature'] as List;
      summaryList = summaryValue
          .map((item) {
            try {
              if (item is Map<String, dynamic>) {
                return SummaryByNomenclatureModel.fromJson(item);
              }
            } catch (e) {
            }
            return null;
          })
          .whereType<SummaryByNomenclatureModel>()
          .toList();
    }

    // Парсинг пагинации
    final count = json['count'] is int ? json['count'] as int : seriesList.length;
    final totalCount = json['total_count'] is int ? json['total_count'] as int : seriesList.length;

    return AvailableStocksResponseModel(
      series: seriesList,
      count: count,
      totalCount: totalCount,
      client: client,
      summaryByNomenclature: summaryList,
    );
  }

  AvailableStocksResponse toEntity() {
    return AvailableStocksResponse(
      series: series.map((stock) => (stock as StockModel).toEntity()).toList(),
      count: count,
      totalCount: totalCount,
      client: client is ClientInfoModel
          ? (client as ClientInfoModel).toEntity()
          : client,
      summaryByNomenclature: summaryByNomenclature
          ?.map((summary) => (summary as SummaryByNomenclatureModel).toEntity())
          .toList(),
    );
  }
}

class SummaryByNomenclatureModel extends SummaryByNomenclature {
  const SummaryByNomenclatureModel({
    required super.productName,
    required super.coatingTypeName,
    required super.nomenclature,
    required super.seriesCount,
    required super.totalQuantity,
  });

  factory SummaryByNomenclatureModel.fromJson(Map<String, dynamic> json) {
    return SummaryByNomenclatureModel(
      productName: json['product_name'] is String
          ? json['product_name'] as String
          : '',
      coatingTypeName: json['coating_type_name'] is String
          ? json['coating_type_name'] as String
          : '',
      nomenclature:
          json['nomenclature'] is String ? json['nomenclature'] as String : '',
      seriesCount:
          json['series_count'] is int ? json['series_count'] as int : 0,
      totalQuantity: json['total_quantity'] is num
          ? (json['total_quantity'] as num).toDouble()
          : 0.0,
    );
  }

  SummaryByNomenclature toEntity() {
    return SummaryByNomenclature(
      productName: productName,
      coatingTypeName: coatingTypeName,
      nomenclature: nomenclature,
      seriesCount: seriesCount,
      totalQuantity: totalQuantity,
    );
  }
}

class ClientInfoModel extends ClientInfo {
  const ClientInfoModel({
    required super.id,
    required super.name,
  });

  ClientInfo toEntity() {
    return ClientInfo(
      id: id,
      name: name,
    );
  }
}
