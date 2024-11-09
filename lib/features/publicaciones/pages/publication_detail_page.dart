import 'package:flutter/material.dart';
import 'package:app_pets/data/api/publication_detail.dart';
import 'package:app_pets/data/models/publication_detail.dart';
import 'package:logger/logger.dart';

class PublicationDetailPage extends StatefulWidget {
  final int publicationId;

  const PublicationDetailPage({Key? key, required this.publicationId}) : super(key: key);

  @override
  _PublicationDetailPageState createState() => _PublicationDetailPageState();
}

class _PublicationDetailPageState extends State<PublicationDetailPage> {
  late Future<PublicationDetail> publicationFuture;

  @override
  void initState() {
    super.initState();
    Logger().i('Iniciando la carga de la publicación con ID: ${widget.publicationId}');
    publicationFuture = PublicationApi().getPublicationById(widget.publicationId);

    publicationFuture.then((value) {
      Logger().i('Publicación cargada: ${value.toJson()}');
    }).catchError((error) {
      Logger().e('Error al cargar la publicación: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de la Publicación'),
      ),
      body: FutureBuilder<PublicationDetail>(
        future: publicationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final publication = snapshot.data!;
            Logger().i('Detalles de la publicación: ${publication.toJson()}');
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 250.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                        image: AssetImage('assets/placeholder.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    publication.titulo,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Descripción: ${publication.descripcion}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Edad: ${publication.edad} años',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Raza: ${publication.raza}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Ciudad: ${publication.ciudad_id}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Teléfono de contacto: ${publication.telefono}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Publicado el: ${publication.fecha_publicacion.toLocal().toString().split(' ')[0]}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No se encontraron datos'));
          }
        },
      ),
    );
  }
}
