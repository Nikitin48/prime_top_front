/// Базовое исключение для сетевых ошибок
class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  const NetworkException(this.message, {this.statusCode});

  @override
  String toString() => 'NetworkException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

/// Ошибка сервера (5xx)
class ServerException extends NetworkException {
  const ServerException(super.message, {super.statusCode});
}

/// Ошибка клиента (4xx)
class ClientException extends NetworkException {
  const ClientException(super.message, {super.statusCode});
}

/// Ошибка подключения
class ConnectionException extends NetworkException {
  const ConnectionException([super.message = 'Ошибка подключения к серверу']);
}

/// Ошибка парсинга ответа
class ParseException extends NetworkException {
  const ParseException([super.message = 'Ошибка парсинга ответа сервера']);
}

/// Ошибка авторизации (401)
class UnauthorizedException extends ClientException {
  const UnauthorizedException([super.message = 'Неверные учетные данные']);
}

/// Ошибка конфликта (409)
class ConflictException extends ClientException {
  const ConflictException([super.message = 'Конфликт данных']);
}

