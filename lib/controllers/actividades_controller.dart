import 'package:get/get.dart';

import '../models/actividad.dart';
import '../services/actividad_service.dart';

class ActividadesController extends GetxController {
  final ActividadService actividadService;

  ActividadesController(this.actividadService);

  final RxList<Actividad> actividades = <Actividad>[].obs;
  final RxBool cargando = false.obs;
  final RxString mensajeError = ''.obs;

  final RxString filtroEstado = 'Todos'.obs;
  final RxString filtroPrioridad = 'Todas'.obs;

  List<Actividad> get actividadesFiltradas {
  return actividades.where((actividad) {
    final coincideEstado =
        filtroEstado.value == 'Todos' ||
        actividad.estado == filtroEstado.value;

    final coincidePrioridad =
        filtroPrioridad.value == 'Todas' ||
        actividad.prioridad == filtroPrioridad.value;

    return coincideEstado && coincidePrioridad;
  }).toList();
}

void cambiarFiltroEstado(String estado) {
  filtroEstado.value = estado;
}

void cambiarFiltroPrioridad(String prioridad) {
  filtroPrioridad.value = prioridad;
}

void limpiarFiltros() {
  filtroEstado.value = 'Todos';
  filtroPrioridad.value = 'Todas';
}

  Future<void> cargarActividades() async {
    try {
      cargando.value = true;
      mensajeError.value = '';

      final resultado = await actividadService.listar();

      actividades.assignAll(resultado);
    } catch (_) {
      mensajeError.value =
          'No se pudieron cargar las actividades.';
    } finally {
      cargando.value = false;
    }
  }

  Future<bool> crearActividad({
    required String titulo,
    required String tipo,
    required DateTime fechaLimite,
    required String prioridad,
    required String estado,
    String? observacion,
   }) async {
  try {
    cargando.value = true;
    mensajeError.value = '';

    final nuevaActividad = await actividadService.crear(
      titulo: titulo,
      tipo: tipo,
      fechaLimite: fechaLimite,
      prioridad: prioridad,
      estado: estado,
      observacion: observacion,
    );

    actividades.add(nuevaActividad);

    actividades.sort(
      (a, b) => a.fechaLimite.compareTo(b.fechaLimite),
    );

    return true;
  } catch (_) {
    mensajeError.value =
        'No se pudo crear la actividad.';
    return false;
  } finally {
    cargando.value = false;
  }
 }

Future<bool> actualizarActividad({
  required int id,
  required String titulo,
  required String tipo,
  required DateTime fechaLimite,
  required String prioridad,
  required String estado,
  String? observacion,
}) async {
  try {
    cargando.value = true;
    mensajeError.value = '';

    final actividadActualizada =
        await actividadService.actualizar(
      id: id,
      titulo: titulo,
      tipo: tipo,
      fechaLimite: fechaLimite,
      prioridad: prioridad,
      estado: estado,
      observacion: observacion,
    );

    final index = actividades.indexWhere(
      (actividad) => actividad.id == id,
    );

    if (index != -1) {
      actividades[index] = actividadActualizada;
    }

    actividades.sort(
      (a, b) => a.fechaLimite.compareTo(b.fechaLimite),
    );

    return true;
  } catch (_) {
    mensajeError.value =
        'No se pudo actualizar la actividad.';
    return false;
  } finally {
    cargando.value = false;
  }
}

  Future<bool> eliminarActividad(
    int id,
  ) async {
    try {
      cargando.value = true;
      mensajeError.value = '';


      await actividadService.eliminar(id);

      actividades.removeWhere(
        (actividad) => actividad.id == id,
      );

      return true;
    } catch (_) {
      mensajeError.value =
          'No se pudo eliminar la actividad.';
      return false;
    } finally {
      cargando.value = false;
    }
  }

  void limpiarError() {
    mensajeError.value = '';
  }
}