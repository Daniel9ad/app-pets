import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:app_pets/data/api/publication_detail.dart';
import 'package:app_pets/data/models/publication_detail.dart';
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
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 250.0,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: false,
                      ),
                      items: publication.imagenes.map((url) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Image.network(
                                url,
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                              ),
                            );
                          },
                        );
                      }).toList(),
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
                    'Ciudad: ${publication.ciudad}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Teléfono de contacto: ${publication.telefono}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Usuario: ${publication.usuario}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Especie: ${publication.especie}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Estado: ${publication.estado == 1 ? "Activo" : "Inactivo"}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Publicado el: ${publication.fechaPublicacion.toLocal().toString().split(' ')[0]}',
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
