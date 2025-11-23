class ApiConfig {
  // В Docker окружении используем пустую строку для относительных путей (nginx proxy)
  // Для локальной разработки можно установить 'http://localhost:8000'
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '', // Пустая строка = относительные пути
  );
}
