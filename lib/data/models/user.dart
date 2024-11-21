class User {
  final int id;
  final String nombre;
  final String apellido;
  final String email;
  final String password;
  final String telefono; 

  User({
 
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      email: json['email'],
      password: json['password'],
      telefono: json['telefono'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'email': email,
      'password': password,
      'telefono': telefono
    };
  }
}