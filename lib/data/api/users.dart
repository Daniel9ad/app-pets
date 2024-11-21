import 'dart:convert';
import 'package:app_pets/core/constants.dart';
import 'package:app_pets/data/models/user.dart';
//import 'package:app_pets/data/models/pet.dart';
//import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

class UserApi {
  Future<List<User>> getAllUsers() async {
    List<User> users = [];
  
    final response = await http.get(
      Uri.parse('$backendUrl/usuarios'),
      headers: {
        'Content-Type': 'application/json',
      }
    );
    final body = jsonDecode(response.body);
    // Logger().i("Respuesta: $body");
    if (body['transaction']) {
      List<dynamic> dataJson = body['data']; 
      users = dataJson.map((dynamic item) => User.fromJson(item)).toList();
      return users;
    } else {
      // Logger().e("Error:${response.body}");
      throw Exception(body['message']);
    }
  }

  // Método para registrar un nuevo usuario (POST)
  Future<bool> registerUser(User user) async {
    try {
      final response = await http.post(
        Uri.parse('$backendUrl/usuarios'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(user.toJson()), // Convierte el usuario a JSON
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 201) {
        // Registro exitoso
        return true;
      } else {
        // Error del servidor
        throw Exception(body['message']);
      }
    } catch (e) {
      // Manejo de errores en la conexión
      //print('Error al registrar usuario: $e');
      rethrow;
    }
  }

  // Método para actualizar un usuario existente (PUT)
  Future<bool> updateUser(int id, User user) async {
    try {
      final response = await http.put(
        Uri.parse('$backendUrl/usuarios/$id'), // Endpoint con el ID del usuario
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(user.toJson()), // Convierte los datos del usuario a JSON
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Actualización exitosa
        return true;
      } else {
        // Error del servidor
        throw Exception(body['message']);
      }
    } catch (e) {
      // Manejo de errores en la conexión
      print('Error al actualizar usuario: $e');
      rethrow;
    }
  }


}