import 'package:app_pets/features/publicaciones/Widget/carousel.dart';
import 'package:flutter/material.dart';
import 'package:app_pets/data/api/publication_detail.dart';
import 'package:app_pets/data/models/publication_detail.dart';

import '../Widget/detail_publication.dart';

//import 'package:logger/logger.dart';

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
    //Logger().i('Iniciando la carga de la publicación con ID: ${widget.publicationId}');
    super.initState();
    publicationFuture = PublicationApi().getPublicationById(widget.publicationId);
    publicationFuture.then((value) {
      //Logger().i('Publicación cargada: $value');
    }).catchError((error) {
      //Logger().e('Error al cargar la publicación: $error');
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
            //Logger().i('Detalles de la publicación: $publication');

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (publication.imagenes.isNotEmpty)
                  PublicationCarousel(images: publication.imagenes),
                  const SizedBox(height: 20),
                  PublicationInfo(
                  titulo: publication.titulo,
                  descripcion: publication.descripcion,
                  edad: publication.edad,
                  raza: publication.raza,
                  ciudad: publication.ciudad,
                  telefono: publication.telefono,
                  usuario: publication.usuario,
                  especie: publication.especie,
                  estado: publication.estado,
                  fechaPublicacion: publication.fechaPublicacion,
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
