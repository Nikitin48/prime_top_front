import 'package:http/http.dart' as http;

abstract class NetworkClient {
  Future<http.Response> get(
    String url, {
    Map<String, String>? headers,
  });

  Future<http.Response> post(
    String url, {
    Map<String, String>? headers,
    Object? body,
  });

  Future<http.Response> put(
    String url, {
    Map<String, String>? headers,
    Object? body,
  });

  Future<http.Response> patch(
    String url, {
    Map<String, String>? headers,
    Object? body,
  });

  Future<http.Response> delete(
    String url, {
    Map<String, String>? headers,
  });
}

class HttpClient implements NetworkClient {
  HttpClient({
    String? baseUrl,
    Map<String, String>? defaultHeaders,
  })  : _baseUrl = baseUrl ?? '',
        _defaultHeaders = defaultHeaders ?? {};

  final String _baseUrl;
  final Map<String, String> _defaultHeaders;
  final http.Client _client = http.Client();

  String _buildUrl(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    final base = _baseUrl.endsWith('/') ? _baseUrl.substring(0, _baseUrl.length - 1) : _baseUrl;
    final url = path.startsWith('/') ? path : '/$path';
    return '$base$url';
  }

  Map<String, String> _mergeHeaders(Map<String, String>? additionalHeaders) {
    final headers = Map<String, String>.from(_defaultHeaders);
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }
    return headers;
  }

  @override
  Future<http.Response> get(
    String url, {
    Map<String, String>? headers,
  }) {
    return _client.get(
      Uri.parse(_buildUrl(url)),
      headers: _mergeHeaders(headers),
    );
  }

  @override
  Future<http.Response> post(
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) {
    return _client.post(
      Uri.parse(_buildUrl(url)),
      headers: _mergeHeaders(headers),
      body: body,
    );
  }

  @override
  Future<http.Response> put(
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) {
    return _client.put(
      Uri.parse(_buildUrl(url)),
      headers: _mergeHeaders(headers),
      body: body,
    );
  }

  @override
  Future<http.Response> patch(
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) {
    return _client.patch(
      Uri.parse(_buildUrl(url)),
      headers: _mergeHeaders(headers),
      body: body,
    );
  }

  @override
  Future<http.Response> delete(
    String url, {
    Map<String, String>? headers,
  }) {
    return _client.delete(
      Uri.parse(_buildUrl(url)),
      headers: _mergeHeaders(headers),
    );
  }

  void dispose() {
    _client.close();
  }
}
