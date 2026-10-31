class Actividad {
  final int id;
  final String titulo;
  final String tipo;
  final DateTime fechaLimite;
  final String prioridad;
  final String estado;
  final String? observacion;
  final int usuarioId;

  const Actividad({
    required this.id,
    required this.titulo,
    required this.tipo,
    required this.fechaLimite,
    required this.prioridad,
    required this.estado,
    this.observacion,
    required this.usuarioId,
  });

  factory Actividad.fromJson(Map<String, dynamic> json) {
    return Actividad(
      id: json['id'] as int,
      titulo: json['titulo'] as String,
      tipo: json['tipo'] as String,
      fechaLimite: DateTime.parse(
        json['fecha_limite'] as String,
      ),
      prioridad: json['prioridad'] as String,
      estado: json['estado'] as String,
      observacion: json['observacion'] as String?,
      usuarioId: json['usuario_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'tipo': tipo,
      'fecha_limite':
          fechaLimite.toIso8601String().split('T').first,
      'prioridad': prioridad,
      'estado': estado,
      'observacion': observacion,
    };
  }
}