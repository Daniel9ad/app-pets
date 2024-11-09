class PublicationDetail {
  final String titulo;
  final String descripcion;
  final String raza;
  final int edad;
  final int cantidadMachos;
  final int cantidadHembras;
  final String telefono;
  final DateTime fechaPublicacion;
  final int estado;
  final String ciudad;
  final String usuario;
  final String especie;
  final List<String> imagenes;

  PublicationDetail({
    required this.titulo,
    required this.descripcion,
    required this.raza,
    required this.edad,
    required this.cantidadMachos,
    required this.cantidadHembras,
    required this.telefono,
    required this.fechaPublicacion,
    required this.estado,
    required this.ciudad,
    required this.usuario,
    required this.especie,
    required this.imagenes,
  });

  factory PublicationDetail.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return PublicationDetail(
      titulo: data['titulo'] ?? 'Sin título',
      descripcion: data['descripcion'] ?? 'Sin descripción',
      raza: data['raza'] ?? 'Sin raza',
      edad: data['edad'] ?? 0,
      cantidadMachos: data['cantidad_machos'] ?? 0,
      cantidadHembras: data['cantidad_hembras'] ?? 0,
      telefono: data['telefono'] ?? 'Sin teléfono',
      fechaPublicacion: data['fecha_publicacion'] != null
          ? DateTime.parse(data['fecha_publicacion'])
          : DateTime.now(),
      estado: data['estado'] ?? 0,
      ciudad: data['ciudad'] ?? 'Sin ciudad',
      usuario: data['usuario'] ?? 'Sin usuario',
      especie: data['especie'] ?? 'Sin especie',
      imagenes: (data['imagenes'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'descripcion': descripcion,
      'raza': raza,
      'edad': edad,
      'cantidad_machos': cantidadMachos,
      'cantidad_hembras': cantidadHembras,
      'telefono': telefono,
      'fecha_publicacion': fechaPublicacion.toIso8601String(),
      'estado': estado,
      'ciudad': ciudad,
      'usuario': usuario,
      'especie': especie,
      'imagenes': imagenes,
    };
  }
}
