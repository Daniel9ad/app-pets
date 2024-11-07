// pet_grid.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PetGrid extends StatefulWidget {
  const PetGrid({super.key});

  @override
  _PetGridState createState() => _PetGridState();
}

class _PetGridState extends State<PetGrid> {
  List<dynamic> pets = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPets();
  }

  Future<void> fetchPets() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8000/api/publicaciones/disponibles'));
print(response.body);

      if (response.statusCode == 200) {
        setState(() {
          pets = json.decode(response.body);
          isLoading = false;
        });
      } else {
        // Manejar error de la solicitud
        throw Exception('Error al cargar los datos');
      }
    } catch (e) {
      // Manejar errores de conexión u otros problemas
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {


    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Número de columnas
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.75, // Ajusta el aspecto de las tarjetas
              ),
              
              itemCount: pets.length,
              itemBuilder: (context, index) {
                final pet = pets[index];
                const baseUrl = 'http://localhost:8000';
String imageUrl = pet['imagen'] != null ? '$baseUrl${pet['imagen']['urlIMG']}' : 'https://via.placeholder.com/150';

                return PetCard(
                  name: pet['titulo'],
                  age: pet['edad'].toString(),
                  breed: pet['raza'],
                  distance: pet['ciudad'],
                  imageUrl: imageUrl,
                  isPerfectMatch: pet['disponible'] == 1,
                );
              },
            ),
          );
  }
}

class PetCard extends StatelessWidget {
  final String name;
  final String age;
  final String breed;
  final String distance;
  final String imageUrl;
  final bool isPerfectMatch;

  const PetCard({
    super.key,
    required this.name,
    required this.age,
    required this.breed,
    required this.distance,
    required this.imageUrl,
    this.isPerfectMatch = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                   // Ajusta la altura de la imagen
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/placeholder.png', // Una imagen local de reserva
                      width: double.infinity,
                      
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(
                    Icons.favorite_border,
                    color: Colors.redAccent,
                  ),
                  onPressed: () {
                    // Acción al dar clic en el botón
                  },
                ),
              ),
              if (isPerfectMatch)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Perfect Match',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '$age • $breed',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
                Text(
                  distance,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
