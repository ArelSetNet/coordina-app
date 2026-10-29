import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:coordina_app/controllers/auth_controller.dart';
import 'package:coordina_app/main.dart';
import 'package:coordina_app/services/api_service.dart';
import 'package:coordina_app/services/auth_service.dart';

void main() {
  setUp(() {
    final apiService = Get.put(ApiService());
    final authService = Get.put(AuthService(apiService));
    Get.put(AuthController(authService));
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('La aplicación muestra la pantalla de inicio de sesión',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('CoordinaApp'), findsOneWidget);
    expect(find.text('Gestión de actividades académicas'), findsOneWidget);
    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(find.text('Crear una cuenta'), findsOneWidget);
  });
}