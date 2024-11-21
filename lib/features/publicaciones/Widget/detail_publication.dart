import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class PublicationInfo extends StatelessWidget {
  final String titulo;
  final String descripcion;
  final int edad;
  final String raza;
  final String ciudad;
  final String telefono;
  final String usuario;
  final String especie;
  final int estado;
  final DateTime fechaPublicacion;

  const PublicationInfo({
    Key? key,
    required this.titulo,
    required this.descripcion,
    required this.edad,
    required this.raza,
    required this.ciudad,
    required this.telefono,
    required this.usuario,
    required this.especie,
    required this.estado,
    required this.fechaPublicacion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Etiqueta "en adopción"
        if (estado == 1)
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'en adopción',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        const SizedBox(height: 20),

        // Encabezado de información
        const Text(
          'Información',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Divider(thickness: 1, color: Colors.black),
        const SizedBox(height: 10),

        // Filas de información
        buildInfoRow('Nombre', titulo),
        buildInfoRow('Raza', raza),
        buildInfoRow('Edad', '$edad meses'),
        buildInfoRow('Ciudad', ciudad),
        buildInfoRow('Publicado el', DateFormat('dd-MM-yyyy').format(fechaPublicacion),),
        
        const SizedBox(height: 20),

        // Botón "Contactar al dueño"
        Center(
          child: ElevatedButton.icon(
            onPressed: () async {
              // Código de país y número de teléfono
              const String countryCode = '591'; 
              final String rawPhoneNumber = telefono.trim(); // Teléfono ingresado
              final String completePhoneNumber = '$countryCode$rawPhoneNumber';

              // Mensaje predefinido
              final String message = '¡Hola! Estoy interesado en adoptar la mascota publicada "$titulo". ¿Podemos hablar?';

              // Codificamos el mensaje para URL
              final String encodedMessage = Uri.encodeComponent(message);

              // Construimos la URL de WhatsApp con el mensaje
              final String whatsappUrl = 'https://wa.me/$completePhoneNumber?text=$encodedMessage';

              try {
                final Uri url = Uri.parse(whatsappUrl);

                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } else {
                  throw 'No se pudo abrir WhatsApp.';
                }
              } catch (e) {
                // Mostrar mensaje de error si algo falla
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple, // Color de fondo
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
            ),
            icon: const FaIcon(
              FontAwesomeIcons.whatsapp,
              color: Colors.white,
            ),
            label: const Text(
              'Contactar al dueño',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  // Método para construir filas de información
  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
