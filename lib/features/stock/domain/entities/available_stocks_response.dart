import 'package:prime_top_front/features/stock/domain/entities/stock.dart';

class AvailableStocksResponse {
  const AvailableStocksResponse({
    required this.series,
    required this.count,
    required this.totalCount,
    this.client,
    this.summaryByNomenclature,
  });

  final List<Stock> series;
  final int count;
  final int totalCount;
  final ClientInfo? client;
  final List<SummaryByNomenclature>? summaryByNomenclature;
}

class SummaryByNomenclature {
  const SummaryByNomenclature({
    required this.productName,
    required this.coatingTypeName,
    required this.nomenclature,
    required this.seriesCount,
    required this.totalQuantity,
  });

  final String productName;
  final String coatingTypeName;
  final String nomenclature;
  final int seriesCount;
  final double totalQuantity;
}

class ClientInfo {
  const ClientInfo({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;
}
