import 'dart:convert';
import 'package:app_pets/core/constants.dart';
import 'package:app_pets/data/models/user.dart';
import 'package:app_pets/data/models/pet.dart';
import 'package:logger/logger.dart';
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


 Future<List<Pet>> fetchAvailablePets( int? especieId ) async {
    List<Pet> pets = [];
     
    final url =(especieId != 0 && especieId != null)
        ? '$backendUrl/publicaciones/disponibles?especie=$especieId'
        : '$backendUrl/publicaciones/disponibles';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    final body = jsonDecode(response.body);
    Logger().i("Respuesta: $body");
    if (body['transaction']) {
      List<dynamic> dataJson = body['data'];
      pets = dataJson.map((dynamic item) {
        try {
          return Pet.fromJson(item);
        } catch (e) {
          // Manejar el error de parsing
          return null;
        }
      }).whereType<Pet>().toList();
    } else {
      throw Exception(body['message']);
    }

    return pets;
  }

}