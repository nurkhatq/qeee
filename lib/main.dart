// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'providers/app_provider.dart';
import 'screens/scanner_screen.dart';
import 'screens/records_screen.dart';
import 'config/constants.dart';

void main() async {
  // Инициализация Flutter bindings
  WidgetsFlutterBinding.ensureInitialized();

  // Загрузка переменных окружения из .env файла
  try {
    await dotenv.load(fileName: '.env');
    Logger().i('✅ Переменные окружения загружены');

    // Валидация конфигурации
    AppConstants.validateEnvironment();
    Logger().i('✅ Конфигурация Google Sheets валидна');
  } catch (e) {
    Logger().e('❌ Ошибка загрузки конфигурации: $e');
    // Продолжаем работу, но пользователь увидит ошибку при попытке синхронизации
  }

  // Настройка ориентации (только портретная)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Настройка логирования
  Logger.level = AppConstants.enableDetailedLogging ? Level.debug : Level.info;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider()..initialize(),
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Color(AppConstants.primaryColorValue),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(AppConstants.primaryColorValue),
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 2,
          ),
          cardTheme: CardThemeData(
            elevation: 2,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 2,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        home: const ScannerScreen(),
        routes: {
          '/records': (context) => const RecordsScreen(),
        },
      ),
    );
  }
}