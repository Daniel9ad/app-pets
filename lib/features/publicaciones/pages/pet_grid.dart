
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:app_pets/data/models/pet.dart';

import 'package:app_pets/data/api/hook_publicaciones.dart';
import 'package:app_pets/features/publicaciones/Widget/pet_card.dart';
import 'package:app_pets/features/publicaciones/Widget/pet_filter.dart';


class PetGrid extends StatefulWidget {
  const PetGrid({Key? key}) : super(key: key);

  @override
  _PetGridState createState() => _PetGridState();
}

class _PetGridState extends State<PetGrid> {
  List<Pet> pets = [];
  bool isLoading = true;
  int especieId = 0;

  @override
  void initState() {
    super.initState();
    fetchPets();
  }

Future<void> fetchPets([int? especieId]) async {
  try {
    final petService = PublicacionesApi();
    pets = await petService.fetchAvailablePets(especieId); 
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

  void _onFilterSelected(int filterId) {
   
    fetchPets(filterId); 
  }
  @override
  Widget build(BuildContext context) {
  return Column(
      children: [
        PetFilter(onFilterSelected: _onFilterSelected), 
        Expanded(
          child: isLoading
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
                ),
        ),
      ],
    );
  }
}