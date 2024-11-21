class Publicacion {
  final int id;
  final String titulo;
  final String raza;
  final int edad;
  final String ciudad;
  final String urlImagen;
    final bool estado;

  Publicacion({
    required this.id,
    required this.titulo,
    required this.raza,
    required this.edad,
    required this.ciudad,
    required this.urlImagen,
      required this.estado,
  });

  factory Publicacion.fromJson(Map<String, dynamic> json) {
    return Publicacion(
      id: json['id'],
      titulo: json['titulo'],
      raza: json['raza'],
      edad: json['edad'],
      ciudad: json['ciudad'] ?? 'Sin ciudad',
      urlImagen: json['imagen']['urlIMG'] ?? 'https://via.placeholder.com/150',
      estado: json['estado'] ?? false,
    );
  }
}
