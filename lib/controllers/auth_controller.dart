import 'package:get/get.dart';

import '../models/usuario.dart';
import '../services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService authService;

  AuthController(this.authService);

  final Rxn<Usuario> usuario = Rxn<Usuario>();
  final RxBool cargando = false.obs;
  final RxString mensajeError = ''.obs;

  bool get estaAutenticado => usuario.value != null;

  Future<bool> registrar({
    required String nombre,
    required String email,
    required String password,
  }) async {
    try {
      cargando.value = true;
      mensajeError.value = '';

      await authService.registrar(
        nombre: nombre,
        email: email,
        password: password,
      );

      await login(
        email: email,
        password: password,
      );

      return true;
    } catch (error) {
      mensajeError.value = authService.obtenerMensajeError(error);
      return false;
    } finally {
      cargando.value = false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      cargando.value = true;
      mensajeError.value = '';

      final usuarioAutenticado = await authService.login(
        email: email,
        password: password,
      );

      usuario.value = usuarioAutenticado;

      return true;
    } catch (error) {
      mensajeError.value = authService.obtenerMensajeError(error);
      return false;
    } finally {
      cargando.value = false;
    }
  }

  Future<void> comprobarSesion() async {
    try {
      cargando.value = true;
      mensajeError.value = '';

      final tieneSesion = await authService.tieneSesion();

      if (!tieneSesion) {
        usuario.value = null;
        return;
      }

      usuario.value = await authService.obtenerUsuarioActual();
    } catch (error) {
      usuario.value = null;
      mensajeError.value = authService.obtenerMensajeError(error);

      await authService.logout();
    } finally {
      cargando.value = false;
    }
  }

  Future<void> logout() async {
    await authService.logout();

    usuario.value = null;
    mensajeError.value = '';
  }

  void limpiarError() {
    mensajeError.value = '';
  }
}