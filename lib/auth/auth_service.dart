import 'dart:convert';
import 'dart:io';
import 'package:app_pets/auth/auth_manager.dart';
import 'package:app_pets/core/constants.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final AuthManager authManager = AuthManager();

  Future<Map> getUserData() async {
    String? session = await authManager.getSession();
    if (session == null) {
      throw Exception("Error session no encontrado");
    }
    return await jsonDecode(session);
  }
  
Future<int> getAuthenticatedUserId() async {
  final userData = await getUserData();
  return userData['id'];
}


  Future<void> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$backendUrl/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode==200) {
      Logger().i("Data:$data");
      final user = data['user'];
      Logger().i("user :$user");
      await authManager.saveSession(jsonEncode(user));
    } else {
      Logger().e("Error:${response.body}");
      throw Exception("Error login");
    }
  }

  // Future<void> register(
  //   String username, 
  //   String password, 
  //   String name,
  //   String lastName1, 
  //   String lastName2, 
  //   String ci, 
  //   String phone
  // ) async {
  //   final movilId = await _getDeviceId();
  //   // const String movilId = "66261162-16d5-4ad3-9b9b-8c05a373ad60";
  //   Logger().i("Movil:$movilId");
  //   const aplicacionId = "1";

  //   if (movilId == null) {
  //     throw Exception("Error al obtener el ID del dispositivo");
  //   }

  //   final response = await http.post(
  //     Uri.parse('$seguridadApiUrl/autenticacion/registro'),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'movil_id': movilId,
  //       'aplicacion_id': aplicacionId
  //     },
  //     body: jsonEncode({
  //       'usuario': username,
  //       'contraseña': password,
  //       'nombre_completo': name,
  //       'primer_apellido': lastName1,
  //       'segundo_apellido': lastName2,
  //       'ci': ci,
  //       'celular': phone
  //     }),
  //   );

  //   final data = jsonDecode(response.body);
  //   Logger().i("DATAAA:$data");
  //   if (data['status'] != 401) {
  //     await login(username, password);
  //     // return response.body;
  //   } else {
  //     Logger().e("Error:${response.body}");
  //     throw Exception(data['message']);
  //   }
  // }

  Future<void> logout() async {
    await authManager.deleteSession();
  }
}
