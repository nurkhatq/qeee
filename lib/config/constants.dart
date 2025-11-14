// lib/config/constants.dart

import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Конфигурационный файл с константами приложения
///
/// Использует переменные окружения из файла .env для безопасного хранения учетных данных
library;

class AppConstants {
  // ============================================
  // Google Sheets Configuration
  // ============================================

  /// Проверка, что все необходимые переменные окружения заданы
  static void validateEnvironment() {
    final requiredVars = [
      'GOOGLE_PROJECT_ID',
      'GOOGLE_PRIVATE_KEY_ID',
      'GOOGLE_PRIVATE_KEY',
      'GOOGLE_CLIENT_EMAIL',
      'GOOGLE_CLIENT_ID',
      'GOOGLE_SPREADSHEET_ID',
    ];

    final missingVars = <String>[];
    for (final varName in requiredVars) {
      if (!dotenv.env.containsKey(varName) ||
          dotenv.env[varName]!.isEmpty ||
          dotenv.env[varName]!.startsWith('your') ||
          dotenv.env[varName]!.startsWith('YOUR')) {
        missingVars.add(varName);
      }
    }

    if (missingVars.isNotEmpty) {
      throw Exception(
        '❌ Ошибка конфигурации!\n\n'
        'Не заполнены следующие переменные в .env файле:\n'
        '${missingVars.map((v) => '  • $v').join('\n')}\n\n'
        'Пожалуйста:\n'
        '1. Скопируйте .env.example в .env\n'
        '2. Заполните все необходимые данные\n'
        '3. Перезапустите приложение\n\n'
        'Инструкция по настройке в файле .env.example'
      );
    }
  }

  /// Формирование JSON credentials для Service Account из переменных окружения
  static String get googleCredentials {
    return '''{
  "type": "service_account",
  "project_id": "${dotenv.env['GOOGLE_PROJECT_ID']}",
  "private_key_id": "${dotenv.env['GOOGLE_PRIVATE_KEY_ID']}",
  "private_key": "${dotenv.env['GOOGLE_PRIVATE_KEY']}",
  "client_email": "${dotenv.env['GOOGLE_CLIENT_EMAIL']}",
  "client_id": "${dotenv.env['GOOGLE_CLIENT_ID']}",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "${dotenv.env['GOOGLE_CLIENT_CERT_URL'] ?? 'https://www.googleapis.com/robot/v1/metadata/x509/${dotenv.env['GOOGLE_CLIENT_EMAIL']?.replaceAll('@', '%40')}'}",
  "universe_domain": "googleapis.com"
}''';
  }

  /// ID вашей Google Sheets таблицы
  static String get spreadsheetId =>
      dotenv.env['GOOGLE_SPREADSHEET_ID'] ?? '';

  /// Название листа в таблице
  static String get worksheetName =>
      dotenv.env['GOOGLE_WORKSHEET_NAME'] ?? 'Sheet1';

  // ============================================
  // App Configuration
  // ============================================

  /// Название приложения
  static const String appName = 'QR Scanner';

  /// Версия приложения
  static const String appVersion = '1.0.0';

  // ============================================
  // Scanning Configuration
  // ============================================

  /// Таймаут для скачивания PDF (в секундах)
  static const int downloadTimeout = 30;

  /// Максимальный размер PDF для скачивания (в байтах)
  /// 50 MB = 50 * 1024 * 1024
  static const int maxPdfSize = 52428800;

  /// Задержка перед повторным сканированием того же QR кода (в секундах)
  static const int scanCooldown = 3;

  // ============================================
  // Database Configuration
  // ============================================

  /// Название локальной базы данных
  static const String dbName = 'qr_scanner.db';

  /// Версия базы данных
  static const int dbVersion = 1;

  // ============================================
  // Google Sheets Column Names
  // ============================================

  /// Названия колонок в Google Sheets
  static const List<String> sheetHeaders = [
    'Дата загрузки',
    'Дата приема-передачи',
    'Источник',
    'Номер по порядку',
    'Номер места',
    'Вес',
    'Номер заказа',
  ];

  // ============================================
  // UI Configuration
  // ============================================

  /// Цвета приложения
  static const int primaryColorValue = 0xFF2196F3;
  static const int accentColorValue = 0xFF4CAF50;
  static const int errorColorValue = 0xFFF44336;

  // ============================================
  // Logging
  // ============================================

  /// Включить детальное логирование
  static const bool enableDetailedLogging = true;

  /// Сохранять логи в файл
  static const bool saveLogsToFile = false;
}
