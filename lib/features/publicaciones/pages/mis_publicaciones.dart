import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_pets/data/api/hook_mispublicaciones.dart';
import 'package:app_pets/features/publicaciones/Widget/mis_publicaciones_card.dart';
import 'package:app_pets/auth/auth_service.dart';

class PublicacionesPage extends StatefulWidget {
  const PublicacionesPage({Key? key}) : super(key: key);

  @override
  _PublicacionesPageState createState() => _PublicacionesPageState();
}

class _PublicacionesPageState extends State<PublicacionesPage> {
  late int usuarioId;
  bool isLoading = true;

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadUsuarioId();
  }

  Future<void> _loadUsuarioId() async {
    try {
      final id = await _authService.getAuthenticatedUserId();
      setState(() {
        usuarioId = id;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al obtener el usuario autenticado: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return ChangeNotifierProvider(
      create: (_) => UsePublicaciones()..fetchPublicaciones(usuarioId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mis Publicaciones'),
        ),
        body: Consumer<UsePublicaciones>(
          builder: (context, hook, _) {
            if (hook.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (hook.publicaciones.isEmpty) {
              return const Center(child: Text('No tienes publicaciones.'));
            }

            return ListView.builder(
              itemCount: hook.publicaciones.length,
              itemBuilder: (context, index) {
                final publicacion = hook.publicaciones[index];
                return PublicacionCard(publicacion: publicacion);
              },
            );
          },
        ),
      ),
    );
  }
}
