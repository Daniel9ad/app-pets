import 'dart:io';
import 'package:dio/dio.dart';
import '../models/PublicacionModel.dart';
import 'dart:convert';

class PublicacionApi {
  final Dio _dio = Dio();

  Future<bool> crearPublicacion(
  PublicacionModel publicacion,
  List<File> imagenes,
) async {
  try {
    // Convertir las imágenes a Base64
    final List<String> imagenesBase64 = imagenes.map((img) {
      final bytes = img.readAsBytesSync();
      return base64Encode(bytes);
    }).toList();

    final data = {
      ...publicacion.toJson(),
      "imagenes": imagenesBase64, // Agregar imágenes codificadas
    };

    final response = await _dio.post(
      "http://192.168.100.123:8000/api/crearpublicacion",
      data: data,
    );

    return response.statusCode == 201;
  } catch (e) {
    throw Exception("Error al crear la publicación: $e");
  }
}
}
