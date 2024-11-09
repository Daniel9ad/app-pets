import 'dart:convert';
import 'package:app_pets/core/constants.dart';
import 'package:app_pets/data/models/publication_detail.dart';
import 'package:http/http.dart' as http;
//import 'package:logger/logger.dart';

class PublicationApi {
  Future<PublicationDetail> getPublicationById(int id) async {
    final response = await http.get(
      Uri.parse('$backendUrl/publicacion/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      //Logger().d('JSON respuesta: ${response.body}');
      final body = jsonDecode(response.body);

      return PublicationDetail.fromJson(body);
    } else {
      throw Exception('Error al obtener la publicación: ${response.statusCode}');
    }
  }
}
