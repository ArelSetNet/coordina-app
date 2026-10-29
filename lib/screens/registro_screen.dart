import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

import '../config/app_theme.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthController authController = Get.find<AuthController>();

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _registrar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final exito = await authController.registrar(
      nombre: _nombreController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (exito) {
      Get.snackbar(
        'Cuenta creada',
        'Registro completado correctamente.',
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.offAllNamed('/inicio');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear cuenta'),
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
                    Icons.person_add_alt_1_outlined,
                    size: 72,
                    color: AppTheme.azulPrincipal
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      final nombre = value?.trim() ?? '';

                      if (nombre.isEmpty) {
                        return 'Ingresa tu nombre.';
                      }

                      if (nombre.length < 3) {
                        return 'El nombre debe tener al menos 3 caracteres.';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
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
                        return 'Ingresa una contraseña.';
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
                          : _registrar,
                      child: authController.cargando.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Registrarme'),
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
                      Get.back();
                    },
                    child: const Text(
                      'Ya tengo una cuenta',
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