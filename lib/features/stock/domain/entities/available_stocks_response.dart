import 'package:prime_top_front/features/stock/domain/entities/stock.dart';

class AvailableStocksResponse {
  const AvailableStocksResponse({
    required this.publicStocks,
    this.client,
    this.clientStocks,
  });

  final PublicStocksData publicStocks;
  final ClientInfo? client;
  final ClientStocksData? clientStocks;
}

class PublicStocksData {
  const PublicStocksData({
    required this.count,
    required this.totalCount,
    required this.totalQuantity,
    required this.results,
  });

  final int count;
  final int totalCount;
  final double totalQuantity;
  final List<Stock> results;
}

class ClientStocksData {
  const ClientStocksData({
    required this.count,
    required this.totalQuantity,
    required this.results,
  });

  final int count;
  final double totalQuantity;
  final List<Stock> results;
}

class ClientInfo {
  const ClientInfo({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;
}
