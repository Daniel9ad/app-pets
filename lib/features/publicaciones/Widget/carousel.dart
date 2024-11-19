import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PublicationCarousel extends StatefulWidget {
  final List<String> images;

  const PublicationCarousel({Key? key, required this.images}) : super(key: key);

  @override
  _PublicationCarouselState createState() => _PublicationCarouselState();
}

class _PublicationCarouselState extends State<PublicationCarousel> {
  int activeIndex = 0; // Índice activo del carrusel

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 300.0,
            aspectRatio: 16 / 9,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            enlargeCenterPage: true,
            enableInfiniteScroll: true,
            onPageChanged: (index, reason) {
              setState(() {
                activeIndex = index; // Actualiza el índice activo
              });
            },
          ),
          items: widget.images.map((url) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      url,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        AnimatedSmoothIndicator(
          activeIndex: activeIndex, // Índice activo
          count: widget.images.length, // Número total de imágenes
          effect: ExpandingDotsEffect(
            activeDotColor: Colors.purple, // Color del punto activo
            dotColor: Colors.grey, // Color de los puntos inactivos
            dotHeight: 10,
            dotWidth: 10,
          ),
        ),
      ],
    );
  }
}
