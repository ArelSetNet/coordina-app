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

          return Column(
  children: [
    Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Filtrar actividades',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue:
                      controller.filtroEstado.value,
                  decoration: const InputDecoration(
                    labelText: 'Estado',
                    prefixIcon: Icon(
                      Icons.filter_alt_outlined,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Todos',
                      child: Text('Todos'),
                    ),
                    DropdownMenuItem(
                      value: 'Pendiente',
                      child: Text('Pendiente'),
                    ),
                    DropdownMenuItem(
                      value: 'En proceso',
                      child: Text('En proceso'),
                    ),
                    DropdownMenuItem(
                      value: 'Completada',
                      child: Text('Completada'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      controller
                          .cambiarFiltroEstado(value);
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue:
                      controller.filtroPrioridad.value,
                  decoration: const InputDecoration(
                    labelText: 'Prioridad',
                    prefixIcon: Icon(
                      Icons.flag_outlined,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Todas',
                      child: Text('Todas'),
                    ),
                    DropdownMenuItem(
                      value: 'Alta',
                      child: Text('Alta'),
                    ),
                    DropdownMenuItem(
                      value: 'Media',
                      child: Text('Media'),
                    ),
                    DropdownMenuItem(
                      value: 'Baja',
                      child: Text('Baja'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      controller
                          .cambiarFiltroPrioridad(value);
                    }
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: controller.limpiarFiltros,
              icon: const Icon(
                Icons.refresh_outlined,
              ),
              label: const Text(
                'Limpiar filtros',
              ),
            ),
          ),
        ],
      ),
    ),

    Expanded(
      child: RefreshIndicator(
        onRefresh: controller.cargarActividades,
        child: Obx(
          () {
            final lista =
                controller.actividadesFiltradas;

            if (lista.isEmpty) {
              return ListView(
                physics:
                    const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 120),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Icon(
                            Icons.filter_alt_off_outlined,
                            size: 56,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'No hay actividades que coincidan con los filtros.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: lista.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final actividad = lista[index];

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
                    trailing:
                        PopupMenuButton<String>(
                      onSelected: (opcion) async {
                        if (opcion == 'editar') {
                          await Get.to(
                            () =>
                                ActividadFormScreen(
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
                      itemBuilder:
                          (context) => const [
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
            );
          },
        ),
      ),
    ),
  ],
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