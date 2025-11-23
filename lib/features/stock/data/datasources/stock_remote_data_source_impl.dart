import 'package:prime_top_front/core/network/api_client.dart';
import 'package:prime_top_front/core/network/exceptions.dart';
import 'package:prime_top_front/core/network/network_client.dart';
import 'package:prime_top_front/features/stock/data/datasources/stock_remote_data_source.dart';
import 'package:prime_top_front/features/stock/data/models/available_stocks_response_model.dart';

class StockRemoteDataSourceImpl implements StockRemoteDataSource {
  StockRemoteDataSourceImpl({
    required NetworkClient networkClient,
    required String baseUrl,
  }) : _apiClient = _StockApiClient(networkClient, baseUrl);

  final _StockApiClient _apiClient;

  @override
  Future<AvailableStocksResponseModel> getAvailableStocks({
    int? clientId,
    String? color,
    String? coatingType,
    String? series,
    int? seriesId,
    bool? includePublic,
    bool? personalOnly,
    double? analysesBleskPri60Grad,
    double? analysesUslovnayaVyazkost,
    double? analysesDeltaE,
    double? analysesDeltaL,
    double? analysesDeltaA,
    double? analysesDeltaB,
    double? minAnalysesBleskPri60Grad,
    double? maxAnalysesBleskPri60Grad,
    double? minAnalysesUslovnayaVyazkost,
    double? maxAnalysesUslovnayaVyazkost,
    double? minAnalysesDeltaE,
    double? maxAnalysesDeltaE,
    double? minAnalysesDeltaL,
    double? maxAnalysesDeltaL,
    double? minAnalysesDeltaA,
    double? maxAnalysesDeltaA,
    double? minAnalysesDeltaB,
    double? maxAnalysesDeltaB,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, String>{};
      
      // Фильтры по клиентам
      if (clientId != null) {
        queryParams['client_id'] = clientId.toString();
      }
      if (includePublic != null) {
        queryParams['include_public'] = includePublic.toString();
      }
      if (personalOnly != null) {
        queryParams['personal_only'] = personalOnly.toString();
      }
      
      // Фильтры по сериям
      if (series != null && series.isNotEmpty) {
        queryParams['series'] = series;
      }
      if (seriesId != null) {
        queryParams['series_id'] = seriesId.toString();
      }
      
      // Фильтры по продуктам
      if (color != null && color.isNotEmpty) {
        queryParams['color'] = color;
      }
      if (coatingType != null && coatingType.isNotEmpty) {
        queryParams['coating_type'] = coatingType;
      }
      
      // Точные значения анализов
      if (analysesBleskPri60Grad != null) {
        queryParams['analyses_blesk_pri_60_grad'] = analysesBleskPri60Grad.toString();
      }
      if (analysesUslovnayaVyazkost != null) {
        queryParams['analyses_uslovnaya_vyazkost'] = analysesUslovnayaVyazkost.toString();
      }
      if (analysesDeltaE != null) {
        queryParams['analyses_delta_e'] = analysesDeltaE.toString();
      }
      if (analysesDeltaL != null) {
        queryParams['analyses_delta_l'] = analysesDeltaL.toString();
      }
      if (analysesDeltaA != null) {
        queryParams['analyses_delta_a'] = analysesDeltaA.toString();
      }
      if (analysesDeltaB != null) {
        queryParams['analyses_delta_b'] = analysesDeltaB.toString();
      }
      
      // Диапазоны анализов
      if (minAnalysesBleskPri60Grad != null) {
        queryParams['min_analyses_blesk_pri_60_grad'] = minAnalysesBleskPri60Grad.toString();
      }
      if (maxAnalysesBleskPri60Grad != null) {
        queryParams['max_analyses_blesk_pri_60_grad'] = maxAnalysesBleskPri60Grad.toString();
      }
      if (minAnalysesUslovnayaVyazkost != null) {
        queryParams['min_analyses_uslovnaya_vyazkost'] = minAnalysesUslovnayaVyazkost.toString();
      }
      if (maxAnalysesUslovnayaVyazkost != null) {
        queryParams['max_analyses_uslovnaya_vyazkost'] = maxAnalysesUslovnayaVyazkost.toString();
      }
      if (minAnalysesDeltaE != null) {
        queryParams['min_analyses_delta_e'] = minAnalysesDeltaE.toString();
      }
      if (maxAnalysesDeltaE != null) {
        queryParams['max_analyses_delta_e'] = maxAnalysesDeltaE.toString();
      }
      if (minAnalysesDeltaL != null) {
        queryParams['min_analyses_delta_l'] = minAnalysesDeltaL.toString();
      }
      if (maxAnalysesDeltaL != null) {
        queryParams['max_analyses_delta_l'] = maxAnalysesDeltaL.toString();
      }
      if (minAnalysesDeltaA != null) {
        queryParams['min_analyses_delta_a'] = minAnalysesDeltaA.toString();
      }
      if (maxAnalysesDeltaA != null) {
        queryParams['max_analyses_delta_a'] = maxAnalysesDeltaA.toString();
      }
      if (minAnalysesDeltaB != null) {
        queryParams['min_analyses_delta_b'] = minAnalysesDeltaB.toString();
      }
      if (maxAnalysesDeltaB != null) {
        queryParams['max_analyses_delta_b'] = maxAnalysesDeltaB.toString();
      }
      
      // Пагинация
      if (limit != null) {
        queryParams['limit'] = limit.toString();
      }
      if (offset != null) {
        queryParams['offset'] = offset.toString();
      }

      final queryString = queryParams.isEmpty
          ? ''
          : '?${queryParams.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&')}';

      final path = '/api/stocks/$queryString'.replaceAll('//', '/');
      final response = await _apiClient.get(path);

      return AvailableStocksResponseModel.fromJson(response);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ParseException('Ошибка при получении остатков: $e');
    }
  }
}

class _StockApiClient extends ApiClient {
  _StockApiClient(NetworkClient networkClient, String baseUrl)
      : _baseUrl = baseUrl,
        super(networkClient);

  final String _baseUrl;

  @override
  Future<Map<String, dynamic>> get(
    String url, {
    Map<String, String>? headers,
  }) {
    return super.get(_buildUrl(url), headers: headers);
  }

  @override
  void setAuthToken(String? token) {}

  String _buildUrl(String path) {
    final base = _baseUrl.endsWith('/') ? _baseUrl.substring(0, _baseUrl.length - 1) : _baseUrl;
    final url = path.startsWith('/') ? path : '/$path';
    return '$base$url';
  }
}
