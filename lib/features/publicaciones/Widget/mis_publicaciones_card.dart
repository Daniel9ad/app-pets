import 'package:flutter/material.dart';
import 'package:app_pets/data/models/misPublicaciones.dart';
import 'package:app_pets/core/constants.dart';
import 'package:http/http.dart' as http;

class PublicacionCard extends StatefulWidget {
  final Publicacion publicacion;

  const PublicacionCard({Key? key, required this.publicacion}) : super(key: key);

  @override
  _PublicacionCardState createState() => _PublicacionCardState();
}

class _PublicacionCardState extends State<PublicacionCard> {
  late bool isDisponible;

  @override
  void initState() {
    super.initState();
    isDisponible = widget.publicacion.estado;
  }

  Future<void> cambiarEstado(BuildContext context) async {
    final url = '$backendUrl/publicaciones/${widget.publicacion.id}/estado';
    try {
      final response = await http.put(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        setState(() {
          isDisponible = !isDisponible;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Estado cambiado correctamente')),
        );
      } else {
        throw Exception('Error al cambiar el estado');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> eliminarPublicacion(BuildContext context) async {
    final url = '$backendUrl/publicaciones/${widget.publicacion.id}';
    try {
      final response = await http.delete(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Publicación eliminada')),
        );
        // Actualiza la UI después de eliminar (si es necesario)
        Navigator.pop(context, true); // Indica al padre que actualice la lista
      } else {
        throw Exception('Error al eliminar la publicación');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shadowColor: Colors.purple.withOpacity(0.5),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.network(
              widget.publicacion.urlImagen,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 100, color: Colors.grey),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.publicacion.titulo,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.pets, color: Colors.orange, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      'Raza: ${widget.publicacion.raza}',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cake, color: Colors.pink, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      'Edad: ${widget.publicacion.edad} años',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on, color: Colors.purple, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      'Ciudad: ${widget.publicacion.ciudad}',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Estado: ${isDisponible ? "no Disponible" : " disponible"}',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDisponible ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => cambiarEstado(context),
                style: TextButton.styleFrom(
                  backgroundColor: isDisponible ? Colors.green : Colors.grey,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: Text(
                  isDisponible ? 'Desactivar' : 'Activar',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () => eliminarPublicacion(context),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
