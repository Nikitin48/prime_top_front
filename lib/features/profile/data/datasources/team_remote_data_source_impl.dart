import 'package:prime_top_front/core/network/api_client.dart';
import 'package:prime_top_front/core/network/exceptions.dart';
import 'package:prime_top_front/core/network/network_client.dart';
import 'package:prime_top_front/features/profile/data/datasources/team_remote_data_source.dart';
import 'package:prime_top_front/features/profile/data/models/team_member_model.dart';

class TeamRemoteDataSourceImpl implements TeamRemoteDataSource {
  TeamRemoteDataSourceImpl({
    required NetworkClient networkClient,
    required String baseUrl,
    required String? Function() getAuthToken,
  }) : _apiClient = _TeamApiClient(networkClient, baseUrl, getAuthToken);

  final _TeamApiClient _apiClient;

  @override
  Future<List<TeamMemberModel>> getMembers({required String clientId}) async {
    try {
      final response = await _apiClient.get('/api/clients/$clientId/users/');
      final results = response['users'] as List<dynamic>? ?? [];
      return results
          .map((item) => TeamMemberModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ParseException('Не удалось загрузить команду: $e');
    }
  }
}

class _TeamApiClient extends ApiClient {
  _TeamApiClient(NetworkClient client, this._baseUrl, this._getAuthToken) : super(client);

  final String _baseUrl;
  final String? Function() _getAuthToken;

  @override
  Future<Map<String, dynamic>> get(String url, {Map<String, String>? headers}) {
    return super.get(_buildUrl(url), headers: _mergeHeaders(headers));
  }

  @override
  void setAuthToken(String? token) {}

  String _buildUrl(String path) {
    final base = _baseUrl.endsWith('/') ? _baseUrl.substring(0, _baseUrl.length - 1) : _baseUrl;
    final url = path.startsWith('/') ? path : '/$path';
    return '$base$url';
  }

  Map<String, String> _mergeHeaders(Map<String, String>? additionalHeaders) {
    final headers = <String, String>{};
    final token = _getAuthToken();
    if (token != null) {
      headers['Authorization'] = 'Token $token';
    }
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }
    return headers;
  }
}
