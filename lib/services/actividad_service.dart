import '../models/actividad.dart';
import 'api_service.dart';

class ActividadService {
  final ApiService _apiService;

  ActividadService(this._apiService);

  Future<List<Actividad>> listar() async {
    final response = await _apiService.dio.get(
      '/actividades',
    );

    final datos = response.data as List;

    return datos
        .map(
          (item) => Actividad.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<Actividad> obtener(int id) async {
    final response = await _apiService.dio.get(
      '/actividades/$id',
    );

    return Actividad.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<Actividad> crear({
    required String titulo,
    required String tipo,
    required DateTime fechaLimite,
    required String prioridad,
    required String estado,
    String? observacion,
  }) async {
    final response = await _apiService.dio.post(
      '/actividades',
      data: {
        'titulo': titulo,
        'tipo': tipo,
        'fecha_limite':
            fechaLimite.toIso8601String().split('T').first,
        'prioridad': prioridad,
        'estado': estado,
        'observacion': observacion,
      },
    );

    return Actividad.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<Actividad> actualizar({
    required int id,
    String? titulo,
    String? tipo,
    DateTime? fechaLimite,
    String? prioridad,
    String? estado,
    String? observacion,
  }) async {
    final data = <String, dynamic>{};

    if (titulo != null) {
      data['titulo'] = titulo;
    }

    if (tipo != null) {
      data['tipo'] = tipo;
    }

    if (fechaLimite != null) {
      data['fecha_limite'] =
          fechaLimite.toIso8601String().split('T').first;
    }

    if (prioridad != null) {
      data['prioridad'] = prioridad;
    }

    if (estado != null) {
      data['estado'] = estado;
    }

    if (observacion != null) {
      data['observacion'] = observacion;
    }

    final response = await _apiService.dio.put(
      '/actividades/$id',
      data: data,
    );

    return Actividad.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<void> eliminar(int id) async {
    await _apiService.dio.delete(
      '/actividades/$id',
    );
  }
}