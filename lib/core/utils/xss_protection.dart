/// Утилита для защиты от XSS (Cross-Site Scripting) атак
/// 
/// Предоставляет методы для санитизации и валидации пользовательского ввода
/// и данных, полученных из внешних источников (API, файлы и т.д.)
class XssProtection {
  /// Санитизирует строку, удаляя потенциально опасные HTML/JavaScript теги и символы
  /// 
  /// Удаляет:
  /// - HTML теги (<script>, <iframe>, <object>, <embed> и т.д.)
  /// - JavaScript события (onclick, onerror и т.д.)
  /// - Опасные протоколы (javascript:, data:, vbscript:)
  /// - HTML entities, которые могут быть использованы для обхода защиты
  static String sanitize(String? input) {
    if (input == null || input.isEmpty) {
      return '';
    }

    String sanitized = input;

    sanitized = sanitized.replaceAll(RegExp(r'<[^>]*>', multiLine: true), '');

    sanitized = sanitized.replaceAll(
      RegExp(r'\s*on\w+\s*=\s*["\x27].*?["\x27]', caseSensitive: false, multiLine: true),
      '',
    );

    sanitized = sanitized.replaceAll(
      RegExp(r'(javascript|data|vbscript|file|about):', caseSensitive: false),
      '',
    );

    sanitized = sanitized
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#x27;', "'")
        .replaceAll('&#x2F;', '/')
        .replaceAll('&amp;', '&');

    sanitized = sanitized.replaceAll(RegExp(r'<[^>]*>', multiLine: true), '');

    sanitized = sanitized.replaceAll(RegExp(r'[<>]'), '');

    return sanitized.trim();
  }

  /// Санитизирует строку для использования в HTML атрибутах
  /// 
  /// Экранирует специальные символы HTML
  static String sanitizeForHtmlAttribute(String? input) {
    if (input == null || input.isEmpty) {
      return '';
    }

    return sanitize(input)
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;')
        .replaceAll('/', '&#x2F;');
  }

  /// Санитизирует строку для использования в URL
  /// 
  /// Удаляет опасные протоколы и символы
  static String sanitizeForUrl(String? input) {
    if (input == null || input.isEmpty) {
      return '';
    }

    String sanitized = sanitize(input);

    final dangerousProtocols = [
      'javascript:',
      'data:',
      'vbscript:',
      'file:',
      'about:',
    ];

    for (final protocol in dangerousProtocols) {
      if (sanitized.toLowerCase().startsWith(protocol)) {
        sanitized = sanitized.substring(protocol.length);
      }
    }

    return sanitized.trim();
  }

  /// Валидирует email адрес и санитизирует его
  static String? validateAndSanitizeEmail(String? email) {
    if (email == null || email.isEmpty) {
      return null;
    }

    final sanitized = sanitize(email.trim().toLowerCase());

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(sanitized)) {
      return null;
    }

    return sanitized;
  }

  /// Валидирует и санитизирует имя пользователя
  /// 
  /// Разрешает только буквы, цифры, пробелы, дефисы и подчеркивания
  static String? validateAndSanitizeName(String? name) {
    if (name == null || name.isEmpty) {
      return null;
    }

    final sanitized = sanitize(name.trim());

    final nameRegex = RegExp(r'^[a-zA-Zа-яА-ЯёЁ0-9\s\-_]+$');

    if (!nameRegex.hasMatch(sanitized)) {
      return null;
    }

    if (sanitized.length > 100) {
      return sanitized.substring(0, 100).trim();
    }

    return sanitized;
  }

  /// Валидирует и санитизирует имя файла
  static String? validateAndSanitizeFileName(String? fileName) {
    if (fileName == null || fileName.isEmpty) {
      return null;
    }

    String sanitized = sanitize(fileName.trim());

    sanitized = sanitized.replaceAll(RegExp(r'[<>:"|?*\\/]'), '');

    if (sanitized.length > 255) {
      sanitized = sanitized.substring(0, 255);
    }

    return sanitized.isEmpty ? null : sanitized;
  }

  /// Проверяет, содержит ли строка потенциально опасный контент
  static bool containsDangerousContent(String? input) {
    if (input == null || input.isEmpty) {
      return false;
    }

    final dangerousPatterns = [
      RegExp(r'<script', caseSensitive: false),
      RegExp(r'javascript:', caseSensitive: false),
      RegExp(r'on\w+\s*=', caseSensitive: false),
      RegExp(r'<iframe', caseSensitive: false),
      RegExp(r'<object', caseSensitive: false),
      RegExp(r'<embed', caseSensitive: false),
      RegExp(r'data:text/html', caseSensitive: false),
      RegExp(r'vbscript:', caseSensitive: false),
    ];

    for (final pattern in dangerousPatterns) {
      if (pattern.hasMatch(input)) {
        return true;
      }
    }

    return false;
  }

  /// Санитизирует данные из Map (например, из JSON ответа API)
  static Map<String, dynamic> sanitizeMap(Map<String, dynamic>? data) {
    if (data == null) {
      return {};
    }

    final sanitized = <String, dynamic>{};

    for (final entry in data.entries) {
      final key = sanitize(entry.key);
      final value = entry.value;

      if (value is String) {
        sanitized[key] = sanitize(value);
      } else if (value is Map) {
        sanitized[key] = sanitizeMap(value as Map<String, dynamic>);
      } else if (value is List) {
        sanitized[key] = sanitizeList(value);
      } else {
        sanitized[key] = value;
      }
    }

    return sanitized;
  }

  /// Санитизирует данные из List
  static List<dynamic> sanitizeList(List<dynamic>? data) {
    if (data == null) {
      return [];
    }

    return data.map((item) {
      if (item is String) {
        return sanitize(item);
      } else if (item is Map) {
        return sanitizeMap(item as Map<String, dynamic>);
      } else if (item is List) {
        return sanitizeList(item);
      } else {
        return item;
      }
    }).toList();
  }
}

