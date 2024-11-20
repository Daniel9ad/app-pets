import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import 'package:logger/logger.dart';

class AuthManager {
  static final AuthManager _instance = AuthManager._internal();
  factory AuthManager() => _instance;

  AuthManager._internal() {
    checkAuthState();
  }

  final storage = const FlutterSecureStorage();
  final _authStateController = StreamController<bool>.broadcast();

  Stream<bool> get authStateStream => _authStateController.stream;

  Future<void> saveSession(String session) async {
    await storage.write(key: 'auth_session', value: session);
    Logger().d('Session saved, updating stream');
    _authStateController.add(true);
  }

  Future<String?> getSession() async {
    return await storage.read(key: 'auth_session');
  }

  Future<void> deleteSession() async {
    await storage.delete(key: 'auth_session');
    _authStateController.add(false);
  }

  Future<void> checkAuthState() async {
    final String? tokenString = await getSession();
    _authStateController.add(tokenString != null);
  }

  Future<void> dispose() async {
    await _authStateController.close();
  }
}