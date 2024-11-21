import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_pets/data/models/misPublicaciones.dart';
import 'package:app_pets/core/constants.dart';

class UsePublicaciones extends ChangeNotifier {
  List<Publicacion> publicaciones = [];
  bool isLoading = false;

  Future<void> fetchPublicaciones(int usuarioId) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('$backendUrl/publicaciones/usuario/$usuarioId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        publicaciones = (data as List)
            .map((publicacion) => Publicacion.fromJson(publicacion))
            .toList();
      } else {
        publicaciones = [];
      }
    } catch (e) {
      publicaciones = [];
    }

    isLoading = false;
    notifyListeners();
  }
}
