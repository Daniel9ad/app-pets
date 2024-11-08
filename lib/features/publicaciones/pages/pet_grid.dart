
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:app_pets/data/models/pet.dart';
import 'package:app_pets/data/api/pet_service.dart';
import 'package:app_pets/features/publicaciones/Widget/pet_card.dart';


class PetGrid extends StatefulWidget {
  const PetGrid({Key? key}) : super(key: key);

  @override
  _PetGridState createState() => _PetGridState();
}

class _PetGridState extends State<PetGrid> {
  List<Pet> pets = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPets();
  }

Future<void> fetchPets() async {
  try {
    final petService = PetService();
    pets = await petService.fetchAvailablePets();  // Usa la instancia aquí
    setState(() {
      isLoading = false;
    });
  } catch (e) {
    // Logger().e('Error: $e');
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
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.75,
              ),
              itemCount: pets.length,
              itemBuilder: (context, index) {
                final pet = pets[index];
                return PetCard(pet: pet);
              },
            ),
          );
  }
}
