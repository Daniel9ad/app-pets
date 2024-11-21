import 'package:flutter/material.dart';

class PetFilter extends StatefulWidget {
  final Function(int) onFilterSelected;

  const PetFilter({Key? key, required this.onFilterSelected}) : super(key: key);

  @override
  _PetFilterState createState() => _PetFilterState();
}

class _PetFilterState extends State<PetFilter> {
  int selectedFilterId = 0; // Estado para controlar el botón seleccionado

  void _handleFilterSelection(int filterId) {
    setState(() {
      selectedFilterId = filterId; // Actualiza el estado al hacer clic en un botón
    });
    widget.onFilterSelected(filterId); // Notifica al padre del filtro seleccionado
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildFilterButton(
          icon: 'assets/icons/All_icon.png',
          filterId: 0,
        ),
        const SizedBox(width: 20),
        _buildFilterButton(
          icon: 'assets/icons/Dog_icon.png',
          filterId: 1,
        ),
        const SizedBox(width: 20),
        _buildFilterButton(
          icon: 'assets/icons/Cat_icon.png',
          filterId: 2,
        ),
      ],
    );
  }

  Widget _buildFilterButton({required String icon, required int filterId}) {
    final bool isSelected = selectedFilterId == filterId; // Verifica si este botón está seleccionado

    return GestureDetector(
      onTap: () {
        _handleFilterSelection(filterId);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(10),
        child: Image.asset(
          icon,
          width: 50,
          height: 50,
          color: isSelected ? Colors.purple : Colors.orange, // Cambia el color del ícono
        ),
      ),
    );
  }
}
