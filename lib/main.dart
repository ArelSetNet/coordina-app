import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'controllers/auth_controller.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';

import 'routes/app_routes.dart';
import 'screens/inicio_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registro_screen.dart';

import 'config/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final apiService = Get.put(ApiService());

  final authService = Get.put(
    AuthService(apiService),
  );

  final authController = Get.put(
    AuthController(authService),
  );

  await authController.comprobarSesion();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return GetMaterialApp(
  title: 'CoordinaApp',
  debugShowCheckedModeBanner: false,
   theme: AppTheme.lightTheme,
  
  initialRoute: authController.estaAutenticado
        ? AppRoutes.inicio
        : AppRoutes.login,

  getPages: [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.registro,
      page: () => const RegistroScreen(),
    ),
    GetPage(
      name: AppRoutes.inicio,
      page: () => const InicioScreen(),
    ),
  ],

);
  }
}

