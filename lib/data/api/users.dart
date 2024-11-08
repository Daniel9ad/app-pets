import 'dart:convert';
import 'package:app_pets/core/constants.dart';
import 'package:app_pets/data/models/user.dart';
import 'package:app_pets/data/models/pet.dart';
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


 Future<List<Pet>> fetchAvailablePets() async {
    List<Pet> pets = [];
    final response = await http.get(
      Uri.parse('$backendUrl/publicaciones/disponibles'),
      headers: {
        'Content-Type': 'application/json',
      }
    );
    final body = jsonDecode(response.body);
    if (body['transaction']) {
      List<dynamic> dataJson = body['data']; 
      pets = dataJson.map((dynamic item) => Pet.fromJson(item)).toList();
      return pets;
    } else {
      throw Exception(body['message']);
    }
  }


}