import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/actividades_controller.dart';
import '../routes/app_routes.dart';
import 'actividad_form_screen.dart';

class ActividadesScreen extends StatefulWidget {
  const ActividadesScreen({super.key});

  @override
  State<ActividadesScreen> createState() =>
      _ActividadesScreenState();
}

class _ActividadesScreenState
    extends State<ActividadesScreen> {
  final ActividadesController controller =
      Get.find<ActividadesController>();

  @override
  void initState() {
    super.initState();
    controller.cargarActividades();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actividades'),
      ),

      body: Obx(
        () {
          if (controller.cargando.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (controller.mensajeError.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      controller.mensajeError.value,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed:
                          controller.cargarActividades,
                      child: const Text(
                        'Reintentar',
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (controller.actividades.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.event_note_outlined,
                      size: 64,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No tienes actividades registradas.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.cargarActividades,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: controller.actividades.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final actividad =
                    controller.actividades[index];

                return Card(
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.all(16),

                    leading: const CircleAvatar(
                      child: Icon(
                        Icons.task_alt,
                      ),
                    ),

                    title: Text(
                      actividad.titulo,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    subtitle: Padding(
                      padding:
                          const EdgeInsets.only(top: 8),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            actividad.tipo,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Estado: ${actividad.estado}',
                          ),
                          Text(
                            'Prioridad: ${actividad.prioridad}',
                          ),
                          Text(
                            'Fecha límite: '
                            '${actividad.fechaLimite.day.toString().padLeft(2, '0')}/'
                            '${actividad.fechaLimite.month.toString().padLeft(2, '0')}/'
                            '${actividad.fechaLimite.year}',
                          ),
                        ],
                      ),
                    ),

                    trailing: PopupMenuButton<String>(
                      onSelected: (opcion) async {
                        if (opcion == 'editar') {
                          await Get.to(
                            () => ActividadFormScreen(
                              actividad: actividad,
                            ),
                          );
                        }

                        if (opcion == 'eliminar') {
                          final confirmar =
                              await Get.dialog<bool>(
                            AlertDialog(
                              title: const Text(
                                'Eliminar actividad',
                              ),
                              content: Text(
                                '¿Deseas eliminar "${actividad.titulo}"?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Get.back(
                                      result: false,
                                    );
                                  },
                                  child: const Text(
                                    'Cancelar',
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Get.back(
                                      result: true,
                                    );
                                  },
                                  child: const Text(
                                    'Eliminar',
                                  ),
                                ),
                              ],
                            ),
                          );

                          if (confirmar == true) {
                            final exito =
                                await controller
                                    .eliminarActividad(
                              actividad.id,
                            );

                            if (exito) {
                              Get.snackbar(
                                'Actividad eliminada',
                                'La actividad fue eliminada correctamente.',
                                snackPosition:
                                    SnackPosition.BOTTOM,
                              );
                            }
                          }
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: 'editar',
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit_outlined,
                              ),
                              SizedBox(width: 12),
                              Text('Editar'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'eliminar',
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_outline,
                              ),
                              SizedBox(width: 12),
                              Text('Eliminar'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(
            AppRoutes.actividadFormulario,
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}