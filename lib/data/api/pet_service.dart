import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_pets/core/constants.dart';  //  "http://localhost:8000/api";
import 'package:app_pets/data/models/pet.dart';

class PetService{
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
