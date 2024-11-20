class PublicacionModel {
  String titulo;
  String descripcion;
  String raza;
  int edad;
  int cantidadMachos;
  int cantidadHembras;
  String telefono;
  int usuarioId;
  int ciudadId;
  int especieId;

  PublicacionModel({
    required this.titulo,
    required this.descripcion,
    required this.raza,
    required this.edad,
    required this.cantidadMachos,
    required this.cantidadHembras,
    required this.telefono,
    required this.usuarioId,
    required this.ciudadId,
    required this.especieId,
  });

  Map<String, dynamic> toJson() => {
        "titulo": titulo,
        "descripcion": descripcion,
        "raza": raza,
        "edad": edad,
        "cantidad_machos": cantidadMachos,
        "cantidad_hembras": cantidadHembras,
        "telefono": telefono,
        "usuario_id": usuarioId,
        "ciudad_id": ciudadId,
        "especie_id": especieId,
      };
}
