import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

import '../config/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthController authController = Get.find<AuthController>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final exito = await authController.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );


    if (exito) {
      Get.snackbar(
        'Bienvenido',
        'Inicio de sesión correcto.',
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.offAllNamed('/inicio');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CoordinaApp'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.school_outlined,
                    size: 72,
                    color: AppTheme.azulPrincipal,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Gestión de actividades académicas',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.azulPrincipal,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Correo electrónico',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      final correo = value?.trim() ?? '';

                      if (correo.isEmpty) {
                        return 'Ingresa tu correo electrónico.';
                      }

                      if (!GetUtils.isEmail(correo)) {
                        return 'Ingresa un correo válido.';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa tu contraseña.';
                      }

                      if (value.length < 6) {
                        return 'La contraseña debe tener al menos 6 caracteres.';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Obx(
                    () => ElevatedButton(
                      onPressed: authController.cargando.value
                          ? null
                          : _iniciarSesion,
                      child: authController.cargando.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Iniciar sesión'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Obx(
                    () {
                      final mensaje = authController.mensajeError.value;

                      if (mensaje.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return Text(
                        mensaje,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      Get.toNamed('/registro');
                    },
                    child: const Text(
                      'Crear una cuenta',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}