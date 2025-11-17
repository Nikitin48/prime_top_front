import 'package:prime_top_front/core/network/api_client.dart';
import 'package:prime_top_front/core/network/exceptions.dart';
import 'package:prime_top_front/core/network/network_client.dart';
import 'package:prime_top_front/features/coating_types/data/datasources/coating_types_remote_data_source.dart';
import 'package:prime_top_front/features/coating_types/data/models/coating_type_model.dart';

class CoatingTypesRemoteDataSourceImpl implements CoatingTypesRemoteDataSource {
  CoatingTypesRemoteDataSourceImpl({
    required NetworkClient networkClient,
    required String baseUrl,
  }) : _apiClient = _CoatingTypesApiClient(networkClient, baseUrl);

  final _CoatingTypesApiClient _apiClient;

  @override
  Future<List<CoatingTypeModel>> getCoatingTypes({String? sort}) async {
    try {
      final queryParams = <String, String>{};
      if (sort != null && sort.isNotEmpty) {
        queryParams['sort'] = sort;
      }

      final queryString = queryParams.isEmpty
          ? ''
          : '?${queryParams.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&')}';

      final path = '/api/coating-types/$queryString'.replaceAll('//', '/');
      final response = await _apiClient.get(path);

      final results = response['results'] as List<dynamic>?;
      if (results == null) {
        throw ParseException('Отсутствует поле results в ответе сервера');
      }

      return results
          .map((json) => CoatingTypeModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ParseException('Ошибка при получении типов покрытий: $e');
    }
  }
}

class _CoatingTypesApiClient extends ApiClient {
  _CoatingTypesApiClient(NetworkClient networkClient, String baseUrl)
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

