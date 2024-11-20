import 'package:app_pets/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:app_pets/auth/auth_manager.dart';
import 'package:app_pets/features/login/page/login_page.dart';
import 'package:app_pets/features/publicaciones/pages/pet_grid.dart';
import 'package:app_pets/features/publicaciones/pages/crear_publicacion_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthManager authManager = AuthManager();
  final AuthService _authService = AuthService();
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: authManager.authStateStream,
      builder: (context, snapshot) {
        // Determinar si el usuario está autenticado
        final bool isAuthenticated = snapshot.data ?? false;

        // Páginas dinámicas
        List<Widget> pages = [
          const PetGrid(),
          const Text("Listado"),
          isAuthenticated ? const Text("Perfil autenticado") : const LoginPage(),
        ];

        return Theme(
          data: Theme.of(context),
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              forceMaterialTransparency: true,
              elevation: 0,
              actions: [
                isAuthenticated 
                  ? IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () async {
                        await _authService.logout();
                        await authManager.checkAuthState();
                      },
                    )
                  : IconButton(
                      icon: const Icon(Icons.login),
                      onPressed: () async {
                        setState(() {
                          _selectedIndex = 2;
                        });
                      },
                    )
              ],
            ),
            body: pages[_selectedIndex],
            bottomNavigationBar: NavigationBar(
              elevation: 2,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home),
                  label: 'Inicio',
                ),
                NavigationDestination(
                  icon: Icon(Icons.list),
                  label: 'Listado',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person),
                  label: 'Perfil',
                ),
              ],
            ),
            floatingActionButton: _selectedIndex == 0
                ? FloatingActionButton(
                    backgroundColor: Colors.orange,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CrearPublicacionPage(),
                        ),
                      );
                    },
                    child: const Icon(Icons.add),
                    tooltip: 'Crear Publicación',
                  )
                : null,
          ),
        );
      },
    );
  }
}
