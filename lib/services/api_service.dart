import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config/app_config.dart';

class ApiService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  late final Dio dio;

  ApiService() {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'token');

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          handler.next(options);
        },
      ),
    );
  }

  Future<void> guardarToken(String token) async {
    await _storage.write(
      key: 'token',
      value: token,
    );
  }

  Future<String?> obtenerToken() async {
    return _storage.read(key: 'token');
  }

  Future<void> eliminarToken() async {
    await _storage.delete(key: 'token');
  }
}