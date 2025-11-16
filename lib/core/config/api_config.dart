/// Конфигурация API
class ApiConfig {
  /// Базовый URL API
  /// Можно изменить на нужный URL бекенда
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000',
  );
}

