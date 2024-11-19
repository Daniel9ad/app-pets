import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:app_pets/data/models/pet.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app_pets/features/publicaciones/pages/publication_detail_page.dart';



class PetCard extends StatelessWidget {
  final Pet pet;

  const PetCard({Key? key, required this.pet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        
        
          
          _buildImage(),
          Expanded(child: _buildPetDetails()),
          
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          child: Image.network(
            pet.imageUrl,
            width: double.infinity,
            height: 150,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Image.asset(
              'assets/image.png',
              width: double.infinity,
              height:150,
              fit: BoxFit.cover,
            ),
          ),
        ),
    
        Positioned(
          bottom: 8,
          right: 8,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
             
            ),
             width: 40,
             height: 40,
             
            child: IconButton(
            icon: const Icon(
              Icons.favorite_border,
              color: Colors.redAccent,
            
            ),
            onPressed: () {},
          ),
          ),
        ),
        pet.enAdopcion 
          ? Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'En adopción',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          )
        : Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Adoptado',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),

         
      ],
    );
  }

  Widget _buildPetDetails() {
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pet.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            '${pet.age} • ${pet.breed}',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
          Text(
            '${pet.distance}',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
         

       Center(
  child: Builder(
    builder: (BuildContext context) {
      return ElevatedButton(
                   style: ElevatedButton.styleFrom(
   backgroundColor: Color.fromRGBO(155, 60, 130, 1), 
                  foregroundColor : Colors.white, 
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),

  ),
  onPressed: () { 
//  Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => DetallesScreen(petId: pet.id),
//                     ),
//                   );

  },
  child: Text('ver detalles'),
),
      
        ),
        ],
      ),
    ),
  );
}

}