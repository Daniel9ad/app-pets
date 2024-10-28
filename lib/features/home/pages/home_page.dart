// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    Text("Inicio"),
    Text("Listado"),
    Text("Perfil"),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          forceMaterialTransparency: true,
          elevation: 0,
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: NavigationBar(
          elevation: 2,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home),
              label: 'Incio',
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
        )
      ),
    );
  }
}