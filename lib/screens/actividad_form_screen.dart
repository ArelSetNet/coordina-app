import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/actividades_controller.dart';
import '../models/actividad.dart';

class ActividadFormScreen extends StatefulWidget {
  final Actividad? actividad;

  const ActividadFormScreen({
    super.key,
    this.actividad,
  });

  @override
  State<ActividadFormScreen> createState() =>
      _ActividadFormScreenState();
}

class _ActividadFormScreenState
    extends State<ActividadFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _tituloController = TextEditingController();
  final _observacionController = TextEditingController();

  final ActividadesController controller =
      Get.find<ActividadesController>();

  String _tipo = 'Planificación';
  String _prioridad = 'Media';
  String _estado = 'Pendiente';

  DateTime _fechaLimite = DateTime.now().add(
    const Duration(days: 7),
  );

  final tipos = const [
    'Planificación',
    'Seguimiento',
    'Informe',
    'Reunión',
    'Docencia',
    'Otros',
  ];

  final prioridades = const [
    'Alta',
    'Media',
    'Baja',
  ];

  final estados = const [
    'Pendiente',
    'En proceso',
    'Completada',
  ];

  bool get esEdicion => widget.actividad != null;

  @override
  void initState() {
    super.initState();

    final actividad = widget.actividad;

    if (actividad != null) {
      _tituloController.text = actividad.titulo;
      _observacionController.text =
          actividad.observacion ?? '';

      _tipo = actividad.tipo;
      _prioridad = actividad.prioridad;
      _estado = actividad.estado;
      _fechaLimite = actividad.fechaLimite;
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _observacionController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fechaLimite,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(
        const Duration(days: 365 * 3),
      ),
    );

    if (fecha != null) {
      setState(() {
        _fechaLimite = fecha;
      });
    }
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final observacion =
        _observacionController.text.trim().isEmpty
            ? null
            : _observacionController.text.trim();

    bool exito;

    if (esEdicion) {
      exito = await controller.actualizarActividad(
        id: widget.actividad!.id,
        titulo: _tituloController.text.trim(),
        tipo: _tipo,
        fechaLimite: _fechaLimite,
        prioridad: _prioridad,
        estado: _estado,
        observacion: observacion,
      );
    } else {
      exito = await controller.crearActividad(
        titulo: _tituloController.text.trim(),
        tipo: _tipo,
        fechaLimite: _fechaLimite,
        prioridad: _prioridad,
        estado: _estado,
        observacion: observacion,
      );
    }

    if (exito) {
      Get.back();

      Get.snackbar(
        esEdicion
            ? 'Actividad actualizada'
            : 'Actividad creada',
        esEdicion
            ? 'Los cambios se guardaron correctamente.'
            : 'La actividad se registró correctamente.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          esEdicion
              ? 'Editar actividad'
              : 'Nueva actividad',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _tituloController,
                  decoration: const InputDecoration(
                    labelText: 'Actividad',
                    prefixIcon:
                        Icon(Icons.task_alt_outlined),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Ingresa el nombre de la actividad.';
                    }

                    if (value.trim().length < 4) {
                      return 'El nombre es demasiado corto.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  initialValue: _tipo,
                  decoration: const InputDecoration(
                    labelText: 'Tipo',
                    prefixIcon:
                        Icon(Icons.category_outlined),
                  ),
                  items: tipos
                      .map(
                        (tipo) => DropdownMenuItem(
                          value: tipo,
                          child: Text(tipo),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _tipo = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  initialValue: _prioridad,
                  decoration: const InputDecoration(
                    labelText: 'Prioridad',
                    prefixIcon:
                        Icon(Icons.flag_outlined),
                  ),
                  items: prioridades
                      .map(
                        (prioridad) =>
                            DropdownMenuItem(
                          value: prioridad,
                          child: Text(prioridad),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _prioridad = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  initialValue: _estado,
                  decoration: const InputDecoration(
                    labelText: 'Estado',
                    prefixIcon:
                        Icon(Icons.timelapse_outlined),
                  ),
                  items: estados
                      .map(
                        (estado) => DropdownMenuItem(
                          value: estado,
                          child: Text(estado),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _estado = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),

                InkWell(
                  onTap: _seleccionarFecha,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Fecha límite',
                      prefixIcon:
                          Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      '${_fechaLimite.day.toString().padLeft(2, '0')}/'
                      '${_fechaLimite.month.toString().padLeft(2, '0')}/'
                      '${_fechaLimite.year}',
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _observacionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Observación',
                    alignLabelWithHint: true,
                    prefixIcon:
                        Icon(Icons.notes_outlined),
                  ),
                ),
                const SizedBox(height: 24),

                Obx(
                  () => ElevatedButton.icon(
                    onPressed:
                        controller.cargando.value
                            ? null
                            : _guardar,
                    icon: controller.cargando.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : Icon(
                            esEdicion
                                ? Icons.save_as_outlined
                                : Icons.save_outlined,
                          ),
                    label: Text(
                      esEdicion
                          ? 'Guardar cambios'
                          : 'Guardar actividad',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}