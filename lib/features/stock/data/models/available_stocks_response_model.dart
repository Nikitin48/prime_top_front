import 'package:prime_top_front/features/stock/data/models/stock_model.dart';
import 'package:prime_top_front/features/stock/domain/entities/available_stocks_response.dart';

class AvailableStocksResponseModel extends AvailableStocksResponse {
  const AvailableStocksResponseModel({
    required super.publicStocks,
    super.client,
    super.clientStocks,
  });

  factory AvailableStocksResponseModel.fromJson(Map<String, dynamic>? json) {
    if (json == null || json.isEmpty) {
      return AvailableStocksResponseModel(
        publicStocks: const PublicStocksDataModel(
          count: 0,
          totalCount: 0,
          totalQuantity: 0.0,
          results: [],
        ),
      );
    }

    Map<String, dynamic> publicStocksJson = {};
    if (json['public_stocks'] != null) {
      if (json['public_stocks'] is Map<String, dynamic>) {
        publicStocksJson = json['public_stocks'] as Map<String, dynamic>;
      }
    }

    List<StockModel> publicStocksResults = [];
    if (publicStocksJson.containsKey('results')) {
      final resultsValue = publicStocksJson['results'];
      if (resultsValue is List) {
        publicStocksResults = resultsValue
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
    }

    final publicStocks = PublicStocksDataModel(
      count: publicStocksJson['count'] is int
          ? publicStocksJson['count'] as int
          : 0,
      totalCount: publicStocksJson['total_count'] is int
          ? publicStocksJson['total_count'] as int
          : 0,
      totalQuantity: publicStocksJson['total_quantity'] is num
          ? (publicStocksJson['total_quantity'] as num).toDouble()
          : 0.0,
      results: publicStocksResults,
    );

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

    ClientStocksDataModel? clientStocks;
    if (json.containsKey('client_stocks') &&
        json['client_stocks'] != null &&
        json['client_stocks'] is Map<String, dynamic>) {
      try {
        final clientStocksJson = json['client_stocks'] as Map<String, dynamic>;
        
        List<StockModel> clientStocksResults = [];
        if (clientStocksJson.containsKey('results')) {
          final resultsValue = clientStocksJson['results'];
          if (resultsValue is List) {
            clientStocksResults = resultsValue
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
        }

        clientStocks = ClientStocksDataModel(
          count: clientStocksJson['count'] is int
              ? clientStocksJson['count'] as int
              : 0,
          totalQuantity: clientStocksJson['total_quantity'] is num
              ? (clientStocksJson['total_quantity'] as num).toDouble()
              : 0.0,
          results: clientStocksResults,
        );
      } catch (e) {
      }
    }

    return AvailableStocksResponseModel(
      publicStocks: publicStocks,
      client: client,
      clientStocks: clientStocks,
    );
  }

  AvailableStocksResponse toEntity() {
    return AvailableStocksResponse(
      publicStocks: publicStocks is PublicStocksDataModel
          ? (publicStocks as PublicStocksDataModel).toEntity()
          : publicStocks,
      client: client is ClientInfoModel
          ? (client as ClientInfoModel).toEntity()
          : client,
      clientStocks: clientStocks is ClientStocksDataModel
          ? (clientStocks as ClientStocksDataModel).toEntity()
          : clientStocks,
    );
  }
}

class PublicStocksDataModel extends PublicStocksData {
  const PublicStocksDataModel({
    required super.count,
    required super.totalCount,
    required super.totalQuantity,
    required super.results,
  });

  PublicStocksData toEntity() {
    return PublicStocksData(
      count: count,
      totalCount: totalCount,
      totalQuantity: totalQuantity,
      results: results.map((stock) => (stock as StockModel).toEntity()).toList(),
    );
  }
}

class ClientStocksDataModel extends ClientStocksData {
  const ClientStocksDataModel({
    required super.count,
    required super.totalQuantity,
    required super.results,
  });

  ClientStocksData toEntity() {
    return ClientStocksData(
      count: count,
      totalQuantity: totalQuantity,
      results: results.map((stock) => (stock as StockModel).toEntity()).toList(),
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
