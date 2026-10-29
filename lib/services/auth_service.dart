import 'package:dio/dio.dart';

import '../models/usuario.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService;

  AuthService(this._apiService);

  Future<Usuario> registrar({
    required String nombre,
    required String email,
    required String password,
  }) async {
    final response = await _apiService.dio.post(
      '/auth/register',
      data: {
        'nombre': nombre,
        'email': email,
        'password': password,
      },
    );

    return Usuario.fromJson(response.data);
  }

  Future<Usuario> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiService.dio.post(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    final token = response.data['access_token'] as String;

    await _apiService.guardarToken(token);

    return obtenerUsuarioActual();
  }

  Future<Usuario> obtenerUsuarioActual() async {
    final response = await _apiService.dio.get(
      '/usuarios/me',
    );

    return Usuario.fromJson(response.data);
  }

  Future<void> logout() async {
    await _apiService.eliminarToken();
  }

  Future<bool> tieneSesion() async {
    final token = await _apiService.obtenerToken();

    return token != null && token.isNotEmpty;
  }

  String obtenerMensajeError(Object error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;

      if (statusCode == 401) {
        return 'Correo o contraseña incorrectos.';
      }

      if (statusCode == 409) {
        return 'Ya existe una cuenta con ese correo.';
      }

      if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout) {
        return 'No se pudo conectar con el servidor.';
      }

      final data = error.response?.data;

      if (data is Map<String, dynamic>) {
        final detalle = data['detail'];

        if (detalle is String && detalle.isNotEmpty) {
          return detalle;
        }
      }
    }

    return 'Ocurrió un problema. Intenta nuevamente.';
  }
}