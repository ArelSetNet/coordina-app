import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  Future<void> _cerrarSesion() async {
    final authController = Get.find<AuthController>();

    await authController.logout();

    Get.offAllNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('CoordinaApp'),
        actions: [
          IconButton(
            onPressed: _cerrarSesion,
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.school_outlined,
                size: 72,
              ),
              const SizedBox(height: 16),
              Text(
                'Bienvenido',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                authController.usuario.value?.nombre ?? '',
              ),
              const SizedBox(height: 4),
              Text(
                authController.usuario.value?.email ?? '',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: () {
                  Get.toNamed(
                    AppRoutes.actividades,
                  );
                },
                icon: const Icon(
                  Icons.event_note_outlined,
                ),
                label: const Text(
                  'Ver actividades',
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}