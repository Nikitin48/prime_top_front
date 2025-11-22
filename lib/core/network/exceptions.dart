class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  const NetworkException(this.message, {this.statusCode});

  @override
  String toString() => 'NetworkException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

class ServerException extends NetworkException {
  const ServerException(super.message, {super.statusCode});
}

class ClientException extends NetworkException {
  const ClientException(super.message, {super.statusCode});
}

class ConnectionException extends NetworkException {
  const ConnectionException([super.message = 'Ошибка подключения к серверу']);
}

class ParseException extends NetworkException {
  const ParseException([super.message = 'Ошибка парсинга ответа сервера']);
}

class UnauthorizedException extends ClientException {
  const UnauthorizedException([super.message = 'Неверные учетные данные']);
}

class ConflictException extends ClientException {
  const ConflictException([super.message = 'Конфликт данных']);
}
