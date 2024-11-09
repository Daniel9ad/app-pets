class PublicationDetail {
  final int id;
  final String titulo;
  final String descripcion;
  final String raza;
  final int edad;
  final int cantidad_machos;
  final int cantidad_hembras;
  final String telefono;
  final DateTime fecha_publicacion;
  final int estado;
  final int usuario_id;
  final int ciudad_id;
  final int especie_id;

  PublicationDetail({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.raza,
    required this.edad,
    required this.cantidad_machos,
    required this.cantidad_hembras,
    required this.telefono,
    required this.fecha_publicacion,
    required this.estado,
    required this.usuario_id,
    required this.ciudad_id,
    required this.especie_id,
  });

  factory PublicationDetail.fromJson(Map<String, dynamic> json) {
    return PublicationDetail(
      id: json['id'],
      titulo: json['titulo'] ?? 'Sin título',
      descripcion: json['descripcion'] ?? 'Sin descripción',
      raza: json['raza'] ?? 'Sin raza',
      edad: json['edad'] ?? 0,
      cantidad_machos: json['cantidad_machos'] ?? 0,
      cantidad_hembras: json['cantidad_hembras'] ?? 0,
      telefono: json['telefono'] ?? 'Sin teléfono',
      fecha_publicacion: json['fecha_publicacion'] != null ? DateTime.parse(json['fecha_publicacion']) : DateTime.now(),
      estado: json['estado'] ?? 1,
      usuario_id: json['usuario_id'],
      ciudad_id: json['ciudad_id'],
      especie_id: json['especie_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'raza': raza,
      'edad': edad,
      'cantidad_machos': cantidad_machos,
      'cantidad_hembras': cantidad_hembras,
      'telefono': telefono,
      'fecha_publicacion': fecha_publicacion.toIso8601String(),
      'estado': estado,
      'usuario_id': usuario_id,
      'ciudad_id': ciudad_id,
      'especie_id': especie_id,
    };
  }
}