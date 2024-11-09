class Pet {
  final int id;
  final String name;
  final String age;
  final String breed;
  final String distance;
  final String imageUrl;
  final bool enAdopcion;


  Pet({
    required this.id,
    required this.name,
    required this.age,
    required this.breed,
    required this.distance,
    required this.imageUrl,
    required this.enAdopcion,

  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      name: json['titulo'] ?? 'Desconocido',
      age: json['edad']?.toString() ?? 'N/A',
      breed: json['raza'] ?? 'Desconocida',
      distance: json['ciudad'] ?? 'Sin especificar',
      imageUrl: json['imagen']?['urlIMG'] ?? 'https://via.placeholder.com/150',
      enAdopcion:json['disponible'] == 1,
      
    );
  }
}
